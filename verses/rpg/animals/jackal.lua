

species_jackal = Def('jackal',{name='jackal'},'animal') 
species_jackal.species_images = {
    female = "/img/rpg/species/animals/jackal_f.png",
    _ = "/img/rpg/species/animals/jackal_m.png",
} 
species_jackal.unknown_name = 'jackal'
species_jackal.maxhealth = 50
species_jackal.damage = 30
species_jackal.evasion = 60
species_jackal.accuracy = 45
species_jackal.tactic = "flee"
--eats: 

species_jackal:event_add('found','x',function(self,by)
    if by:is('deer') or by:is('sheep') then 
        --if suitable target check (deer etc)
        combat.Begin({{self},{by}})
    else
        --no
    end
end)