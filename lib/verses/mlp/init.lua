mlp_verse = Def('mlp_verse',{name="Pony universe"},'universe')


peytral = Def('peytral','clothing')
crown = Def('crown','clothing') 

Include('world.lua')
Include('pony.lua') 
Include('characters.lua')

MakeRelation(luna_throne,luna,owner) 
MakeRelation(luna_room,luna,owner) 

MakeRelation(celestia_throne,celestia,owner) 
MakeRelation(celestia_room,celestia,owner) 


celestia.location = celestia_room 
luna.location = luna_room

cadance.location = throne_room
chrysalis.location = throne_room


 
fluttershy.location = hall_corridor
rainbow.location = hall_corridor
pinkie.location = hall_corridor
applejack.location = hall_corridor
rarity.location = hall_corridor
twilight.location = hall_corridor

trixie.location = throne_room  
sunset.location = throne_room  
starlight.location = throne_room


--[[
local test2 = luna:findall('front hoof')

local legtest = luna:find('front right leg')
legtest:setup('described missing')

local legtest = luna:find('back right leg')
legtest:setup('described changing') 

local legtest = luna:find('back left leg')
legtest:setup('described scaly !furred') 
]]
 