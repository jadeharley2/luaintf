combat = combat or {}

in_combat = Def('in_combat', {name = 'in combat'},"adjective")

flee_action = Def('flee_action',{key='flee',restrictions = {"can_combat"},callback = function(self,item)  
    local ccombat = self.combat
    if ccombat then 
        ccombat:Flee(self)
    else
        self:adj_unset('in_combat')--fix
    end
end},'action')
defend_action = Def('defend_action',{key='defend',restrictions = {"can_combat"},callback = function(self,item)  
    local ccombat = self.combat
    if ccombat then 
        ccombat:Defend(self)
    else
        self:adj_unset('in_combat')--fix
    end
end},'action')
in_combat:act_add(flee_action)
--in_combat:interact_add(attack_interaction)
in_combat:act_add(defend_action)

in_combat:event_add('on_death','combat',function(self)
    --yahz
end) 

attack_interaction = Def('attack_interaction',{key='attack',restrictions = {} ,user_restrictions = {"can_combat"},callback = function(self,user)  
    local ccombat = self.combat
    if ccombat then 
        ccombat:Attack(user,self) 
    elseif not self:is('dead') then
        combat.Begin({{user},{self}})
    end
end},'interaction')
person:interact_add(attack_interaction)

combat_meta = combat_meta or {}

