
hs_verse = Def('hs_verse',{name="Homestuck Multiverse"},'universe')


Include('defines.lua')
Include('aspects.lua')
Include('soul.lua')
Include('characters.lua')
Include('world.lua')


 
MakeRelation(jade,aradia,likes) 


jade.location = jade_room
aradia.location = jade_room
nepeta.location = jade_room


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



 