
hs_verse = Def('hs_verse',{name="Homestuck Multiverse"},'universe')


Include('defines.lua')
Include('human.lua')
Include('troll.lua')
Include('aspects.lua')
Include('soul.lua')
Include('characters.lua')
Include('world.lua')


 
MakeRelation(jade,aradia,likes) 


jade.location = jade_room 
rose.location = rose_room 
roxy.location = roxy_room 
dave.location = dave_room 
john.location = john_room 

jadebot.location = chamber

aradia.location = aradia_room
nepeta.location = aradia_room
kanaya.location = aradia_room
terezi.location = aradia_room
aradiabot.location = aradia_room

--[[
local ajd = jade_room:adjascent(true)
local all = jade:adj_getall()

print('jade is female - ',jade:is('female'))
print('jade is person - ',jade:is('person'))
print('jade is thing - ',jade:is('thing'))
print('jade is male - ',jade:is('male'))
print('jade description - ',jade.description)
print('jade location - ',jade.location)

]]



 
Include('memory.lua')