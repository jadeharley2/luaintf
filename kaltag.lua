

year = 16510
era = 'SST'

subspace = Def('subspace',{name='Subspace'},'thing')
subspace.description = "blue flickering space"--....

organization = Def('organization','thing')
soverign_state = Def('soverign_state',{name="Soverign state"},'organization')

siania = Def('siania',{name="Queendom of Siania"},'soverign_state')

katric = Def('katric',{name="Katric"},'soverign_state') -- founded: 3120 SE from siania
kaltag = Def('kaltag','organization')


spacestation = Def('spacestation','thing')
spacestation._get_description = LF"[self]"
spacestation.dock_slot_count = 9
spacestation.dock = function(self,target) 
    local docked = self.docked or {}
    self.docked = docked
    if #docked<self.dock_slot_count then 
        local slot = #docked+1
        docked[slot] = target

        local a1 = self.airlock
        local a2 = target.airlock

        MakeRelation(a1,a2,Identify('direction_n'..slot))
        
        
        return true
    end
end
spacestation.undock = function(self,target) 
    local docked = self.docked 
    if docked then 
        for slot,v in pairs(docked) do
            if v == target then 
                local a1 = self.airlock
                local a2 = target.airlock
        
                DestroyRelation(a1,a2,Identify('direction_n'..slot))

                docked[slot] = nil
                return true
            end
        end  
    end
end


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




moving_cabin = Def('moving_cabin',{ },'room')
moving_cabin.close_doors = function(self)
    DestroyRelations(self,direction)
end
moving_cabin.open_doors = function(self,floor)
    self.stop = floor.room
    MakeRelation(self,floor.room,floor.dir)
end
moving_cabin.add_stop = function(self,key, room,dir)
    if type(dir)=='string' then
        dir = direction_map[dir]
    end
    self.stops = self.stops or {}
    self.stops[key] = {room = room, dir = dir} 
end
moving_cabin.move_to = function(self,key,callback) 
    local v = self.stops[key] 
    if v then
        self:make_sound_inside('*be-ep*')
        self:close_doors()
        Delay(2,function()
            self:make_sound_inside('*beep*')
            self:open_doors(v)
            if callback then callback(self,key) end 
        end)
        return true
    end
    return false
end

moving_cabin.set_path = function(self,key_array,looped,wait_time)
    local index = 1
    local current = key_array[index]
    local direction = 1

    self:open_doors(self.stops[current])
    local function process() 
        index = index + direction
        if index>#key_array then
            if looped then
                index = 1
            else
                direction = -direction
                index = #key_array-1
            end
        elseif index<1 then
            if looped then
                index = #key_array
            else
                direction = -direction
                index = 2
            end 
        end
        if index==0 then

            local dfa = 0
        end
        current = key_array[index]

        Delay(wait_time or 2, function() 
            if self:move_to(current,function() 
                process()
            end) then

            else
                print('error!')
            end
        end)
    end

    process()
end


--todo: buttons and interaction

elevator = Def('elevator',{ },'moving_cabin')

elevator.select_floor = function(self,key)
    return self:move_to(key,function()
        self:make_sound_inside('Floor '..tostring(key))
    end) 
end 

--end todo











bulding = Def('bulding','thing')


starsystem = Def('starsystem','thing')

star = Def('star','thing')
star._get_description = LF'star [self]' 

planet = Def('planet','thing')
planet._get_description = LF'planet [self]' 

asteroid = Def('asteroid','thing')
asteroid._get_description = LF'asteroid [self]' 

asteroid_field = Def('asteroid_field','thing')
asteroid_field._get_description = LF'asteroid field [self]' 



some_random_starsystem = Def('some_random_starsystem','starsystem')

main_star = Def('main_star','star')
main_star.location = some_random_starsystem


random_planet = Def('random_planet',{name='Rng'},'planet') 
random_planet.location = some_random_starsystem
random_planet.in_orbit = main_star
random_planet.orbit_radius = 1 -- in ae

the_tower = Def('the_tower',{name='The tower'},'bulding')
the_tower.location = random_planet


asteroid_field = Def('asteroid_field',{name='debree'},'asteroid_field') 
asteroid_field.location = some_random_starsystem
asteroid_field.in_orbit = main_star
asteroid_field.orbit_radius = 4 -- in ae



random_asteroid = Def('random_asteroid',{name='Met'},'asteroid') 
random_asteroid.location = some_random_starsystem
random_asteroid.in_orbit = asteroid_field
random_asteroid.orbit_radius = 0



asteroid_station = Def('asteroid_station',{name="Met-Station"},'spacestation') 
asteroid_station.location = some_random_starsystem
asteroid_station.in_orbit = random_asteroid 

asteroid_station_airlock = Def('asteroid_station_airlock','room') asteroid_station_airlock.location = asteroid_station
asteroid_station.airlock = asteroid_station_airlock



freespace_station = Def('freespace_station',{name="FS-Station"},'spacestation') 
freespace_station.location = some_random_starsystem
freespace_station.in_orbit = main_star 

freespace_station_airlock = Def('freespace_station_airlock','room') freespace_station_airlock.location = freespace_station
freespace_station.airlock = freespace_station_airlock




torus_station = Def('torus_station',{name="R-Station"},'spacestation')  
torus_station.location = some_random_starsystem
torus_station.in_orbit = random_planet

station_airlock = Def('station_airlock','room') station_airlock.location = torus_station
station_habitat = Def('station_habitat','room') station_habitat.location = torus_station
station_hub = Def('station_hub','room') station_hub.location = torus_station
station_space_elevator_entrance = Def('station_space_elevator_entrance','room') station_space_elevator_entrance.location = torus_station


 

