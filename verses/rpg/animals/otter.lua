

species_otter = Def('otter',{name='otter'},'animal') 
species_otter.species_images = {
    female = "/img/rpg/species/animals/otter_f.png",
    _ = "/img/rpg/species/animals/otter_m.png",
} 
species_otter.unknown_name = 'otter'
species_otter.maxhealth = 30
species_otter.damage = 20
species_otter.evasion = 60
species_otter.accuracy = 60
species_otter.tactic = "flee"
--eats: 

species_otter:event_add('found','x',function(self,by)
    --if by:is('deer') or by:is('sheep') then 
    --    --if suitable target check (deer etc)
    --    combat.Begin({{self},{by}})
    --elseif by:is('wolf') then 
    --    --no
    --elseif math.random()>0.8 then
    --    combat.Begin({{self},{by}})
    --end
end)