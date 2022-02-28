
hs_verse = Def('hs_verse',{name="Homestuck Multiverse"},'universe')

jade = Def('jade','person')
aradia = Def('aradia','person')


MakeRelation(jade,aradia,likes)

tower = Def('tower',{},'building')
tower.location = hs_verse

jade_room = Def('jade_room',{},'room')
jade_room._get_name = LF[[[IF(player==jade,"My","Jade's")] room]]
jade_room.location = tower

aradia_room = Def('aradia_room',{},'room')
aradia_room._get_name = LF[[[IF(player==aradia,"My","Aradia's")] room]]
aradia_room.location = tower
--
    --function(s) return IF(player==jade,"My room","Jade's room") end
--[[ function(s) 
    if player==jade then
        return "My room"
    else
        return "Jade's room"
    end
end]]
chamber = Def('chamber',{name = "Chamber"},'room')
chamber.on_enter = function(s,t) print('welcome',t) end
chamber.location = tower
MakeRelation(jade_room,chamber,direction_down)

upper_hall = Def('upper_hall',{name = "Upper hall"},'room')
upper_hall.location = tower
MakeRelation(upper_hall,chamber,direction_east)
MakeRelation(upper_hall,aradia_room,direction_north)

garden_c = Def('garden_c',{name = "Central garden atrium"},'room')
garden_w = Def('garden_w',{name = "West garden atrium"},'room')
garden_s = Def('garden_s',{name = "South garden atrium"},'room')
garden_n = Def('garden_n',{name = "North garden atrium"},'room')
garden_e = Def('garden_e',{name = "East garden atrium"},'room')
MakeRelation(garden_c,upper_hall,direction_up)
MakeRelation(garden_c,garden_w,direction_west)
MakeRelation(garden_c,garden_e,direction_east)
MakeRelation(garden_c,garden_n,direction_north)
MakeRelation(garden_c,garden_s,direction_south)
garden_c.location = tower
garden_w.location = tower
garden_s.location = tower
garden_n.location = tower
garden_e.location = tower


local ajd = jade_room:adjascent(true)


jade:adj_set({"nerdy","female"})  
jade:wear('shirt','skirt')

aradia:adj_set({"gothic","female"})  
aradia:wear('shirt','skirt')

jade.location = jade_room
aradia.location = jade_room
person.mood = "ok"

local all = jade:adj_getall()

print('jade is female - ',jade:is('female'))
print('jade is person - ',jade:is('person'))
print('jade is thing - ',jade:is('thing'))
print('jade is male - ',jade:is('male'))
print('jade description - ',jade.description)
print('jade location - ',jade.location)


keytar = Def("keytar","thing")
keytar.location = jade_room



jade:response("bodyswap",function(s,t) 
    s:say("what is it?") 
    s:response("i want to swap with you",function(s,t) 
        s:say("i like your idea") 

        s:say("i dont like this") 
        
        s:say("how?") 
    
    end,true)
end)