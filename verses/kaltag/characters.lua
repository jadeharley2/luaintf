

anthroid = Def('anthroid',{name='anthroid' },'adjective') 

anthroid:interact_add(press_interaction)
anthroid.this.buttons = {
    toggle_power = function(self,user)
        if self:is('asleep') then 
            self:adj_unset('asleep')
            self:say('all systems online')
        else
            self:say('shutting down...')
            self:adj_set('asleep')
        end
    end,
    reset_personality_core = function(self,user)
        if self.personality ~= self then
            self:say('downloading personality core update from the tower...')
            self:say('download complete, restarting...')
            self:adj_set('asleep') 
            self.identity = self
            self:adj_unset('asleep')
        else
            self:say('personality core is up to date')
        end
    end
    --display = function(self,user)
    --    printout("$display:target;https://cdn.discordapp.com/attachments/531891665993203722/942877231997415484/unknown.png")
    --end,
}

person._get_species = function(x)
    return x:collect('adjectives',function(v) 
        local def = adjective_def[v]
        if def and def:is('species') then
            return def 
        end
    end)
end
person._get_unknown_name = function(x)
    return table.concat({x.color, x.species}," ")
end

--ara.unknown_name = "red anthroid feline"
--srk.unknown_name = "short anthroid feline"
--zta.unknown_name = "white anthroid kleika"


ara = Def('ara',{name='ARA', code = '0-1-1'},'female feline anthroid person') 
ara.image = 'https://cdn.discordapp.com/attachments/760334294681124908/943211101754118245/ara.png'
--'https://cdn.discordapp.com/attachments/531891665993203722/943137499256074260/furry-f-furry-art-furry--6411268.png'
--'https://cdn.discordapp.com/attachments/531891665993203722/943211236538089622/ara.png'
ara:set_clothes('owned female anthroid_uniform','owned female anthroid_long_gloves','owned female anthroid_stocking','owned anthroid_collar','owned anthroid_visor')
ara:find('anthroid_uniform').image = '/img/items/ara_uniform.png'
ara:find('anthroid_long_gloves').image = '/img/items/ara_arms.png'
ara:find('anthroid_stocking').image = '/img/items/ara_legs.png'
ara:find('anthroid_collar').image = '/img/items/ara_collar.png'
ara:find('anthroid_visor').image = '/img/items/ara_visor.png'

srk = Def('srk',{name='Warning', code ='07-4-31'},'female feline anthroid person') 
srk.image = 'https://cdn.discordapp.com/attachments/760334294681124908/943209342293905478/srk.png'
srk:set_clothes('owned female anthroid_uniform','owned female anthroid_gloves','owned female anthroid_stocking','owned anthroid_collar')
srk:find('anthroid_uniform').image = '/img/items/srk_uniform.png'
srk:find('anthroid_gloves').image = '/img/items/srk_gloves.png'
srk:find('anthroid_stocking').image = '/img/items/srk_legs.png'
srk:find('anthroid_collar').image = '/img/items/srk_collar.png'

zta = Def('zta',{name='Zeta', code='37-8-12'},'female kleika anthroid person') 
zta.image = 'https://cdn.discordapp.com/attachments/760334294681124908/943209772088426506/zta.png'
zta:set_clothes('owned female anthroid_uniform','owned female anthroid_gloves','owned female anthroid_stocking','owned anthroid_collar')
zta:find('anthroid_uniform').image = '/img/items/zta_uniform2.png'
zta:find('anthroid_gloves').image = '/img/items/zta_gloves2.png'
zta:find('anthroid_stocking').image = '/img/items/zta_legs2.png'
zta:find('anthroid_collar').image = '/img/items/zta_collar2.png'
zta.intent_defaults = {formal=true,misspelling=false}
zta.memory.hates_misspelling = true

tvk = Def('tvk',{name='Vale', code='86-44-21'},'male anthroid person') 
tvk.image = 'https://cdn.discordapp.com/attachments/760334294681124908/943207738991857793/vc.png'
--'https://cdn.discordapp.com/attachments/531891665993203722/943216181962244118/vale.png'
tvk:set_clothes('owned male anthroid_uniform','owned anthroid_collar')
tvk:find('anthroid_uniform').image = '/img/items/tvk_uniform.png'
tvk:find('anthroid_collar').image = '/img/items/tvk_collar.png'

