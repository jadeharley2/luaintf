

unzip_action = Def('unzip_action',{key='unzip',restrictions = {"!asleep","!animatronic"},callback = function(self) 
    local is_player = self == player 
    local ins = self.costume 
    if ins then
        local w = ins.wearer
        ins.wearer:takeoff(ins) 
        describe_action(w,L'you take off [ins]',tostring(w)..' takes off '..tostring(ins))  
        return true
    end
    return false
end},'action') 


morph_costume = Def('morph_costume','clothing')
morph_costume.on_new_worn_by = function(self, wearer)
    local pm = self.pmorph
    if not pm then 
        pm = Inst(self.morph.id)
        pm.costume = self 
        pm:act_add(unzip_action)
        pm.mind = no_mind
        self.pmorph = pm 
    end
    wearer:foreach('contains',function(x)
        if not x.is_worn then
            x.location = pm
            --pm:act('drop',x)
        end
    end)
    pm.location = wearer.location
    wearer.location = pm
    mind_transfer(wearer,pm) 
 
    ScenarioRun("mind_transformation",pm.id..'_mtf',{
        source = wearer,
        target = pm, 
        duration = 30,
    }) 

    send_character_images_inroom(pm.location)
end
morph_costume.on_rem_worn_by = function(self, wearer)
    local pm = self.pmorph
    pm:foreach('contains',function(x)
        x.location = wearer
        --pm:act('drop',x)
    end)
    wearer.location = pm.location
    pm.location = self
    mind_transfer(pm,wearer)  
 
    ScenarioRun("mind_transformation",wearer.id..'_mtf',{
        source = pm,
        target = wearer, 
        duration = 30,
    },true) 

    send_character_images_inroom(wearer.location)
end
morph_costume.examine = function(self,user)
    if user.costume==self then
        self.location:examine(user)
    else
        morph_costume.base.examine(self,user)
    end
end

m_zipper = Def('m_zipper',{name='zipper'},'thing')
m_zipper.image = '/img/items/zipper.png'


z_puton = Def('z_puton',{key='put_on',user_restrictions = {"!asleep"},callback = function(self,user,target) 
    local is_player = user == player 
    if target then
        local something = LocalIdentify(target)
        if something then
            if something:is(person) and not something.costume then --and something:call("can_wear",self)~=false then
                local loc = something.location
                
                local costume = Inst('morph_costume')
                costume.name = tostring(something)..' costume'
                costume.image = something.image
                something.costume = costume 
                something:act_add(unzip_action)
                --something.mind = no_mind
                costume.pmorph = something 
                costume.location = loc
                something.location = costume
                self.location = nowhere
                send_character_images_inroom(loc)
                describe_action(something,'you collapse on the floor',L"[something] deflates and falls to the floor")  
                return true
            else
                if is_player then printout('you cannot put zipper on '..target) end
            end
        else
            if is_player then printout('there is no '..target) end
        end 
    else
        if is_player then printout('wear what?') end
    end
    return false
end},'interaction') 
m_zipper:interact_add(z_puton)
