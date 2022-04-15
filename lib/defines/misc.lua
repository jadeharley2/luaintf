

no_one = Def('no_one',{name='No one'},'person')
no_mind = no_mind or {}


female  = Def('female',{gender = 'female',their = 'her', they = 'she', are = 'is'},'adjective')
male    = Def('male',  {gender = 'male',their = 'his', they = 'he', are = 'is'},'adjective')
neuter  = Def('neuter',{gender = 'neuter',their = 'its', they = 'it', are = 'is'},'adjective')
plural  = Def('plural',{gender = 'plural',their = 'their', they = 'they', are = 'are'},'adjective')

thing.gender = 'neuter'
thing.their = 'its'
thing.they = 'it'
thing.are = 'is' 



organization = Def('organization','thing')
soverign_state = Def('soverign_state',{name="Soverign state"},'organization')


city = Def('city','thing')

building = Def('building','thing')
thing._get_is_inside_building = function(self)
    return self:foreach_parent(function(s)
        if s:is(building) then
            return true
        end
    end,false)
end


book = Def('book','thing') 
book.description = 'an ordinary book'
book.image = '/img/items/book.png'

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


bedroom = Def('bedroom','room')
kitchen = Def('kitchen','room')
bathroom = Def('bathroom','room')
guestroom = Def('guestroom','room')

--personal things -- outdated -- use owned adjective



personal_room = Def('personal_room','room')
personal_room._get_name = LF[[ [self.prefix] [IF(player==self.owner,"My",self.owner.name.."'s")] [self.postfix] ]]
personal_room.postfix = 'room'
personal_room.owner = no_one


person:response('give me your cloth',function(s,t,str)
    s:say("ok")
    for k,v in pairs(s.clothes) do
        s:act('drop',v.id)
    end
end)



unzip_action = Def('unzip_action',{key='unzip',restrictions = {"!asleep","!animatronic"},callback = function(self) 
    local is_player = self == player 
    local ins = self.costume 
    if ins then
        local w = ins.wearer
        ins.wearer:takeoff(ins) 
        describe_action(w,L'you take off [ins]',tostring(w)..' takes off '..tostring(ins))  
        return true
    end
    return false
end},'action') 


morph_costume = Def('morph_costume','clothing')
morph_costume.on_new_worn_by = function(self, wearer)
    local pm = self.pmorph
    if not pm then 
        pm = Inst(self.morph.id)
        pm.costume = self 
        pm:act_add(unzip_action)
        pm.mind = no_mind
        self.pmorph = pm 
    end
    wearer:foreach('contains',function(x)
        if not x.is_worn then
            x.location = pm
            --pm:act('drop',x)
        end
    end)
    pm.location = wearer.location
    wearer.location = pm
    mind_transfer(wearer,pm) 
 
    ScenarioRun("mind_transformation",pm.id..'_mtf',{
        source = wearer,
        target = pm, 
        duration = 30,
    }) 

    send_character_images_inroom(pm.location)
end
morph_costume.on_rem_worn_by = function(self, wearer)
    local pm = self.pmorph
    pm:foreach('contains',function(x)
        x.location = wearer
        --pm:act('drop',x)
    end)
    wearer.location = pm.location
    pm.location = self
    mind_transfer(pm,wearer)  
 
    ScenarioRun("mind_transformation",wearer.id..'_mtf',{
        source = pm,
        target = wearer, 
        duration = 30,
    },true) 

    send_character_images_inroom(wearer.location)
end
morph_costume.examine = function(self,user)
    if user.costume==self then
        self.location:examine(user)
    else
        morph_costume.base.examine(self,user)
    end
end

m_zipper = Def('m_zipper',{name='zipper'},'thing')
m_zipper.image = '/img/items/zipper.png'


z_puton = Def('z_puton',{key='put_on',user_restrictions = {"!asleep"},callback = function(self,user,target) 
    local is_player = user == player 
    if target then
        local something = LocalIdentify(target)
        if something then
            if something:is(person) and not something.costume then --and something:call("can_wear",self)~=false then
                local loc = something.location
                
                local costume = Inst('morph_costume')
                costume.name = tostring(something)..' costume'
                costume.image = something.image
                something.costume = costume 
                something:act_add(unzip_action)
                --something.mind = no_mind
                costume.pmorph = something 
                costume.location = loc
                something.location = costume
                self.location = nowhere
                send_character_images_inroom(loc)
                describe_action(something,'you collapse on the floor',L"[something] deflates and falls to the floor")  
                return true
            else
                if is_player then printout('you cannot put zipper on '..target) end
            end
        else
            if is_player then printout('there is no '..target) end
        end 
    else
        if is_player then printout('wear what?') end
    end
    return false
end},'interaction') 
m_zipper:interact_add(z_puton)


robot = Def('robot','adjective')
robot.should_wear_clothes = false



open_action = Def('open_action',{key='open',user_restrictions = {"!asleep"},callback = function(self,user) 
    self:call('open',user)
    return true;
end},'interaction') 
close_action = Def('close_action',{key='close',user_restrictions = {"!asleep"},callback = function(self,user) 
    self:call('close',user)
    return true;
end},'interaction') 

 
cabinet = Def('cabinet','thing')

cabinet:interact_add(open_action)
cabinet:interact_add(close_action)
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