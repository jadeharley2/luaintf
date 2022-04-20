

local_town = Def('town',{},'thing')
local_town.location = hs_verse

tower = Def('tower',{},'building')
tower.location = local_town

home = Def('home','building')

rose_house = Def('rose_house',{},'owned home')
rose_house.location = local_town
rose_house.owner = rose

dave_house = Def('dave_house',{},'owned home')
dave_house.location = local_town
dave_house.owner = dave

john_house = Def('john_house',{},'owned home')
john_house.location = local_town
john_house.owner = john




--[[JADE & JAKE]]

jade_room = Def('jade_room',{},'owned room') 
jade_room.owner = jade
jade_room.location = tower
jade_room.image = '/img/hs/background/r_jade_bedroom.png' 

jade_bed = Def('jade_bed',{},'owned bed')
jade_bed.owner = jade
jade_bed.location = jade_room
jade_bed.image = '/img/hs/items/jade_bed.png' 



local m = Inst("mirror")
m.location = jade_room


local keytar = Def("keytar","thing")
keytar.image = '/img/items/keytar.png' 
keytar.location = jade_room



jade_wardrobifier_key = Def('jade_wardrobifier_key','thing')
jade_wardrobifier_key.image = '/img/items/key.png'

jade_cabinet = Def('jade_cabinet',{name='wardrobifier'},'enterable lockable locked cabinet')
jade_cabinet.location = jade_room
jade_cabinet.image = '/img/items/wardrobifier.png'
jade_cabinet.keys = {jade_wardrobifier_key}

renamon_costume.location = jade_cabinet
roxy_costume.location = jade_cabinet
renamon_gloves.location = jade_cabinet

jade_wardrobifier_key.location = jade

local lz = Def("jade_lz",{},"m_zipper")
lz.location = jade_cabinet


jake_room = Def('jake_room',{},'owned room') 
jake_room.owner = jake
jake_room.location = tower
jake_room.image = '/img/hs/background/jake_room.png' 

jake_bed = Def('jake_bed',{},'owned bed')
jake_bed.owner = jake
jake_bed.location = jake_room 

chamber = Def('chamber',{name = "Chamber"},'room')
chamber.on_enter = function(s,t) print('welcome',t) end 
MakeRelation(jade_room,chamber,direction_down)

upper_hall = Def('upper_hall',{name = "Upper hall"},'room') 
MakeRelation(upper_hall,chamber,direction_east)
MakeRelation(upper_hall,jake_room,direction_up)

garden = Def('garden',{name = "atrium"},'room')
MakeRelation(garden,upper_hall,direction_up) 
garden.image = '/img/hs/background/r_jade_atrium.png' 



flower_pots = Def('flower_pots',{name = "flowers"},'thing')
flower_pots.location = garden 






central_hall = Def('central_hall',{name = "Central hall"},'room')
foyer = Def('foyer',{name = "Foyer"},'room')


every{chamber,upper_hall,garden,central_hall,foyer}.location = tower



MakeRelation(central_hall,garden,direction_up)
MakeRelation(central_hall,foyer,direction_east)

local_corner = Def('local_corner',{name = "Local corner"},'room')
local_corner.image = '/img/hs/background/rose_bg_outside_daytime.png' 
MakeRelation(foyer,local_corner,direction_east)


--[[ROSE & ROXY]]


rose_room = Def('rose_room',{},'owned room')
rose_room.owner = rose
rose_room.location = rose_house
rose_room.image = '/img/hs/background/rose_bg_bedroom.png' 

rose_bed = Def('rose_bed',{},'owned bed')
rose_bed.owner = rose
rose_bed.location = rose_room 

Inst("mirror").location = rose_room

roxy_room = Def('roxy_room',{},'owned room')
roxy_room.owner = roxy
roxy_room.location = rose_house
roxy_room.image = '/img/hs/background/rose_bg_moms_room.png' 

roxy_bed = Def('roxy_bed',{},'owned bed')
roxy_bed.owner = roxy
roxy_bed.location = roxy_room 

Inst("mirror").location = roxy_room

rose_hallway = Def('rose_hallway',{name='Hallway'},'room')
rose_hallway.location = rose_house
rose_hallway.image = '/img/hs/background/rose_bg_hallway.png' 

rose_livingroom = Def('rose_livingroom',{name='Livingroom'},'room')
rose_livingroom.location = rose_house
rose_livingroom.image = '/img/hs/background/roxy_bg_rose_livingroom.png' 

rose_laundry = Def('rose_laundry',{name='Laundry'},'room')
rose_laundry.location = rose_house
rose_laundry.image = '/img/hs/background/rose_bg_laundry_room.png' 

rose_outside = Def('rose_outside',{name='Near house'},'room')
rose_outside.location = local_town
rose_outside.image = '/img/hs/background/roxy_bg_alpharose_frontdoor.png' 

