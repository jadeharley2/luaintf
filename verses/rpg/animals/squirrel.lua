

species_squirrel = Def('squirrel',{name='squirrel'},'animal') 
species_squirrel.species_images = {
    female = "/img/rpg/species/animals/squirrel_f.png",
    _ = "/img/rpg/species/animals/squirrel_m.png",
} 
species_squirrel.unknown_name = 'squirrel'
species_squirrel.maxhealth = 10
species_squirrel.damage = 5
species_squirrel.evasion = 80
species_squirrel.accuracy = 50
species_squirrel.tactic = "flee"
--eats: 

species_squirrel:event_add('found','x',function(self,by)
    --if by:is('deer') or by:is('sheep') then 
    --    --if suitable target check (deer etc)
    --    combat.Begin({{self},{by}})
    --elseif by:is('wolf') then 
    --    --no
    --elseif math.random()>0.8 then
    --    combat.Begin({{self},{by}})
    --end
end)