

--look and examine

function display_location(target) 
    local image = target.image 
    if image then
        printout('$display:background;'..image)
    else
        printout('$clear:background')
    end
end

EventAdd('examine','default',function(target)
    printout(target.description)
end)


function examine(target)  
    if target.examine then
        target:examine(player)
    else
        EventActCall("examine",target) 
    end
    local image = target.image 
    if target:is(room) then 
        display_location(target)
    else
        printout('$clear:target')
        if image then 
            printout('$display:target;'..image) 
        end
    end
end

look_action = Def('look_action',{key='look',callback = function(self,direction)  
    local is_player = self == player
    if is_player then examine(self.location) end
    return false -- no enturn
end,description='shorthand: l'},'action')
DefComAlias('l','look') 

examine_action = Def('examine_action',{key='examine',callback = function(self,target) 
    local is_player = self == player
    if is_player then
        if not target then 
            examine(player)
            return false -- no enturn
        elseif target=='self' then
            printout('examine self')
            examine(player)
            return false -- no enturn
        else 
            local v = LocalIdentify(target) or LocalIdentify(target,self)
            if v then
                if v:is(person) and v~=self then
                    self.talk_target = v  
                    examine(v)
                    return true
                end
                return false -- no enturn
            else
                printout('there is no '..target)
            end
        end
    end
end,description='shorthand: x'},'action')
DefComAlias('x','examine') 




person:act_add(look_action)
person:act_add(examine_action)