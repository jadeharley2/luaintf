
--take and drop items


take_action = Def('take_action',{key='take',callback = function(self,item) 
    local is_player = self == player 
    if item then
        local something = LocalIdentify(item)
        if something then
            if something.is_moveable~=false then
                something.location = self
                describe_action(self,item..' taken',tostring(self)..' takes '..tostring(item))  
                return true
            else
                if is_player then printout("you can't take "..item) end
            end
        else
            if is_player then printout('there is no '..item) end
        end 
    else
        if is_player then printout('take what?') end
    end
end},'action')


drop_action = Def('drop_action',{key='drop',callback = function(self,item) 
    local is_player = self == player 
    if item then
        local something = LocalIdentify(item,self)
        if something then
            if something.is_moveable~=false then
                something.location = self.location
                describe_action(self,item..' dropped',tostring(self)..' drops '..tostring(item))  
                return true
            else
                if is_player then printout("you can't drop "..item) end
            end
        else
            if is_player then printout('there is no '..item) end
        end 
    else
        if is_player then printout('drop what?') end
    end
end},'action')
 
person:act_add(take_action)
person:act_add(drop_action) 








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