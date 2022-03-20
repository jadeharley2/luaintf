
jade = Def('jade','nerdy female person')
jade.image = 'file://img/characters/jade.png'  
jade:wear('owned shirt','owned skirt','owned stocking','owned shoes','owned glasses')
jade:find('shirt').image = 'file://img/items/jh_shirt.png'
jade:find('skirt').image = 'file://img/items/jh_skirt.png'
jade:find('shoes').image = 'file://img/items/jh_shoes.png'
jade:find('glasses').image = 'file://img/items/glasses_round.png'
jade:find('stocking').image = 'file://img/items/jh_stock.png' 

aradia = Def('aradia','gothic female troll person')
aradia.image = 'file://img/characters/aradia.png'  
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
nepeta.image = 'file://img/characters/nepeta.png'  
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
nepeta:find('shirt').image = 'file://img/items/nep_shirt.png'
nepeta:find('pants').image = 'file://img/items/nep_pants.png'
nepeta:find('coat').image = 'file://img/items/nep_coat.png'
