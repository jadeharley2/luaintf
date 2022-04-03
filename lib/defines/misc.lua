

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
    if img then printout('$display:target;'..player.id..';'..img) end

    printout('$display:target;mirror_over;/img/background/mirror_overlay.png') 
    
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
        ins.wearer:takeoff(ins) 
    end
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
    pm.location = wearer.location
    wearer.location = pm
    mind_transfer(wearer,pm) 
end
morph_costume.on_rem_worn_by = function(self, wearer)
    local pm = self.pmorph
    pm:foreach('contains',function(x)
        pm:act('drop',x)
    end)
    wearer.location = pm.location
    pm.location = self
    mind_transfer(pm,wearer)  
end



robot = Def('robot','adjective')
robot.should_wear_clothes = false



open_action = Def('open_action',{key='open',restrictions = {"!asleep"},callback = function(self,user) 
    self:call('open',user)
    return true;
end},'interaction') 
close_action = Def('close_action',{key='close',restrictions = {"!asleep"},callback = function(self,user) 
    self:call('close',user)
    return true;
end},'interaction') 

 

cabinet = Def('cabinet','thing')

cabinet:interact_add(open_action)
cabinet:interact_add(close_action)
function cabinet:open(user)
    if not self:is('opened') then
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
    end
end
function cabinet:examine(user)
    thing.examine(self,user)
    
    if self:is('opened') then
        local things = self:collect('contains',function(k,v) return k end)
        if #things>0 then
            printout(L'[self] contains: '..table.concat(things,', ')) 
        else
            printout(L'[self] is empty') 
        end
    else
        printout(L'[self] is closed') 
    end
end
cabinet.get_reachables = function(self, user, output)  
    output[#output+1] = self
    if self:is('opened') then
        self:foreach('contains',function(k,v)
            local r = k.get_reachables 
            output[#output+1] = k
            if r then 
                r(k,user,output)
            end 
        end)
    end 
end