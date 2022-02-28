







fk_verse = Def('fk_verse',{name="Fluff Kevlar Universe"},'universe')


year = 16510
era = 'SST'


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















some_random_starsystem = Def('some_random_starsystem','starsystem')
some_random_starsystem.location = fk_verse

main_star = Def('main_star','star')
main_star.location = some_random_starsystem


random_planet = Def('random_planet',{name='Rng'},'planet') 
random_planet.location = some_random_starsystem
random_planet.in_orbit = main_star
random_planet.orbit_radius = 1 -- in ae

the_tower = Def('the_tower',{name='The tower'},'building')
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
corridor2 = Def('corridor2',{name='south corridor'},'room')
quarters = Def('quarters',{name="crew quarters"},'room')
engine_room = Def('engine_room',{name="engine room"},'room')
hangar = Def('hangar',{name="hangar"},'room')

bridge.location = katric_capital_ship
airlock.location = katric_capital_ship
corridor.location = katric_capital_ship
corridor2.location = katric_capital_ship
quarters.location = katric_capital_ship
engine_room.location = katric_capital_ship
hangar.location = katric_capital_ship

MakeRelation(corridor,bridge,direction_north)
MakeRelation(corridor,airlock,direction_west)
MakeRelation(corridor,quarters,direction_east)
MakeRelation(corridor,corridor2,direction_south)
MakeRelation(corridor2,engine_room,direction_east)
MakeRelation(corridor2,hangar,direction_west)

katric_capital_ship.airlock = airlock

quarters.image = 'https://cdn.discordapp.com/attachments/760334294681124908/943235940376260699/47f96e29c73362c3fd51a1960743f63e.jpg'
airlock.image = 'https://cdn.discordapp.com/attachments/760334294681124908/943234359006224384/1626138798.jpg'
bridge.image = 'https://cdn.discordapp.com/attachments/760334294681124908/943223639933849660/1626138837.jpg'
engine_room.image = 'https://cdn.discordapp.com/attachments/760334294681124908/943234360600035358/079ee8528e17c3733f9f77ca00a9006f.jpg'
hangar.image = 'https://cdn.discordapp.com/attachments/760334294681124908/943234359610191933/1626138900.jpg'
corridor.image = 'https://cdn.discordapp.com/attachments/760334294681124908/943237475780935751/deaa4115061289.5628c78a3069b.jpg'
corridor2.image = 'https://cdn.discordapp.com/attachments/760334294681124908/943234360029638749/64a227e1-5e74-4490-b31f-4c19b9659be9.png'


window = Def('window','thing')
window.examine = function(self,user)
    printout(L'you look trough [self] and see [self.outside.location.description]') 
end

bridge_window = Def('bridge_window',{name='reinforced window'},'window')
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




this_mirror = Def('this_mirror',{name='Mirror'},'mirror')
this_mirror.location = quarters


ara = Def('ara',{name='ARA', code = '0-1-1'},'person') ara:adj_set('anthroid','feline','female') 
srk = Def('srk',{name='Warning', code ='07-4-31'},'person') srk:adj_set('anthroid','feline','female')
zta = Def('zta',{name='Zeta', code='37-8-12'},'person') zta:adj_set('anthroid','kleika','female')
tvk = Def('tvk',{name='Vale'},'person') tvk:adj_set('anthroid','male')
vst = Def('vst',{name='VST'},'person') vst:adj_set('anthroid','male')

vikna = Def('vikna',{name='Vikna', surname='Ramenskaya'},'person') vikna:adj_set('anthro','feline','female')
nytro = Def('nytro',{name='Nytro', surname='Sykran'},'person') nytro:adj_set('anthro','canine','male')
zofie = Def('zofie',{name='Zofie'},'person') zofie:adj_set('anthro','canine','female')
ayn = Def('ayn',{name='Ayn'},'person') ayn:adj_set('anthro','jackal','female')

ara.location = bridge
srk.location = bridge
zta.location = bridge
tvk.location = bridge
vst.location = bridge

ara.image = 'https://cdn.discordapp.com/attachments/760334294681124908/943211101754118245/ara.png'
--'https://cdn.discordapp.com/attachments/531891665993203722/943137499256074260/furry-f-furry-art-furry--6411268.png'
--'https://cdn.discordapp.com/attachments/531891665993203722/943211236538089622/ara.png'
tvk.image = 'https://cdn.discordapp.com/attachments/760334294681124908/943207738991857793/vc.png'
--'https://cdn.discordapp.com/attachments/531891665993203722/943216181962244118/vale.png'
srk.image = 'https://cdn.discordapp.com/attachments/760334294681124908/943209342293905478/srk.png'
zta.image = 'https://cdn.discordapp.com/attachments/760334294681124908/943209772088426506/zta.png'
vst.image = 'https://cdn.discordapp.com/attachments/760334294681124908/943220091355545600/vst.png'

vikna.location = bridge
nytro.location = quarters
zofie.location = quarters
ayn.location = quarters

vikna.image = 'https://cdn.discordapp.com/attachments/760334294681124908/943210593094078474/vikna.png'
nytro.image = 'https://cdn.discordapp.com/attachments/760334294681124908/943212074878783548/nytro.png'
zofie.image = 'https://cdn.discordapp.com/attachments/760334294681124908/943213388979400814/zofie.png'
ayn.image = 'https://cdn.discordapp.com/attachments/760334294681124908/943214682087518238/ayn.png'

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
        
        self:say('...')
    end,
    display = function(self,user)
        printout("$display:target;https://cdn.discordapp.com/attachments/531891665993203722/942877231997415484/unknown.png")
    end,
}





read_interaction = Def('read_interaction',{key='read',callback = function(self,user,act,arg1,...)  
    describe_action(user,'you read a '..tostring(self),tostring(user)..' reads a '..tostring(self)) 
    self:call('on_read',user)  
end},'interaction') 


transfer_soul_action = Def('transfer_soul_action',{key='soultransfer',callback = function(self,arg1,...) 
    local is_player = self == player  
    if arg1 then
        local v = LocalIdentify(arg1)
        if v and v:is(person) then

            if players[v] then 
                printout('this character is occupied')
            else
                describe_action(self,L'you focus on [v]. And then blackout',tostring(self)..' stares at '..tostring(v))  

                if not v:act_get(transfer_soul_action) then
                    player:act_rem(transfer_soul_action)
                    v:act_add(transfer_soul_action)
                end

                players[player] = nil
                player = v 
                players[v] = client

                printout('you are now',v)
                display_location(player.location)
                send_actions() 
                return true
            end 
            return true
        else
            if is_player then printout('there is no '..arg1) end
        end 
    else
        if is_player then printout('specify target') end
    end
    

end},'action') 

 
book = Def('book','thing')
book.location = quarters
book.description = 'an ordinary book'
book:interact_add(read_interaction)
book.on_read = function(self,user)
    printout('you learn something')
    user:act_add(transfer_soul_action)
    send_actions() 
end


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
    if s:is('anthroid') then
        s:say([[No, I.H.Kaltag is not beyond Katrician rules and laws]])
        s:say([[The Empire of Katric is very large, and often times the large sovereigns have one or more major military or technology suppliers]])
        s:say([[So in a manner of speaking, Kaltag is a sidekick to the Imperial throne of Katric, one of their longest running partners]])
        s:say([[Kaltag has many subsidiaries but they hold no political sway or power]]) 
    end
end)


