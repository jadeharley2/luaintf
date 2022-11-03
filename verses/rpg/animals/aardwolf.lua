

species_aardwolf = Def('aardwolf',{name='aardwolf'},'animal') 
species_aardwolf.species_images = {
    female = "/img/rpg/species/animals/aardwolf_f.png",
    _ = "/img/rpg/species/animals/aardwolf_m.png",
} 
species_aardwolf.unknown_name = 'aardwolf'
species_aardwolf.maxhealth = 50
species_aardwolf.damage = 30
species_aardwolf.evasion = 60
species_aardwolf.accuracy = 45
species_aardwolf.tactic = "flee"
--eats: 

species_aardwolf:event_add('found','x',function(self,by)
end)