
hs_verse = Def('hs_verse',{name="Homestuck Multiverse"},'universe')


Include('defines.lua')
Include('aspects.lua')
Include('soul.lua')
Include('characters.lua')
Include('world.lua')
Include('schedules.lua')


 
MakeRelation(jade,aradia,likes) 


jade.location = jade_room jade.mind:make_fully_known(tower)
rose.location = rose_room rose.mind:make_fully_known(rose_house)
roxy.location = roxy_room roxy.mind:make_fully_known(rose_house)
dave.location = dave_room dave.mind:make_fully_known(dave_house)
john.location = john_room john.mind:make_fully_known(john_house)

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



 