MakeRelation(station_hub,station_airlock,direction_east)
MakeRelation(station_hub,station_habitat,direction_west)
MakeRelation(station_hub,station_space_elevator_entrance,direction_north)

torus_station.airlock = station_airlock




tower_ground_floor = Def('tower_ground_floor','room') tower_ground_floor.location = the_tower






space_elevator = Def('space_elevator','elevator')
space_elevator:add_stop('station',station_space_elevator_entrance,direction_south)
space_elevator:add_stop('ground',tower_ground_floor,direction_south)
space_elevator:set_path({'station','ground'},false,4)



katric_capital_ship = Def('katric_capital_ship',{name = "Katric capital ship"},'spaceship')
katric_capital_ship.location = some_random_starsystem
katric_capital_ship.in_orbit = torus_station
katric_capital_ship._get_outside = function(s)
    if s.location:is(planet) then
        return tostring(planet)
    end
    return 'space'
end




bridge = Def('bridge','room') 
airlock = Def('airlock','room') 
corridor = Def('corridor','room')
quarters = Def('quarters',{name="crew quarters"},'room')
engine_room = Def('engine_room',{name="engine room"},'room')

bridge.location = katric_capital_ship
airlock.location = katric_capital_ship
corridor.location = katric_capital_ship
quarters.location = katric_capital_ship
engine_room.location = katric_capital_ship

MakeRelation(corridor,bridge,direction_north)
MakeRelation(corridor,airlock,direction_west)
MakeRelation(corridor,quarters,direction_east)
MakeRelation(corridor,engine_room,direction_south)

katric_capital_ship.airlock = airlock


window = Def('window','thing')
window.examine = function(self,user)
    printout(L'you look trough [self] and see [self.outside.location.description]') 
end

bridge_window = Def('bridge_window','window')
bridge_window.location = bridge
bridge_window.outside = katric_capital_ship
bridge_window.examine = function(self,user) 
    local o = self.outside
    if o.docked then
        printout(L'you look trough [self] and see that [o] is docked to [o.docked]')
    elseif o.in_orbit then
        printout(L'you look trough [self] and see [o.in_orbit]') 
    else
        printout(L'you look trough [self] and see [o.location.description]')
    end
end




ara = Def('ara',{name='ARA', code = '0-1-1'},'person') ara:adj_set('anthroid','feline','female')
srk = Def('srk',{name='Warning', code ='07-4-31'},'person') srk:adj_set('anthroid','feline','female')
zta = Def('zta',{name='Zeta', code='37-8-12'},'person') zta:adj_set('anthroid','kleika','female')
tvk = Def('tvk',{name='Vale'},'person') tvk:adj_set('anthroid','male')
vst = Def('vst',{name='VST'},'person') vst:adj_set('anthroid','male')

vikna = Def('vikna',{name='Vikna', surname='Ramenskaya'},'person') vikna:adj_set('anthro','feline','female')
nytro = Def('nytro',{name='Nytro', surname='Sykran'},'person') nytro:adj_set('anthro','canine','male')
zofie = Def('zofie',{name='Zofie'},'person') zofie:adj_set('anthro','canine','female')
 
ara.location = bridge
srk.location = bridge
zta.location = bridge
tvk.location = bridge
vst.location = bridge


vikna.location = bridge

katric_capital_ship.srk = srk

local function prnth(node,level)
    for k,v in pairs(node) do
        printout(string.rep(" ", level*2)..L' > [v.val] is a [v.val.base.name]') 
        prnth(v.subs,level+1)
    end
end
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
tvk:act_add(sensors_ship_action)
tvk:act_add(dock_ship_action)
tvk:act_add(undock_ship_action)
tvk:act_add(navigate_ship_action)





press_interaction = Def('press_interaction',{key='press',callback = function(self,user,key) 
    local is_player = user == player 

    if key then
        local btns = self.buttons
        if btns then
            local x = btns[key]
            if x then
                if is_player then  printout('you press '..key..' on '..self.name) end
                x(self,user,key)
            else
                if is_player then  printout('there is no button '..key) end
            end
        else
            printout('there is no buttons on '..self.name)
        end
    else
        if is_player then
            local lst = {}
            self:foreach('buttons',function(k,v) lst[#lst+1] = k end)
            printout('button list: '..table.concat(lst,', '))
        end
    end
    self:say(text)

end},'interaction')

command_interaction = Def('command_interaction',{key='command',callback = function(self,user,act,arg1,...) 
    local is_player = user == player 

    --todo: check permissons or resist
    self:act(act,arg1,...)

end},'interaction') 
tvk:interact_add(command_interaction)



tvk:interact_add(press_interaction)
tvk.this.buttons = {
    toggle_power = function(self,user)
        
        self:say('$rkfuck off$wk')
    end,
}






printout('%1WHITE$rkfuck off$wkWHITE')


tvk:response("dock to station",function(s,t)
    if katric_capital_ship.docked then
        s:say('we already docked')
    else
        s:say('ok') 
        katric_capital_ship:dock(torus_station)
    end
end)
tvk:response("undock",function(s,t)
    if katric_capital_ship.docked then
        s:say('ok') 
        katric_capital_ship:undock()
    else
        s:say('no...')
    end
end)





person:response("does Kaltag happen to be one of those Dystopian MegaCorps who basically control every aspect of people's lives and is even bigger then the government?",function(s,t) 
    --if s:is('anthroid') then
        s:say([[No, I.H.Kaltag is not beyond Katrician rules and laws]])
        s:say([[The Empire of Katric is very large, and often times the large sovereigns have one or more major military or technology suppliers]])
        s:say([[So in a manner of speaking, Kaltag is a sidekick to the Imperial throne of Katric, one of their longest running partners]])
        s:say([[Kaltag has many subsidiaries but they hold no political sway or power]]) 
    --end
end)


