
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
species_deer.maxhealth = 60
species_deer.damage = 20
species_deer.evasion = 70
species_deer.accuracy = 60
species_deer.tactic = "flee"

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
species_wolf.health_tree= {
    brown = 80,
    _ = 90,--gray
}
species_wolf.damage_tree= {
    brown = 30,
    _ = 35,--gray
} 
species_wolf.evasion = 30
species_wolf.accuracy = 70
species_wolf.tactic = "attack"
species_wolf._get_maxhealth = function(self)
    return adj_choice_tree(self,self.health_tree)
end
species_wolf._get_damage = function(self)
    return adj_choice_tree(self,self.damage_tree)
end

species_wolf:event_add('found','x',function(self,by)
    if by:is('deer') or by:is('sheep') then 
        --if suitable target check (deer etc)
        combat.Begin({{self},{by}})
    elseif by:is('wolf') then 
        --no
    elseif math.random()>0.8 then
        combat.Begin({{self},{by}})
    end
end)

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
species_sheep.maxhealth = 60
species_sheep.damage = 30
species_sheep.evasion = 50
species_sheep.accuracy = 40
species_sheep.tactic = "flee"