function combat_meta:Begin(sides)
    --expand sides squads
    local nsides = {}
    for k,v in pairs(sides) do
        local side = {}
        for k2,v2 in pairs(v) do
            local s = v2.squad 
            if s then
                for k3,v3 in pairs(s.list) do
                    side[v3.id] = v3
                end
            else
                side[v2.id] = v2
            end
        end
        nsides[k] = side
    end
    self.sides = nsides 

    local targets = {} 
    for k,v in pairs(nsides) do
        for kk,vv in pairs(v) do
            targets[#targets+1] = vv
        end
    end

    self.turnid = 0 
    self.targets = targets
    self.location = targets[1].location 



    for k,v in pairs(targets) do
        v:adj_set('in_combat')
        v.combat = self
        printto(v,"<ORANGE>entering combat<ORANGE>")
        send_actions(v) 
    end 

    self:EndTurn()
end
function combat_meta:End()
    for k,v in pairs(self.targets) do
        v:adj_unset('in_combat')
        v.combat = nil
        printto(v,"<ORANGE>exiting combat<ORANGE>")
        send_actions(v) 
    end 
end
function combat_meta:GetRandomEnemySide(target)
    for k,v in pairs(self.sides) do
        if not table.contains(v,target) then
            return v
        end
    end 
end
function combat_meta:GetRandomEnemy(target)--alive only
    local enemyside = self:GetRandomEnemySide(target)
    if enemyside then
        return table.random(enemyside)
    end
end
function combat_meta:OnDeath(target)

end

local function CheckSides(self)
    --if only one side remains alive - end combat
    local alive_sides = 0
    for k,v in pairs(self.sides) do
        local alive = 0 
        for k2,v2 in pairs(v) do
            if not v2:is('dead') then
                alive = alive + 1
            end 
        end
        if alive>0 then
            alive_sides = alive_sides + 1
        end
    end
    if alive_sides<2 then
        self:End()
        return false
    end
end
function combat_meta:EndTurn()

    if CheckSides(self)==false then
        return
    end

    local targetcount = #self.targets
    self.turnid = self.turnid + 1
    if self.turnid > targetcount then
        self.turnid = 1
    end

    local lasttarget = self.turntarget
    local turntarget = lasttarget

    for k=1,10 do
        turntarget = self.targets[self.turnid]
        turntarget.is_defending = nil
        if turntarget:is('dead') then
            self.turnid = self.turnid + 1
            if self.turnid > targetcount then
                self.turnid = 1
            end
        else
            self.turntarget = turntarget
            break
        end
    end
    if lasttarget==turntarget then 
        self:End()
    else
        describe_action(turntarget,"your turn",L"[turntarget]'s turn")   
    
        Delay(1,function()
            if turntarget.player then
            else
                --calcccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc ska
                if turntarget.tactic=='flee' then
                    self:Flee(turntarget)
                else
                    self:Attack(turntarget,self:GetRandomEnemy(turntarget))
                end
            end
        end)
    end

end


function combat_meta:Flee(by) 
    if self.turntarget==by then
        if math.random()<((by.evasion or 50)*0.01) then -- flee check
            describe_action(by,L"You flee!",L"[by] is fleeing!")   
            if not by.player then
                by.location = nil
                show_location(self.location)
            end
            self:End()
            return
        else
            describe_action(by,L"You fail to flee!",L"[by] tried fleeing but failed!")   
        end
        self:EndTurn()
    end
end
function combat_meta:Attack(by, target) 
    if self.turntarget==by then
        local att_accuracy = (by.accuracy or 50)*0.01
        local trg_hitchance = 1-(target.evasion or 50)*0.01
        
        if math.random()>(att_accuracy*trg_hitchance) then -- aaaaaaaaaaaaaaaaaaaaaaaa (accuracy evasion weapon etc) check
            if target.is_defending then
                --fail
                describe_action(by,"<yellow>Your attack has been deflected!</yellow>",
                                L"<yellow>[target] has blocked [by] attack!</yellow>",
                                target,L"<yellow>you have blocked [by] attack!</yellow>") 
            else
                describe_action(by,L"<yellow>You attack [target]!</yellow>",
                                    L"<yellow>[by] attacks [target]!</yellow>",
                                target,L"<yellow>[by] attacks you!</yellow>")  
                target:Damage(by.damage or 30)
                if target:is('dead') then
                    describe_action(by,L"<red>You killed [target]!</red>",
                                        L"<red>[by] kills [target]!</red>")  
                end
                for k,v in pairs(self.targets) do
                    if v~=target then 
                        send_health(v,target)
                    end
                end
            end
        else
            describe_action(by,"<yellow>You missed!</yellow>",
                L"<yellow>[by] tried to attack [target] but missed!</yellow>",
                target,L"<yellow>[by] wanted to attack you but missed!</yellow>")
        end
        self:EndTurn()
    end
end
function combat_meta:Defend(by) 
    if self.turntarget==by then
        by.is_defending = true
        printto(self.location,L"[by] is defending")
        self:EndTurn()
    end
end


combat_meta.__index = combat_meta

function combat.Begin(sides)
    --sides

    local combat_inst = setmetatable({},combat_meta)
    combat_inst:Begin(sides)
    return combat_inst
end 



person.maxhealth = 100
person:event_add("on_init","health",function(self)
    self.health = self.maxhealth
end)
function person:Damage(amount)
    if not self:is('dead') then
        local hp = self.health - amount
        if hp<=0 then
            hp = 0 
            self:Kill()
        end
        self.health = hp 
        send_health(self)
    end
end
function person:Heal(amount)
    if not self:is('dead') then
        local hp = self.health + amount
        if hp>self.maxhealth then
            hp = self.maxhealth
        end
        self.health = hp 
        send_health(self)
    end
end
function person:HealPercent(amount)
    if not self:is('dead') then
        local mhp = self.maxhealth
        local hp = self.health + amount*mhp
        if hp>mhp then
            hp = mhp
        end
        self.health = hp 
        send_health(self)
    end
end
function person:Kill()
    describe_action(self,"<RED>You are dead!</RED>",
                        L"<RED>[self] dies!</RED>")  
    self:adj_set('dead')
    printto(self,'$display:background;clear')
    printto(self,'$display:line;clear')
    printto(self,'$display:target;clear')
    printto(self,'$display:clothes;clear')
    self:event_call('on_death')
    send_actions(self)
    send_health(self)
end
function person:Revive()
    self.health = self.maxhealth
    self:adj_unset('dead')
    self:event_call('on_revive')
    describe_action(self,"You have been revived!",L"[self] revived!")  
    send_health(self)
end

