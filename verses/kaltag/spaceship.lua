
spaceship = Def('spaceship','thing')
spaceship._get_description = LF"[self]"

spaceship.dock = function(self,target)
    if not self.docked and self.in_orbit == target then
        if target:dock(self) then
            self.docked = target  
            self:message(L'ship docking procedure to [target] is complete') 
            return true
        end 
    end
    self:attention("docking procedure aborted!")
end
spaceship.undock = function(self)
    if self.docked and self.docked:undock(self) then
        self.docked = nil 
        self:message('ship undocked') 
        return true
    end 
    self:attention("undock procedure failed!")
end
spaceship._get_starsystem = function(self)
    return self:parent_oftype(starsystem)
end 
spaceship.subspace_travel = function(self,target)
    if not self.in_travel and not self.docked then
        self:alert(L'subspace travel initiated')

        self.in_travel = true
        self.in_orbit = nil
        self.location = subspace

        Delay(10, function()
            self.location = target.location
            self.in_orbit = target
            self.in_travel = false
            self:message('ship arrived at '..tostring(target))
        end)
        return true
    else
        self:alert(L'unable to lock jump target')
        if self.docked then 
            self:alert(L'ship is docked')
        end
        if self.in_travel then 
            self:alert(L'jump in progress')
        end
    end
end

spaceship.message = function(self,msg)
    local srk = self.srk
    if srk then srk:say(msg) end
end 
spaceship.alert = function(self,message)
    local srk = self.srk
    if srk then srk:say('Alert! '..message) end
end
spaceship.warning = function(self,message)
    local srk = self.srk
    if srk then srk:say('Warning! '..message) end
end
spaceship.attention = function(self,message)
    local srk = self.srk
    if srk then srk:say('Attention! '..message) end
end





--ACTIONS



    sensors_ship_action = Def('sensors_ship_action',{key='sensors',callback = function(self,target) 
        local is_player = self == player 
        
        local ship = self:parent_oftype(spaceship)
        if ship then
            --if not ship.sensors then
                if is_player then
                    printout('listing detected objects:') 
                    local hierarchy = {}
                    local nodelist = {}
                    local ss = ship.starsystem
                    if ss then
                        ss:foreach('contains',function(k,v)
                            nodelist[k.id] = {val = k,subs={}}
                            --if k~=ship then
                            --    printout(L' > [k] is a [k.base.name] orbiting [k.in_orbit or "nothing"]') 
                            --end
                        end)
                        for k,v2 in pairs(nodelist) do
                            local v = v2.val
                            if v.in_orbit then
                                local s = nodelist[v.in_orbit.id]
                                if s then 
                                    s.subs[#s.subs+1] = v2
                                else
                                    hierarchy[#hierarchy] = v2
                                end
                            else
                                hierarchy[#hierarchy] = v2
                            end
                        end
                        prnth(hierarchy,0)
                    else
                        printout('detection error') 
                    end
                end
            --else
            --    if is_player then printout('ship sensors offline!') end
            --end
        else
            if is_player then printout('spaceship connection severed!') end
        end

    end},'action')

    dock_ship_action = Def('dock_ship_action',{key='dock',callback = function(self,target) 
        local is_player = self == player 
        
        local ship = self:parent_oftype(spaceship)
        if ship then
            if not ship.in_travel then
                local T = LocalIdentify(target,ship.starsystem)
                if T then
                    if T:is(spacestation) then
                        if ship:dock(T) then 
                            if is_player then printout('status: OK') end
                            return true
                        else
                            if is_player then printout('dock sequence error') end
                        end
                    else
                        if is_player then printout(L'[T] is not a station') end
                    end 
                else
                    if is_player then printout(L'unknown target: [target]') end
                end
            else
                if is_player then printout('cannot dock in travel!') end
            end
        else
            if is_player then printout('spaceship connection severed!') end
        end

    end},'action')
    undock_ship_action = Def('undock_ship_action',{key='undock',callback = function(self,target) 
        local is_player = self == player 
        
        local ship = self:parent_oftype(spaceship)
        if ship then
            if ship:undock() then 
                if is_player then printout('status: OK') end
                return true
            else
                if is_player then printout('undock sequence error') end
            end
        else
            if is_player then printout('spaceship connection severed!') end
        end

    end},'action')
    navigate_ship_action = Def('navigate_ship_action',{key='navigate',callback = function(self,target) 
        local is_player = self == player 
        
        local ship = self:parent_oftype(spaceship)
        if ship then
            if not ship.in_travel then
                local T = LocalIdentify(target,ship.starsystem)
                if T and T~=ship then
                    if T~=ship.in_orbit then
                        if ship:subspace_travel(T) then
                            if is_player then printout(L'subspace travel activated') end
                        else
                            if is_player then printout(L'subspace travel error') end
                        end 
                    else
                        if is_player then printout(L'ship is already at specified destination') end
                    end
                else
                    if is_player then printout(L'unknown target: [target]') end
                end
            else
                if is_player then printout('cannot dock in travel!') end
            end
        else
            if is_player then printout('spaceship connection severed!') end
        end

    end},'action')
--ACTIONS END