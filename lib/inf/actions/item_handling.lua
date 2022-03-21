
--take and drop items


take_action = Def('take_action',{key='take',restrictions = {"!asleep"},callback = function(self,item) 
    local is_player = self == player 
    if item then
        if item == 'all' or item == 'everything' then
            self.location:foreach('contains',function(k,v)
                if k:is(person) then  
                else
                    self:act('take',k)
                end 
            end)
            return true
        else 
            local something = LocalIdentify(item)
            if something then
                if something.is_moveable~=false then
                    something.location = self
                    describe_action(self,L'[something] taken',L'[self] takes [something]')  
                    return true
                else
                    if is_player then printout("you can't take "..item) end
                end
            else
                if is_player then printout('there is no '..item) end
            end 
        end
    else
        if is_player then printout('take what?') end
    end
end},'action')


drop_action = Def('drop_action',{key='drop',restrictions = {"!asleep"},callback = function(self,item) 
    local is_player = self == player 
    if item then
        if item == 'all' or item == 'everything' then
            self:foreach('contains',function(k,v)
                if k.is_worn then 
                elseif k:is('body_part') then  
                else
                    self:act('drop',k)
                end 
            end)
            return true
        else 
            local something = LocalIdentify(item,self)
            if something then
                if something.is_moveable~=false then 
                    if HasRelationWith(something,self,worn_by) then
                        self:act('takeoff',something)
                    end

                    something.location = self.location
                    describe_action(self,L'[something] dropped',L'[self] drops [something]')  
                    return true
                else
                    if is_player then printout("you can't drop "..item) end
                end
            else
                if is_player then printout('there is no '..item) end
            end 
        end
    else
        if is_player then printout('drop what?') end
    end
end},'action')
 
give_action = Def('give_action',{key='give',restrictions = {"!asleep"},callback = function(self,item,target) 
     

    local is_player = self == player 
    if item then
        local something = LocalIdentify(item,self)
        if something then
            if something.is_moveable~=false then
                if target then
                    local someone = LocalIdentify(target)
                    if someone and someone:is(person) then
                        something.location = someone
                        describe_action(self,L'you give [something] to [someone]',L'[self] gives [something] to [someone]')  
                        return true
                    else
                        if is_player then printout("can't find "..target) end
                    end
                else
                    if is_player then printout("give to who?") end
                end
            else
                if is_player then printout("you can't give "..item) end
            end
        else
            if is_player then printout('there is no '..item) end
        end 
    else
        if is_player then printout('give what?') end
    end
end},'action')
DefComAlias('put','give') 

person:act_add(take_action)
person:act_add(drop_action) 
person:act_add(give_action) 








inventory_action = Def('inventory_action',{key='inventory',callback = function(self) 
    local is_player = self == player
    if is_player then 
        local things = self:collect('contains',function(k,v)
            return tostring(k)
        end)
        if #things>0 then
            printout('you have: '..table.concat(things,', ')) 
        else
            printout('you have nothing') 
        end
    end
end,description='shorthand: i'},'action')
DefComAlias('i','inventory')  