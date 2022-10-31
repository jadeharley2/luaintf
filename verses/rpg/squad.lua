
squad = squad or {}

function squad.Create(leader)
    local s = leader.squad
    if not s then 
        s = squad.New(leader)
        leader.squad = s
        leader:adj_set('squad_leader')
        send_squad(leader)
    end
    return s
end
function squad.Join(sqperson,nperson)
    local s = sqperson.squad
    if s then
        s:Join(nperson) 
    end 
end
function squad.Leave(sqperson)
    local s = sqperson.squad
    if s then
        s:Leave(sqperson) 
    end 
end
function squad.Disband(sqperson)
    local s = sqperson.squad
    if s then
        s:Disband() 
    end 
end

function squad.InPlayerSquad(sqperson)
    if player then 
        local s = player.squad
        if s then
            return sqperson.squad == s
        end
    end
    return false
end

squad_meta = squad_meta or {} 
function squad_meta:Join(p)
    if not self.list[p.id] then
        self.list[p.id] = p
        p:adj_set('in_squad')
        p.squad = self
        for k,p2 in pairs(self.list) do 
            send_squad(p2)
        end
    end
end
function squad_meta:Leave(p)
    if p == self.leader then
        self:Disband()
    else
        if self.list[p.id] then
            self.list[p.id] = nil
            p:adj_unset('in_squad')
            p.squad = nil
            send_squad(p)
            for k,p2 in pairs(self.list) do 
                send_squad(p2)
            end
        end
    end
end
function squad_meta:Disband()
    for k,p in pairs(self.list) do
        p:adj_unset('in_squad')
        p.squad = nil 
        send_squad(p)
    end
    self.leader:adj_unset('squad_leader')
    self.leader.squad = nil
    self.leader = nil
    self.list = {}
end
squad_meta.__index = squad_meta

function squad.New(leader)
    local s = setmetatable({leader = leader, list = {[leader.id] = leader}},squad_meta)
    return s 
end


squad_leader = Def('squad_leader',{name = 'squad leader'},'adjective')
squad_leader:event_add('on_move','squad',function(self,from,to)
    local squad = self.squad 
    if squad then
        local temp = player
        for k,v in pairs(squad.list) do
            if v~=self then
                v.location = to  
                if v.player then
                    SETPERSON(v) 
                    examine(to,v) 
                end
            end
        end
        SETPERSON(temp) 
    end
end)  


in_squad = Def('in_squad',{name = 'in squad'},'adjective')

squad_leave_action = Def('squad_leave_action',{key='sq_leave',restrictions = {"!in_combat"},callback = function(self,item)  
    squad.Leave(self)
    return true
end},'action')
squad_create_action = Def('squad_create_action',{key='sq_create',restrictions = {"!in_combat","!in_squad","!squad_leader"},callback = function(self,item)  
    squad.Create(self)
    return true
end},'action')
squad_leader:act_add(squad_leave_action) 
in_squad:act_add(squad_leave_action)  

squad_join_interaction = Def('squad_join_interaction',{key='sq_join',restrictions = {} ,user_restrictions = {"!in_combat"},callback = function(self,user)  
    squad.Join(user,self)
    return true
end},'interaction')
squad_leader:interact_add(squad_join_interaction)
person:act_add(squad_create_action)


debug_interaction = Def('debug_interaction',{key='debug',callback = function(self,item)  
    printout('<orange>'..self:adj_concat()..' '..self.base.id..'</orange>'  )
    return true
end},'interaction')
thing:interact_add(debug_interaction)