vst = Def('vst',{name='VST'},'male anthroid person') 
vst.image = 'https://cdn.discordapp.com/attachments/760334294681124908/943220091355545600/vst.png'
vst.process_speech = function(self,text) 
    text = string.upper(text)
    --text = text:replace("I AM",'THIS UNIT IS'
    if self.identity.robotic then
        text = string.gsub(text,'CAN','MAY')
        text = string.gsub(text,'BEGIN','INITIATE')

        text = string.gsub(text,'OK',table.random({'AFFIRMATIVE',"ACKNOWLEDGED"}))
    end
    return text
end
vst.robotic = true
vst.intent_defaults = {robotic=true} 



zofie = Def('zofie',{name='Zofie'},'female canine anthro person') 
zofie.image = '/img/characters/zofie2.png'
zofie:set_clothes('owned female uniform','owned female stocking')
zofie:find('uniform').image = '/img/items/zofie_wear.png'
zofie:find('stocking').image = '/img/items/zofie_legs.png' 


vikna = Def('vikna',{name='Vikna', surname='Ramenskaya'},'female feline anthro person')  
vikna.image = 'https://cdn.discordapp.com/attachments/760334294681124908/943210593094078474/vikna.png'
vikna:set_clothes('owned female uniform','owned female boots','owned female hat')
vikna:find('hat').image = '/img/items/cold_hat.png'
vikna:find('uniform').image = '/img/items/cold_form.png'
vikna:find('boots').image = '/img/items/cold_boots.png'


nytro = Def('nytro',{name='Nytro', surname='Sykran'},'male canine anthro person') 
nytro.image = 'https://cdn.discordapp.com/attachments/760334294681124908/943212074878783548/nytro.png'
nytro:set_clothes('owned male uniform','owned visor','owned male boots')
nytro:find('visor').image = '/img/items/nytro_visor.png'
nytro:find('uniform').image = '/img/items/nytro_work.png'
nytro:find('boots').image = '/img/items/nytro_boots.png'
nytro_sword = Def('nytro_sword',{name='sword'},'owned thing')
nytro_sword.location = nytro
nytro_sword.owner = nytro
nytro_sword.image = '/img/items/nytro_sword.png'
MakeRelation(nytro_sword,nytro,owner)


ayn = Def('ayn',{name='Ayn'},'female jackal anthro person') 
ayn.image = 'https://cdn.discordapp.com/attachments/760334294681124908/943214682087518238/ayn.png'
ayn:set_clothes('owned female uniform','owned female gloves','owned female boots','owned female tiara')
ayn:find('uniform').image = '/img/items/ayn_form.png'
ayn:find('gloves').image = '/img/items/ayn_gloves.png' 
ayn:find('boots').image = '/img/items/ayn_boots.png' 
ayn:find('tiara').image = '/img/items/ayn_tiara.png' 
ayn.mood = 'angry'
ayn_staff = Def('ayn_staff',{name='staff'},'owned thing')
ayn_staff.location = ayn
ayn_staff.owner = ayn
ayn_staff.image = '/img/items/ayn_staff.png' 




twix = Def('twix',{name='Twix'},'female canine anthro person') 
twix.image = '/img/characters/twix.png'
twix:set_clothes('owned female uniform','owned female stocking')

lia = Def('lia',{name='Lia'},'female canine anthro person') 
lia.image = '/img/characters/lia.png'
lia:set_clothes('owned female uniform','owned female stocking')
--lia:find('uniform').image = '/img/items/zofie_wear.png'
--lia:find('stocking').image = '/img/items/zofie_legs.png' 


kesis = Def('kesis',{name='Kesis'},'female canine anthro person') 
kesis.image = '/img/characters/kesis.png'
kesis:set_clothes('owned female uniform','owned female stocking')

radoslav = Def('radoslav',{name='Radoslav'},'male kleika anthro person') 
radoslav.image = '/img/characters/radoslav.png'
radoslav:set_clothes('owned male uniform' )


--tvk




tvk:act_add(sensors_ship_action)
tvk:act_add(dock_ship_action)
tvk:act_add(undock_ship_action)
tvk:act_add(navigate_ship_action)



tvk:interact_add(command_interaction)





tvk:response("dock to station",function(s,t)
    if katric_capital_ship.docked then
        s:say('we already docked')
    else
        s:say('ok') 
        katric_capital_ship:dock(torus_station)
    end
end)
tvk:response("undock",function(s,t)
    if katric_capital_ship.docked then
        s:say('ok') 
        katric_capital_ship:undock()
    else
        s:say('no...')
    end
end)


vikna.mind.swap_request = function(self,F,I,D,T)
    if I.target then
        if LocalIdentify(I.target)==vst then
            self:intent_say('that giant robotic dog?',true)  
            self:intent_say('i always wanted to know how being an anthroid feels',true)  
            D.agreed = true
            D.topic = "bodyswap" 
            return true 
        end
    end
end


 