

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