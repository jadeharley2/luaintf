
jade = Def('jade','witch_class space_aspect nerdy female person')
jade.image = '/img/characters/jade.png'  
jade:wear('owned shirt','owned skirt','owned stocking','owned shoes','owned glasses')
jade:find('shirt').image = '/img/items/jh_shirt.png'
jade:find('skirt').image = '/img/items/jh_skirt.png'
jade:find('shoes').image = '/img/items/jh_shoes.png'
jade:find('glasses').image = '/img/items/glasses_round.png'
jade:find('stocking').image = '/img/items/jh_stock.png' 

aradia = Def('aradia','gothic female troll person')
aradia.image = '/img/characters/aradia.png'  
aradia:wear('owned shirt','owned skirt')
aradia.process_speech = function(self,text) 
    text = string.replace(text,".","")
    text = string.replace(text,",","")
    text = string.replace(text,"!","")
    text = string.replace(text,"?","")
    text = string.replace(text,"o","0") 
    return text
end




nepeta = Def('nepeta','rogue_class heart_aspect catlike female troll person')
nepeta.image = '/img/characters/nepeta.png'  
nepeta:wear('owned shirt','owned pants','owned coat')
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
nepeta:find('shirt').image = '/img/items/nep_shirt.png'
nepeta:find('pants').image = '/img/items/nep_pants.png'
nepeta:find('coat').image = '/img/items/nep_coat.png'

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