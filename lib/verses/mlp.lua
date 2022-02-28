mlp_verse = Def('mlp_verse',{name="Pony universe"},'universe')


equis = Def('equis',{name="Equis"},'planet')
equis.location = mlp_verse

canterlot = Def('canterlot',{name='Canterlot'},'city')
canterlot.location = equis

luna_room = Def('luna_room',{name="Princess Luna's bedroom"},"room")
luna_room.location = canterlot

celestia_room = Def('celestia_room',{name="Princess Celesia's bedroom"},"room")
celestia_room.location = canterlot

hall_corridor = Def('hall_corridor',{name="Hall"},"room")
hall_corridor.location = canterlot

tower_staircase = Def('tower_staircase',{name="Staircase"},"room")
tower_staircase.location = canterlot

throne_room = Def('throne_room',{name="Throne room"},"room")
throne_room.location = canterlot

throne = Def('throne',{name='Throne'},'thing')


celestia_throne = Def('celestia_throne',{name="Princess Celestia's throne"},'throne')
celestia_throne.location = throne_room
luna_throne = Def('luna_throne',{name="Princess Luna's throne"},'throne')
luna_throne.location = throne_room


MakeRelation(throne_room,hall_corridor,direction_north)
MakeRelation(hall_corridor,celestia_room,direction_east)
MakeRelation(hall_corridor,tower_staircase,direction_west)
MakeRelation(tower_staircase,luna_room,direction_north)

pony = Def('pony','person')



celestia  = Def('celestia',{name='Celestia'},'pony')
celestia.location = celestia_room
celestia.title = 'Princess'
luna  = Def('luna',{name='Luna'},'pony')
luna.location = luna_room
luna.title = 'Princess'





