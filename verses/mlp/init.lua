mlp_verse = Def('mlp_verse',{name="Pony universe"},'universe')


peytral = Def('peytral','clothing')
crown = Def('crown','clothing') 

Include('world.lua')
Include('pony.lua') 
Include('humanoid_dragon.lua')
Include('characters.lua')

MakeRelation(luna_throne,luna,owner) 
MakeRelation(luna_room,luna,owner) 

MakeRelation(celestia_throne,celestia,owner) 
MakeRelation(celestia_room,celestia,owner) 


celestia.location = celestia_room 
luna.location = luna_room

cadance.location = hall_corridorW
chrysalis.location = hall_corridorW


 
fluttershy.location = guest_room1
rainbow.location = guest_room1
pinkie.location = guest_room1

applejack.location = guest_room2
rarity.location = guest_room2

spike.location = hall_corridorE
twilight.location = castle_library

trixie.location = guest_room3  
sunset.location = guest_room3  
starlight.location = guest_room3


--[[
local test2 = luna:findall('front hoof')

local legtest = luna:find('front right leg')
legtest:setup('described missing')

local legtest = luna:find('back right leg')
legtest:setup('described changing') 

local legtest = luna:find('back left leg')
legtest:setup('described scaly !furred') 
]]
 
Include('memory.lua')