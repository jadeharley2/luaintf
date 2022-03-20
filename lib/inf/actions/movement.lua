
move_action = Def('move_action',{key='move',restrictions = {"!asleep"},callback = function(self,direction)  
    local is_player = self == player
    local loc = self.location
    if loc:is(room) then
        local next = loc:dir(direction)
        if next then  
            describe_action(self,nil,tostring(self)..' leaves to '..tostring(next))  
            others_action(self,function(ply)
                printout('$display:line;'..self.id..';')
            end)

            self.location = next

            describe_action(self,nil,tostring(self)..' arrives from '..tostring(loc))

            others_action(self,function(ply) 
                printout('$display:line;'..self.id..';'..(self.image or ''))
            end)

            if is_player then
                printout('$display:target;clear')
                printout('$display:line;clear')
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



--[[



]]
 