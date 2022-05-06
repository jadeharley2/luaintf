
troll = Def('troll','person')

troll.on_init = function(self)  
    self:build()
end

troll.build = function(self)  


    local body_f = Inst('troll biped chest')
    local body_b = Inst('troll biped abdomen')

    local neck = Inst('troll neck')
    local head = Inst('troll head')

    local ear_l = Inst('troll left ear')
    local ear_r = Inst('troll right ear')

    local arm_l = Inst('troll left arm')
    local arm_r = Inst('troll right arm')
    local leg_l = Inst('troll plantigrade left leg')
    local leg_r = Inst('troll plantigrade right leg')

    local hand_l = Inst('troll left hand')
    local hand_r = Inst('troll right hand')
    local foot_l = Inst('troll left foot')
    local foot_r = Inst('troll right foot')

    Inst("brain").location = head
    Inst("left inner_ear").location = head
    Inst("right inner_ear").location = head
    Inst("tongue").location = head
    Inst("left eye").location = head
    Inst("right eye").location = head

    Inst("left lung").location = body_f
    Inst("right lung").location = body_f
    Inst("heart").location = body_f
    Inst("liver").location = body_f

    Inst("left kidney").location = body_b
    Inst("right kidney").location = body_b
    Inst("stomach").location = body_b
 

    MakeRelation(body_f,body_b,flesh_connected)
    MakeRelation(body_f,neck,flesh_connected)

    MakeRelation(neck,head,flesh_connected)
    MakeRelation(head,ear_l,flesh_connected)
    MakeRelation(head,ear_r,flesh_connected)

    MakeRelation(body_f,arm_l,flesh_connected)
    MakeRelation(body_f,arm_r,flesh_connected)
    MakeRelation(body_b,leg_l,flesh_connected)
    MakeRelation(body_b,leg_r,flesh_connected)

    MakeRelation(arm_l,hand_l,flesh_connected)
    MakeRelation(arm_r,hand_r,flesh_connected)
    MakeRelation(leg_l,foot_l,flesh_connected)
    MakeRelation(leg_r,foot_r,flesh_connected)
 

    body_f.location = self
    body_b.location = self
    neck.location = self
    head.location = self
    arm_l.location = self
    arm_r.location = self 
    leg_l.location = self
    leg_r.location = self
    hand_l.location = self
    hand_r.location = self  
    foot_l.location = self
    foot_r.location = self
 
end
 
reference_troll = Def("reference_troll","troll")
