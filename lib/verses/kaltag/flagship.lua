


katric_capital_ship = Def('katric_capital_ship',{name = "'Rassvet'"},'spaceship')
katric_capital_ship.location = kyo_starsystem
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
        if user.robotic then
            printout(L'scanning [self]... scan result: ship [o] is docked to [o.docked]')
        else
            printout(L'you look trough [self] and see that [o] is docked to [o.docked]')
        end
    elseif o.in_orbit then
        if user.robotic then
            printout(L'scanning [self]... scan result: ship is in orbit of [o.in_orbit]')
        else
            printout(L'you look trough [self] and see [o.in_orbit]')
        end 
    else
        if user.robotic then
            printout(L'scanning [self]... scan result: outside environment: [o.location.description]')
        else
            printout(L'you look trough [self] and see [o.location.description]')
        end 
    end
     
    
    printout('$display:target;clear') 

    printout('$display:background;space;/img/background/space.png') 

    local imgs = {}
    local x = o
    for k=1,10 do
        x = x.in_orbit
        if x then

            local img = x.image
            if img then imgs[#imgs+1] ='$display:background;'..x.id..';'..img end

            if x.orbit_radius and x.orbit_radius>0.1 then break end 
        else
            break
        end
    end 
    for k,v in reversedipairs(imgs) do
        printout(v)
    end
 
    --printout('$display:background;planet;/img/background/planet4.png') 

    printout('$display:background;frame;/img/background/space_window.png') 
    printout('$display:target;null;/null.png') 
    
end 





