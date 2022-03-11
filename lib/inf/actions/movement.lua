
move_action = Def('move_action',{key='move',callback = function(self,direction) 
    local is_player = self == player
    local loc = self.location
    if loc:is(room) then
        local next = loc:dir(direction)
        if next then  
            describe_action(self,nil,tostring(self)..' leaves to '..tostring(next))  
            self.location = next
            describe_action(self,nil,tostring(self)..' arrives from '..tostring(loc)) 
            if is_player then
                printout('$clear:target')
                examine(next) 
            end
            return true
        else
            if is_player then printout("you can't go that way") end
        end
    else
        if is_player then printout("you can't move") end
    end
end,description='shorthand: n, s, w, e, etc.'},'action')

for k,v in pairs(direction_map) do
    DefComAlias(k,{'move',k})
end

person:act_add(move_action) 
