


species = Def('species','adjective')


anthro = Def('anthro','adjective')

canine = Def('canine','anthro species')
feline = Def('feline','anthro species')



naga = Def('naga','anthro species')
naga.species_images = {
    black = {
        female = "/img/rpg/species/anthros/naga_black_f.png",
        _ = "/img/rpg/species/anthros/naga_black_m.png",
    },
    green = {
        female = "/img/rpg/species/anthros/naga_green_f.png",
        _ = "/img/rpg/species/anthros/naga_green_m.png",
    },
    blue = {
        female = "/img/rpg/species/anthros/naga_blue_f.png",
        _ = "/img/rpg/species/anthros/naga_blue_m.png",
    },
    purple = { 
        female = "/img/rpg/species/anthros/naga_purple_f.png",
        _ = "/img/rpg/species/anthros/naga_purple_m.png",
    }, 
    gold = { 
        female = "/img/rpg/species/anthros/naga_gold_f.png",
        _ = "/img/rpg/species/anthros/naga_gold_m.png",
    },
    silver = { 
        female = "/img/rpg/species/anthros/naga_silver_f.png",
        _ = "/img/rpg/species/anthros/naga_silver_m.png",
    },
    _ = {--red
        female = "/img/rpg/species/anthros/naga_red_f.png",
        _ = "/img/rpg/species/anthros/naga_red_m.png",
    }
}
function naga:_get_image()
    return adj_choice_tree(self,self.species_images)
end
function naga:_get_unknown_name()
    if self:is('black') then return 'Black naga'
    elseif self:is('green') then return 'Green naga'
    elseif self:is('blue') then return 'Blue naga'
    elseif self:is('purple') then return 'Purple naga'
    elseif self:is('gold') then return 'Golden naga'
    elseif self:is('silver') then return 'Silver naga'
    else return 'Red naga'
    end
end



kobold = Def('kobold','anthro species')
kobold.species_images = {
    brown = {
        female = "/img/rpg/species/anthros/kobold_brown_f.png",
        _ = "/img/rpg/species/anthros/kobold_brown_m.png",
    },
    green = {
        female = "/img/rpg/species/anthros/kobold_green_f.png",
        _ = "/img/rpg/species/anthros/kobold_green_m.png",
    },
}
function kobold:_get_image()
    return adj_choice_tree(self,self.species_images)
end 
function kobold:_get_unknown_name()
    if self:is('brown') then return 'Brown kobold' 
    else return 'Green kobold'
    end
end



foxmorph = Def('foxmorph','anthro species') 
foxmorph.species_images = {
    female = "/img/rpg/species/anthros/fox_f.png",
    _ = "/img/rpg/species/anthros/fox_m.png",
}
function foxmorph:_get_image()
    return adj_choice_tree(self,self.species_images)
end 
function foxmorph:_get_unknown_name()
    if self:is('female') then return 'Vixen' end 
    return 'Renard'
end
 
fennecmorph = Def('fennecmorph','anthro species') 
fennecmorph.unknown_name = 'fennec'
fennecmorph.species_images = {
    female = "/img/rpg/species/anthros/fennec_f.png",
    _ = "/img/rpg/species/anthros/fennec_m.png",
}
function fennecmorph:_get_image()
    return adj_choice_tree(self,self.species_images)
end 
 
deermorph = Def('deermorph','anthro species') 
deermorph.unknown_name = 'deer'
deermorph.species_images = {
    female = "/img/rpg/species/anthros/deer_f.png",
    _ = "/img/rpg/species/anthros/deer_m.png",
}
deermorph.feral_form = 'deer'
function deermorph:_get_image()
    return adj_choice_tree(self,self.species_images)
end 
function deermorph:_get_unknown_name()
    if self:is('female') then return 'Doe' end 
    return 'Buck'
end
 


skunkmorph = Def('skunkmorph','anthro species') 
skunkmorph.unknown_name = 'skunk'
skunkmorph.species_images = {
    female = "/img/rpg/species/anthros/skunk_f.png",
    _ = "/img/rpg/species/anthros/skunk_m.png",
}
function skunkmorph:_get_image()
    return adj_choice_tree(self,self.species_images)
end 
 


