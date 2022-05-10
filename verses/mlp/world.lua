
the_sun = Def('the_sun',{name='Sun'},'star')
the_sun.location = mlp_verse

the_moon = Def('the_moon',{name='Moon'},'planet')
the_moon.location = mlp_verse


equis = Def('equis',{name="Equis"},'planet')
equis.location = mlp_verse
equis.daytime = 'day'
equis._get_sky_description = function(self)
    --location = player.location
    local daytime = self.daytime
    if daytime == 'night' then
        return 'you see moon high in the night sky'
    elseif daytime == 'day' then
        return 'you see sun shining high in the day sky'
    end
end


canterlot = Def('canterlot',{name='Canterlot'},'city')
canterlot.location = equis


luna_room = Def('luna_room',{},"owned bedroom")
luna_room.location = canterlot
luna_room.image = '/img/mlp/background/lunaroom.png'

luna_bed = Def('luna_bed',{},'owned bed')
luna_bed.owner = luna
luna_bed.location = luna_room
Inst('mirror').location = luna_room

celestia_room = Def('celestia_room',{},"owned bedroom")
celestia_room.location = canterlot
celestia_room.image = '/img/mlp/background/celestiaroom.png'

celestia_bed = Def('celestia_bed',{},'owned bed')
celestia_bed.owner = celestia
celestia_bed.location = celestia_room
Inst('mirror').location = celestia_room



hall_main = Def('hall_main',{name="Hall"},"room")
hall_main.location = canterlot
hall_main.image = '/img/mlp/background/ct_hall.png'

--tower_staircase = Def('tower_staircase',{name="Staircase"},"room")
--tower_staircase.location = canterlot
--tower_staircase.image = '/img/mlp/background/ct_stairs.jpg'

throne_room = Def('throne_room',{name="Throne room"},"room")
throne_room.location = canterlot
throne_room.image = '/img/mlp/background/ctr2c.png'

throne = Def('throne',{name='Throne'},'thing')

celestia_throne = Def('celestia_throne',{},'owned throne')
celestia_throne.location = throne_room
celestia_throne.image = '/img/mlp/items/celestia_throne.png'

luna_throne = Def('luna_throne',{},'owned throne') --name="Princess Luna's throne"
luna_throne.location = throne_room
luna_throne.image = '/img/mlp/items/luna_throne.png'


castle_library = Def('castle_library',{name="Library"},"room")
castle_library.location = canterlot
castle_library.image = '/img/mlp/background/library.jpg'

hall_corridorW = Def('hall_corridorW',{name="West hall"},"room")
hall_corridorW.location = canterlot
hall_corridorW.image = '/img/mlp/background/ct_hall2.jpg'

hall_corridorE = Def('hall_corridorE',{name="East hall"},"room")
hall_corridorE.location = canterlot
hall_corridorE.image = '/img/mlp/background/ct_hall2.jpg'

MakeRelation(hall_main,throne_room,direction_north)
MakeRelation(hall_main,hall_corridorW,direction_west)
MakeRelation(hall_main,hall_corridorE,direction_east)

MakeRelation(hall_main,celestia_room,direction_northeast)
MakeRelation(hall_main,luna_room,direction_northwest)

MakeRelation(hall_corridorE,castle_library,direction_east) 

guest_room1 = Def('guest_room1',{name="Guest room A"},"room")
guest_room1.location = canterlot
guest_room1.image = '/img/mlp/background/ct_room.jpg'
Inst('bed').location = guest_room1

guest_room2 = Def('guest_room2',{name="Guest room B"},"room")
guest_room2.location = canterlot
guest_room2.image = '/img/mlp/background/ct_room2.jpg'
Inst('bed').location = guest_room2
Inst('mirror').location = guest_room2

guest_room3 = Def('guest_room3',{name="Guest room C"},"room")
guest_room3.location = canterlot
guest_room3.image = '/img/mlp/background/ct_room3.png'
Inst('bed').location = guest_room3

MakeRelation(hall_corridorW,guest_room1,direction_northwest)
MakeRelation(hall_corridorW,guest_room2,direction_west)
MakeRelation(hall_corridorW,guest_room3,direction_southwest)

courtyard = Def('courtyard',{name="courtyard"},"outside")
courtyard.location = canterlot
courtyard.image = '/img/mlp/background/ct_courtyard.jpg'

MakeRelation(hall_main,courtyard,direction_south)