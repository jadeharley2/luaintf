
catpuns = {
    ['for real'] = 'fur real',
    whenever = 'whenefur',
    possible = 'pawsible',
    athletic = 'cathletic',
    awful = 'clawful',
    perfect = 'purrfect',
    feeling = 'feline',
    clever = 'clawver',
    tale = 'tail',
    perhaps = 'purrhaps',
    possibility = 'pawsibility',
    friend = 'furend',
    pretty = 'purrty',
    literate = 'litterate',
    hysterical = 'hissterical',
    now = 'meow',
    pause = 'paws',
    familiar = 'furmilliar',
    awesome = 'pawsome',
    forget = 'furget',
    attitude = 'catitude',
    forever = 'furrever',
    appaling = 'apawling',
    radical = 'radiclaw',
    music = 'mewsic',
    inferior = 'infurior',
    metaphorically = 'metafurkitty',
    --you = 'mew',
    minimum = 'mewnimum',
    himself = 'hissself',
    misery = 'mewsery',
    forward = 'furward',
    perceive = 'purceive',
    very = 'furry',
}







change_action = Def('change_action',{key='change',restrictions = {"!asleep"},callback = function(self,arg) 
    self:change(arg)
end},'action') 


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
renamon.view_style = { 
    bg1 =  '#000000',

    bg2d = '#b25c1f',
    bg2l = '#fad36e',

    bg3d = '#65477b',
    bg3l = '#8f6ea7',

    text = '#ffffff', 
}      

renamon_costume = Def('renamon_costume',{
	  name = "Renamon costume", 
   morph = renamon,
},'morph_costume')
renamon_costume.view_style = { 
    bg1 =  '#000000',

    bg2d = '#1d1d1d',
    bg2l = '#2f2f30',

    bg3d = '#1c6207',
    bg3l = '#4ac925',

    text = '#ffffff', 
}
renamon_costume.image = '/img/items/renamon_costume.png'

renamon_gloves = Def('renamon_gloves',{},'owned purple gloves')
renamon_gloves.image = '/img/items/renamon_glove.png'
renamon_gloves.owner = renamon