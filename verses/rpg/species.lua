


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
function naga:_get_icon()
    return self.image:sub(1,-5)..'_av.png'
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
function kobold:_get_icon()
    return self.image:sub(1,-5)..'_av.png'
end 
function kobold:_get_unknown_name()
    if self:is('brown') then return 'Brown kobold' 
    else return 'Green kobold'
    end
end



