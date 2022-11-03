
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
