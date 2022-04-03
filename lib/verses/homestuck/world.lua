


tower = Def('tower',{},'building')
tower.location = hs_verse

jade_room = Def('jade_room',{},'owned room') 
jade_room.owner = jade
jade_room.location = tower
jade_room.image = '/img/hs/background/r_jade_bedroom.png' 


change_action = Def('change_action',{key='change',restrictions = {"!asleep"},callback = function(self,arg) 
    self:change(arg)
end},'action') 



local m = Inst("mirror")
m.location = jade_room


local keytar = Def("keytar","thing")
keytar.image = '/img/items/keytar.png' 
keytar.location = jade_room



roxanne = Def('roxanne',{name='Roxanne'},'female canine anthro person')
roxanne._get_image =function(s) 
    if s:is('animatronic') then
        if keytar.location == s then
            return '/img/characters/roxanne2_keytar.png'
        else
            return '/img/characters/roxanne2.png'
        end
    else
        return '/img/characters/roxanne.png'
    end
end
function roxanne:change()
    if self:is('animatronic') then
        self:adj_unset('animatronic')
    else
        self:adj_set('animatronic')
    end
end
roxanne:act_add(change_action)


roxy_costume = Def('roxy_costume',{
	  name = "Roxanne costume", 
   morph = roxanne,
},'morph_costume')
roxy_costume.image = '/img/characters/roxanne.png'


renamon = Def('renamon',{name='Renamon'},'female fox anthro person')
renamon.image = '/img/characters/renamon.png'
renamon_costume = Def('renamon_costume',{
	  name = "Renamon costume", 
   morph = renamon,
},'morph_costume')
renamon_costume.image = '/img/characters/renamon.png'

jade_cabinet = Def('jade_cabinet','cabinet')
jade_cabinet.location = jade_room
jade_cabinet:interact_add(step_in_interaction)
jade_cabinet:interact_add(step_out_interaction) 

renamon_costume.location = jade_cabinet
roxy_costume.location = jade_cabinet



aradia_room = Def('aradia_room',{},'owned room')
aradia_room.owner = aradia
aradia_room.location = tower


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
garden_c.image = '/img/hs/background/r_jade_atrium.png' 
garden_w.image = '/img/hs/background/r_jade_atrium.png' 
garden_s.image = '/img/hs/background/r_jade_atrium.png' 
garden_n.image = '/img/hs/background/r_jade_atrium.png' 
garden_e.image = '/img/hs/background/r_jade_atrium.png' 