rose_forest = Def('rose_forest',{name='Pine forest clearing'},'room')
rose_forest.location = local_town
rose_forest.image = '/img/hs/background/rose_bg_outside_home.png' 

MakeRelation(rose_room,rose_hallway,direction_east)
MakeRelation(roxy_room,rose_hallway,direction_south)
MakeRelation(rose_hallway,rose_livingroom,direction_down)
MakeRelation(rose_livingroom,rose_outside,direction_south)
MakeRelation(rose_livingroom,rose_laundry,direction_north)

MakeRelation(rose_outside,rose_forest,direction_west)
MakeRelation(rose_forest,local_corner,direction_west)


--[[DAVE & DIRK]]

dave_room = Def('dave_room',{},'owned room')
dave_room.owner = dave
dave_room.location = dave_house
dave_room.image = '/img/hs/background/dave_room.png' 

dave_bed = Def('dave_bed',{},'owned bed')
dave_bed.owner = dave
dave_bed.location = dave_room 

dave_kitchen = Def('dave_kitchen',{name='Kitchen'},'room')
dave_kitchen.location = dave_house
dave_kitchen.image = '/img/hs/background/dave_kitchen.png' 

dave_livingroom = Def('dave_livingroom',{name='Livingroom'},'room')
dave_livingroom.location = dave_house
dave_livingroom.image = '/img/hs/background/dave_livingroom.png' 
Inst("mirror").location = dave_livingroom

dave_hallway = Def('dave_hallway',{name='Hallway'},'room')
dave_hallway.location = dave_house

dave_staircase = Def('dave_staircase',{name='Staircase'},'room')
dave_staircase.location = dave_house 

dave_roof = Def('dave_roof',{name='Roof'},'room')
dave_roof.location = dave_house
dave_roof.image = '/img/hs/background/dave_roof.png' 

dave_outside = Def('dave_outside',{name='City street'},'room')
dave_outside.location = local_town 

MakeRelation(dave_hallway,dave_livingroom,direction_east) 
MakeRelation(dave_hallway,dave_room,direction_north) 
MakeRelation(dave_hallway,dave_kitchen,direction_south) 

MakeRelation(dave_staircase,dave_hallway,direction_east) 
MakeRelation(dave_staircase,dave_roof,direction_up)
MakeRelation(dave_staircase,dave_outside,direction_down)


MakeRelation(dave_outside,local_corner,direction_south)


--[[JOHN]]



john_room = Def('john_room',{},'owned room')
john_room.owner = john
john_room.location = john_house
john_room.image = '/img/hs/background/john_room.png' 

john_bed = Def('john_bed',{},'owned bed')
john_bed.owner = john
john_bed.location = john_room 

john_hallway = Def('john_hallway',{name = 'Hallway'},'room') 
john_hallway.location = john_house 

john_bathroom = Def('john_bathroom',{name = 'Bathroom'},'room') 
john_bathroom.location = john_house 

Inst("mirror").location = john_bathroom

john_fatherroom = Def('john_fatherroom',{name = 'Father room'},'room') 
john_fatherroom.location = john_house 

john_livingroom = Def('john_livingroom',{name = 'Livingroom'},'room') 
john_livingroom.location = john_house 

john_kitchen = Def('john_kitchen',{name = 'Kitchen'},'room') 
john_kitchen.location = john_house 

john_laundry = Def('john_laundry',{name = 'Laundry'},'room') 
john_laundry.location = john_house 

john_study = Def('john_study',{name = 'Study'},'room') 
john_study.location = john_house 


john_backyard = Def('john_backyard',{name = 'Back yard'},'room') 
john_backyard.location = john_house 
john_backyard.image = '/img/hs/background/john_backyard.png' 

john_frontyard = Def('john_frontyard',{name = 'Front yard'},'room') 
john_frontyard.location = john_house 
john_frontyard.image = '/img/hs/background/john_frontyard.png' 

MakeRelation(john_hallway,john_room,direction_north)
MakeRelation(john_hallway,john_bathroom,direction_northeast)
MakeRelation(john_hallway,john_fatherroom,direction_east)

MakeRelation(john_livingroom,john_hallway,direction_up)
MakeRelation(john_livingroom,john_study,direction_east)
MakeRelation(john_livingroom,john_kitchen,direction_north)
MakeRelation(john_livingroom,john_frontyard,direction_west)
MakeRelation(john_kitchen,john_laundry,direction_east)

MakeRelation(john_laundry,john_backyard,direction_east)

MakeRelation(john_backyard,john_frontyard,direction_north)

MakeRelation(john_backyard,local_corner,direction_north)



--[TROLLS]



aradia_room = Def('aradia_room',{},'owned room')
aradia_room.owner = aradia
aradia_room.location = tower
Inst("mirror").location = aradia_room

aradia_bed = Def('aradia_bed',{},'owned bed')
aradia_bed.owner = aradia
aradia_bed.location = aradia_room 

MakeRelation(aradia_room,local_corner,direction_up)