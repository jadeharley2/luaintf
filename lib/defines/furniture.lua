
mirror = Def('mirror','thing') 
mirror.image = '/img/items/mirror.png'  
mirror.examine = function(s) 
    if player.robotic then
        printout('scanning mirror surface...')
    else
        printout('you look into mirror and see..')
    end
    printout('$display:target;clear')
    examine(player)
    

    printout('$display:target;mirror;/img/background/mirror.png') 
    local img = player.image
    if img then printout('$display:target;'..player.id..';'..img..';'..player.image_style_css) end

    printout('$display:target;mirror_over;/img/background/mirror_overlay.png;') 
    
end



bed = Def('bed','thing')
bed:interact_add(sit_interaction)
bed:interact_add(lay_interaction)
bed.image = '/img/items/bed.png'


chair = Def('chair','thing')
chair:interact_add(sit_interaction)


sofa = Def('sofa','chair')
sofa.capacity = 3

table_furniture = Def('table_furniture','thing')


cabinet = Def('cabinet','thing')




open_interaction = Def('open_interaction',{key='open',user_restrictions = {"!asleep"},callback = function(self,user) 
    self:call('open',user)
    return true;
end},'interaction') 
close_interaction = Def('close_interaction',{key='close',user_restrictions = {"!asleep"},callback = function(self,user) 
    self:call('close',user)
    return true;
end},'interaction') 

 
cabinet:interact_add(open_interaction)
cabinet:interact_add(close_interaction)

function cabinet:can_unlock(user) 
    for k,v in pairs(self.keys or {}) do
        if v.location == user then 
            return true
        end
    end
    return false
end
function cabinet:open(user)
    if not self:is('opened') then
        if self:is('locked') then
            if not self:unlock(user) then
                return
            end
        end
        self:adj_set('opened')
        describe_action(user,L'you open [self]',L"[user] opens [self]")  
        if user==player then
            examine(self)
        end
    end
end
function cabinet:close(user) 
    if self:is('opened') then
        self:adj_unset('opened')
        describe_action(user,L'you close [self]',L"[user] closes [self]")  
        if user==player then
            examine(self)
        end
    end
end






function cabinet:examine(user)
    thing.examine(self,user)
    
    if self:is('opened') or user:is_inside(self) then
        printout('$display:clothes;clear')
        local things = self:collect('contains',function(k,v) 
            if k.image then
                printout('$display:clothes;'..k.id..';'..k.image..';'..k.image_style_css)
            end
            return k 
        
        end)
        if #things>0 then
            printout(L'[self] contains: '..table.concat(things,', '))   
        else
            printout(L'[self] is empty') 
        end
        if not self:is('opened') then
            printout(L'[self] is closed') 
        end
    else
        printout(L'[self] is closed') 
    end
end
cabinet.get_reachables = function(self, user, output)  
    output[#output+1] = self
    if self:is('opened') or user:is_inside(self) then
        self:foreach('contains',function(k,v)
            local r = k.get_reachables 
            output[#output+1] = k
            if r then 
                r(k,user,output)
            end 
        end)
    end 
end





lockable = Def('lockable','adjective')

function lockable:_get_is_locked()
    return self:is('locked')
end
function lockable:lock(user)
    if user then
        if self:is('locked') then
            printto(user,L"[self] is already locked")
            return false
        else
            if self:can_unlock(user) then
                describe_action(user,L'you lock [self]')  
                self:adj_set('locked')
                return true
            else
                describe_action(user,L'you try to lock [self] but you dont have the key',L"[user] fiddles with [self]'s lock")  
                return false
            end
        end
    else
        self:adj_set('locked')
        return true
    end
end
function lockable:unlock(user)
    if user then
        if self:is('locked') then 
            if self:can_unlock(user) then
                describe_action(user,L'you unlock [self]')  
                self:adj_unset('locked')
                return true
            else
                describe_action(user,L'you try to unlock [self] but you dont have the key',L"[user] fiddles with [self]'s lock")  
                return false
            end
        else
            printto(user,L"[self] is not locked")
            return false
        end
    else
        self:adj_unset('locked')
        return true
    end
end

lock_action = Def('lock_action',{key='lock',user_restrictions = {"!asleep"}, callback = function(self,user) 
    self:lock(user)
    return true;
end},'interaction') 
unlock_action = Def('unlock_action',{key='unlock',user_restrictions = {"!asleep"}, callback = function(self,user) 
    self:unlock(user)
    return true;
end},'interaction') 

lockable:interact_add(lock_action)
lockable:interact_add(unlock_action)






enterable = Def('enterable','adjective')
enterable:interact_add(step_in_interaction)
enterable:interact_add(step_out_interaction) 