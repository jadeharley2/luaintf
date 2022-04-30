

--look and examine

function display_location(target) 
    local image = target.image 
    if image then
        printout('$display:background;background;'..image..';'..target.image_style_css)
    else
        printout('$display:background;clear')
    end
end

EventAdd('examine','default',function(target)
    --printout(target.description)
    local interactions = {}
    target:foreach('interactions',function(k,v) interactions[k]=k end)
    local i2 = {}
    for k,v in SortedPairs(interactions) do
        i2[#i2+1] = v
    end
    printout('$interactions:',table.concat(i2, ';'))
end)


function examine(target,to)  
    local temp_ply = player
    if to then
        player = to 
    end
    printout('$display:target;clear')
    if target.examine then
        target:examine(player)
    else
    end
    EventActCall("examine",target) 
    
    if to then
        player = temp_ply
    end
end

thing.examine = function(self,usr) 
    local image = self.image
    if image then 
        printout('$display:target;'..self.id..';'..image..';'..self.image_style_css) 
    end 
end


look_action = Def('look_action',{key='look',restrictions = {"!asleep",'!blind'},callback = function(self,direction)   
    local is_player = self == player
    self.look_target = self.location
    if is_player then examine(self.location) end
    return false -- no enturn
end,description='shorthand: l'},'action')
DefComAlias('l','look') 

function person:GetVisibleThings()
    local things = {}
    local location = self.location
    if location then
        self.location:foreach('contains',function(v)
            things[#things+1] = v 
            
            local c = v.clothes
            if c then 
                for _,cl in pairs(c) do
                    things[#things+1] = cl
                end
            end
            
        end)
    end
    
    self:foreach('contains',function(v) 
        if v.is_worn then --already added
        elseif v:is('body_part') then --no
        else
            things[#things+1] = v
        end  
    end)
    return things
end

examine_action = Def('examine_action',{key='examine',restrictions = {"!asleep",'!blind'},callback = function(self,...)  
    local is_player = self == player
    if is_player then
        local tl = {...}
        local target = table.concat(tl,' '):trim()

        if #tl==0 or #target==0 then 
            self.look_target = self
            examine(player)
            return false -- no enturn
        elseif target=='self' then
            self.look_target = self
            printout('examine self')
            examine(player)
            return false -- no enturn
        else 
            local v 
            --context identify
            if self.look_target then
                v = LocalIdentify(target,self.look_target) 
            end
            if not v and self.last_look_target then
                v = LocalIdentify(target,self.last_look_target) 
            end

            if not v then
                v = LocalIdentify(target,self.location)
            end 

            if not v then
                local visible = self:GetVisibleThings()
                v = ListIdentify(target,visible)
            end

            if v then
                self.last_look_target = self.look_target
                self.look_target = v
                if v:is(person) and v~=self then
                    self.talk_target = v  
                end
                examine(v)
                return true
            else
                printout('there is no '..target)
                self.look_target = nil
            end
        end
    end
    return false
end,description='shorthand: x'},'action')
DefComAlias('x','examine') 




person:act_add(look_action)
person:act_add(examine_action)