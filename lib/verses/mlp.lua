mlp_verse = Def('mlp_verse',{name="Pony universe"},'universe')


equis = Def('equis',{name="Equis"},'planet')
equis.location = mlp_verse

canterlot = Def('canterlot',{name='Canterlot'},'city')
canterlot.location = equis


luna_room = Def('luna_room',{},"owned bedroom")
luna_room.location = canterlot

celestia_room = Def('celestia_room',{},"owned bedroom")
celestia_room.location = canterlot

hall_corridor = Def('hall_corridor',{name="Hall"},"room")
hall_corridor.location = canterlot

tower_staircase = Def('tower_staircase',{name="Staircase"},"room")
tower_staircase.location = canterlot

throne_room = Def('throne_room',{name="Throne room"},"room")
throne_room.location = canterlot

throne = Def('throne',{name='Throne'},'thing')

celestia_throne = Def('celestia_throne',{},'owned throne')
celestia_throne.location = throne_room

luna_throne = Def('luna_throne',{},'owned throne') --name="Princess Luna's throne"
luna_throne.location = throne_room



MakeRelation(throne_room,hall_corridor,direction_north)
MakeRelation(hall_corridor,celestia_room,direction_east)
MakeRelation(hall_corridor,tower_staircase,direction_west)
MakeRelation(tower_staircase,luna_room,direction_north)

pony = Def('pony','person')

pony.on_init = function(self)  
    self:build()
end

pony.build = function(self)  


    local body_f = Inst('pony furred quadruped chest')
    local body_b = Inst('pony quadruped abdomen')

    local neck = Inst('pony furred neck')
    local head = Inst('pony furred head')

    local leg_fl = Inst('ungulate pony furred front left leg')
    local leg_fr = Inst('ungulate pony furred front right leg')
    local leg_bl = Inst('ungulate pony furred back left leg')
    local leg_br = Inst('ungulate pony furred back right leg')

    local hoof_fl = Inst('pony furred front left hoof')
    local hoof_fr = Inst('pony furred front right hoof')
    local hoof_bl = Inst('pony furred back left hoof')
    local hoof_br = Inst('pony furred back right hoof')

    local tail = Inst('pony furred tail')

    MakeRelation(body_f,body_b,flesh_connected)
    MakeRelation(body_f,neck,flesh_connected)
    MakeRelation(neck,head,flesh_connected)

    MakeRelation(body_f,leg_fl,flesh_connected)
    MakeRelation(body_f,leg_fr,flesh_connected)
    MakeRelation(body_b,leg_bl,flesh_connected)
    MakeRelation(body_b,leg_br,flesh_connected)

    MakeRelation(leg_fl,hoof_fl,flesh_connected)
    MakeRelation(leg_fr,hoof_fr,flesh_connected)
    MakeRelation(leg_bl,hoof_bl,flesh_connected)
    MakeRelation(leg_br,hoof_br,flesh_connected)

    MakeRelation(body_b,tail,flesh_connected)

    body_f.location = self
    body_b.location = self
    neck.location = self
    head.location = self
    leg_fl.location = self
    leg_fr.location = self
    leg_bl.location = self
    leg_br.location = self 
    hoof_fl.location = self
    hoof_fr.location = self
    hoof_bl.location = self
    hoof_br.location = self 
    tail.location = self

end


peytral = Def('peytral','clothing')
crown = Def('crown','clothing') 



celestia  = Def('celestia',{name='Celestia'},'female pony')
celestia.location = celestia_room
celestia.title = 'Princess'
luna  = Def('luna',{name='Luna'},'female pony')
luna.location = luna_room
luna.title = 'Princess'

luna:set_clothes('owned peytral','owned crown','owned shoes')
celestia:set_clothes('owned peytral','owned crown','owned shoes')


--[[
local test2 = luna:findall('front hoof')

local legtest = luna:find('front right leg')
legtest:setup('described missing')

local legtest = luna:find('back right leg')
legtest:setup('described changing') 

local legtest = luna:find('back left leg')
legtest:setup('described scaly !furred') 
]]
 
MakeRelation(luna_throne,luna,owner) 
MakeRelation(luna_room,luna,owner) 

MakeRelation(celestia_throne,celestia,owner) 
MakeRelation(celestia_room,celestia,owner) 
