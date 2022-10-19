
species_animal = Def('animal',{},'feral person')

function species_animal:_get_image()
    return adj_choice_tree(self,self.species_images)
end
function species_animal:_get_icon()
    return self.image:sub(1,-5)..'_av.png'
end  
function species_animal:_get_unknown_name()
    return adj_choice_tree(self,self.species_names)
end


species_deer = Def('deer',{name='deer'},'animal')
species_deer.species_images = {
    female = "/img/rpg/species/animals/deer_f.png",
    _ = "/img/rpg/species/animals/deer_m.png",
}
species_deer.species_names = {
    female = "doe",
    _ = "buck",
}

species_wolf = Def('wolf',{name='wolf'},'animal') 
species_wolf.species_images = {
    brown = {
        female = "/img/rpg/species/animals/wolf_brown_f.png",
        _ = "/img/rpg/species/animals/wolf_brown_m.png",
    },
    _ = { --gray
        female = "/img/rpg/species/animals/wolf_gray_f.png",
        _ = "/img/rpg/species/animals/wolf_gray_m.png",
    },
}
species_wolf.species_names = {
    brown = "brown wolf",
    _ = "gray wolf",
}

species_sheep = Def('sheep',{name='sheep'},'animal')
species_sheep.species_images = {
    black = {
        female = "/img/rpg/species/animals/sheep_black_f.png",
        _ = "/img/rpg/species/animals/sheep_black_m.png",
    },
    _ = { --gray
        female = "/img/rpg/species/animals/sheep_white_f.png",
        _ = "/img/rpg/species/animals/sheep_white_m.png",
    },
}
species_sheep.species_names = {
    black = {
        female = "black sheep",
        _ = "black ram",
    },
    _ = {
        female = "white sheep",
        _ = "white ram",
    },
}

