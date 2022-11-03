

species_hyena = Def('hyena',{name='hyena'},'animal') 
species_hyena.species_images = {
    female = "/img/rpg/species/animals/hyena_f.png",
    _ = "/img/rpg/species/animals/hyena_m.png",
} 
species_hyena.unknown_name = 'hyena'
species_hyena.maxhealth = 50
species_hyena.damage = 30
species_hyena.evasion = 60
species_hyena.accuracy = 45
species_hyena.tactic = "flee"
--eats: 

species_hyena:event_add('found','x',function(self,by)
    if by:is('deer') or by:is('sheep') then 
        --if suitable target check (deer etc)
        combat.Begin({{self},{by}})
    else
        --no
    end
end)