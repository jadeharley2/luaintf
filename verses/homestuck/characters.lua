
jade = Def('jade','witch_class space_aspect nerdy female person')
jade.image = '/img/hs/characters/jade.png'   
jade.view_style = { 
    bg1 =  '#000000',

    bg2d = '#1d1d1d',
    bg2l = '#2f2f30',

    bg3d = '#1c6207',
    bg3l = '#4ac925',

    text = '#ffffff', 
}
--[[ 
    --bg1-color: #000000;

    --bg2d-color: #1d1d1d;
    --bg2l-color: #2f2f30;

    --bg3d-color: #4d4d4d;
    --bg3l-color: #838383;

    --text-color: #ffffff; 
]]
jade:set_clothes('owned shirt','owned skirt','owned stocking','owned shoes','owned glasses')
jade:find('shirt').image = '/img/hs/items/jh_shirt.png'
jade:find('skirt').image = '/img/hs/items/jh_skirt.png'
jade:find('shoes').image = '/img/hs/items/jh_shoes.png'
jade:find('glasses').image = '/img/hs/items/glasses_round.png'
jade:find('stocking').image = '/img/hs/items/jh_stock.png' 

soulbot = Def('soulbot','robot person')

jadebot = Def('jadebot',{},'owned mute soulbot')
jadebot.image = '/img/hs/characters/jadebot.png'   
jadebot.robotic = true 
MakeRelation(jadebot,jade,owner)

rose = Def('rose','seer_class light_aspect female person')
rose.image = '/img/hs/characters/rose.png'   
rose.view_style = { 
    bg1 =  '#321544',

    bg2d = '#571a7d',
    bg2l = '#935eb4',

    bg3d = '#f0840c',
    bg3l = '#f6fa4e',

    text = '#ffd4f7', 
}
rose:set_clothes('owned shirt','owned skirt','owned shoes')
--rose:find('shirt').image = '/img/hs/items/jh_shirt.png'
--rose:find('skirt').image = '/img/hs/items/jh_skirt.png'
--rose:find('shoes').image = '/img/hs/items/jh_shoes.png' 



roxy = Def('roxy','rogue_class void_aspect female person')
roxy.image = '/img/hs/characters/roxy.png'  
roxy.view_style = { 
    bg1 =  '#321544',

    bg2d = '#4b3d5d',
    bg2l = '#fe8bfd',

    bg3d = '#03266a',
    bg3l = '#104ea2',

    text = '#ffd4f7', 
}
roxy:set_clothes('owned shirt','owned skirt','owned shoes')






john = Def('john','heir_class breath_aspect male person')
john.image = '/img/hs/characters/john.png'  
john.view_style = { 
    bg1 =  '#000000',

    bg2d = '#1b2573',
    bg2l = '#5162e1',

    bg3d = '#4379e6',
    bg3l = '#47def9',

    text = '#ffffff', 
} 
john:set_clothes('owned shirt','owned pants','owned shoes','owned glasses')

dave = Def('dave','knight_class time_aspect male person')
dave.image = '/img/hs/characters/dave.png'
dave.view_style = { 
    bg1 =  '#000000',

    bg2d = '#400202',
    bg2l = '#8e1516',

    bg3d = '#9b0b0c',
    bg3l = '#ff2106',

    text = '#ffffff', 
}    
dave:set_clothes('owned shirt','owned pants','owned shoes','owned glasses')


--[[      ======================================      ]]



aradia = Def('aradia','witch_class time_aspect gothic female troll person')
aradia.image = '/img/hs/characters/aradia.png'  
aradia.view_style = { 
    bg1 =  '#000000',

    bg2d = '#252525',
    bg2l = '#424242',

    bg3d = '#9b0b0c',
    bg3l = '#ff2106',

    text = '#c7c7c7', 
}  
aradia:set_clothes('owned black shirt','owned gray skirt')
aradia:find('shirt').image = '/img/hs/items/ara_shirt.png'
aradia.process_speech = function(self,text) 
    text = string.replace(text,".","")
    text = string.replace(text,",","")
    text = string.replace(text,"!","")
    text = string.replace(text,"?","")
    text = string.replace(text,"o","0") 
    return text
end


aradiabot = Def('aradiabot','robot aradia')
aradiabot.image = '/img/hs/characters/aradia_bot.png'  
aradiabot:set_clothes()
aradiabot.robotic = true
aradiabot.view_style = { 
    bg1 =  '#000000',

    bg2d = '#494949',
    bg2l = '#a6a6a6',

    bg3d = '#9b0b0c',
    bg3l = '#0021cb',

    text = '#ffa29b', 
}   



