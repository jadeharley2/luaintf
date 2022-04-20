
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

    --every{body_f,body_b,neck,head,
    --    leg_fl,leg_fr,leg_bl,leg_br,
    --    hoof_fl,hoof_fr,hoof_bl,hoof_br,
    --    tail}.location = self
end
