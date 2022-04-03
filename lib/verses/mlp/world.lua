

equis = Def('equis',{name="Equis"},'planet')
equis.location = mlp_verse

canterlot = Def('canterlot',{name='Canterlot'},'city')
canterlot.location = equis


luna_room = Def('luna_room',{},"owned bedroom")
luna_room.location = canterlot
luna_room.image = '/img/mlp/background/lunaroom.png'

celestia_room = Def('celestia_room',{},"owned bedroom")
celestia_room.location = canterlot
celestia_room.image = '/img/mlp/background/celestiaroom.png'


hall_corridor = Def('hall_corridor',{name="Hall"},"room")
hall_corridor.location = canterlot
hall_corridor.image = '/img/mlp/background/ct_hall.png'

--tower_staircase = Def('tower_staircase',{name="Staircase"},"room")
--tower_staircase.location = canterlot
--tower_staircase.image = '/img/mlp/background/ct_stairs.jpg'

throne_room = Def('throne_room',{name="Throne room"},"room")
throne_room.location = canterlot
throne_room.image = '/img/mlp/background/ctr2c.png'

throne = Def('throne',{name='Throne'},'thing')

celestia_throne = Def('celestia_throne',{},'owned throne')
celestia_throne.location = throne_room

luna_throne = Def('luna_throne',{},'owned throne') --name="Princess Luna's throne"
luna_throne.location = throne_room



MakeRelation(throne_room,hall_corridor,direction_north)
MakeRelation(hall_corridor,celestia_room,direction_east)
MakeRelation(hall_corridor,luna_room,direction_west)
--MakeRelation(tower_staircase,luna_room,direction_north)