terezi = Def('terezi','seer_class mind_aspect female troll person')
terezi.image = '/img/hs/characters/terezi.png'   
terezi.view_style = { 
    bg1 =  '#000000',

    bg2d = '#0a4242',
    bg2l = '#008282',

    bg3d = '#00923d',
    bg3l = '#06ffc9',

    text = '#c7c7c7', 
}   
terezi:set_clothes('owned black shirt','owned black pants','owned red glasses','owned red shoes')
terezi:find('shirt').image = '/img/hs/items/tz_shirt.png'
terezi:find('pants').image = '/img/hs/items/tz_pants.png'
terezi:find('shoes').image = '/img/hs/items/tz_shoes.png'
terezi:find('glasses').image = '/img/hs/items/tz_glasses.png'
terezi.process_speech = function(self,text) 
    text = string.upper(text)
    text = string.replace(text,".","")
    text = string.replace(text,",","") 
    text = string.replace(text,"A","4") 
    text = string.replace(text,"I","1") 
    text = string.replace(text,"E","3") 
    return text
end
terezi_cane = Def('terezi_cane',{name='Dragon cane'},'thing')
terezi_cane.image = '/img/hs/items/tz_cane.png'
terezi_cane.location = terezi

kanaya = Def('kanaya','sylph_class space_aspect rainbow_drinker female troll person')
kanaya.image = '/img/hs/characters/kanaya.png' 
kanaya.view_style = { 
    bg1 =  '#000000',

    bg2d = '#1d1d1d',
    bg2l = '#2f2f30',

    bg3d = '#025029',
    bg3l = '#078446',

    text = '#c7c7c7', 
}     
kanaya:set_clothes('owned black shirt', 'owned red skirt', 'owned black shoes')
kanaya:find('shirt').image = '/img/hs/items/kan_shirt.png'
kanaya.process_speech = function(self,text) 
    text = string.replace(text,".","")
    text = string.replace(text,",","") 
    text = string.replace(text,"!","")
    text = string.replace(text,"?","") 
    text = string.gsub(text, "(%l)(%w*)", function(a,b) return string.upper(a)..b end)
    return text
end



nepeta = Def('nepeta','rogue_class heart_aspect catlike female troll person')
nepeta.image = '/img/hs/characters/nepeta.png'  
nepeta.view_style = { 
    bg1 =  '#000000',

    bg2d = '#2d4700',
    bg2l = '#416600',

    bg3d = '#55142a',
    bg3l = '#bd1864',

    text = '#c7c7c7', 
}      
nepeta:set_clothes('owned shirt','owned pants','owned coat')
nepeta.process_speech = function(self,text) 
    text = string.lower(text)

    for k,v in pairs(catpuns) do
        text = string.gsub(text,k,v)
    end
    text = string.gsub(text,"por","purr")
    text = string.gsub(text,"par","purr")
    text = string.gsub(text,"per","purr")
    text = string.gsub(text,"pon","pawn")

    text = string.gsub(text,"ee","33")
    text = string.gsub(text,"ea","33")

    text = string.gsub(text,"'","")
  
    text = " :33 < "..text 
    return text
end
nepeta:find('shirt').image = '/img/hs/items/nep_shirt2.png'
nepeta:find('pants').image = '/img/hs/items/nep_pants.png'
nepeta:find('coat').image = '/img/hs/items/nep_coat.png'

local xswap_scenario = function(self,from,intent,dialogue,text)
    self:act('soulrip',from)
    self:intent_say("my turn")
    self:act('soulrip',self)
end
nepeta.intent_tree = {
    topic_bodyswap = {
        answer = {
            action = {
                positive = function(self,from,intent,dialogue,text)--how
                    --if knows about the book
                    self:intent_say('i know there is a spell that can do this',true)
                    xswap_scenario(self,from,intent,dialogue,text)
                end,-- let's do this
            }
        },
        question = {
            check_possession = false, 
            means = function(self,from,intent,dialogue,text)--how 
                self:intent_say("i can cast soul rip spell, then you can possess my body and I'll posess yours",true)
                self:intent_say("are you ready?",true)
                
                self:intent_hook({"answer"},function(S,F,I,D,T)
                    if I.positive then
                        self:intent_say('good')  
                        xswap_scenario(S,F,I,D,T)
                    end 
                    if I.negative then
                        self:intent_say('ok...')  
                    end 
                    return true
                end) 
            end,
        },
    }
}