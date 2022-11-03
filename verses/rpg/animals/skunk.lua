

species_skunk = Def('skunk',{name='skunk'},'animal') 
species_skunk.species_images = {
    female = "/img/rpg/species/animals/squirrel_f.png",
    _ = "/img/rpg/species/animals/squirrel_m.png",
} 
species_skunk.unknown_name = 'skunk'
species_skunk.maxhealth = 20
species_skunk.damage = 10
species_skunk.evasion = 80
species_skunk.accuracy = 50
species_skunk.tactic = "flee"
--eats: 

species_skunk:event_add('found','x',function(self,by)
    --if by:is('deer') or by:is('sheep') then 
    --    --if suitable target check (deer etc)
    --    combat.Begin({{self},{by}})
    --elseif by:is('wolf') then 
    --    --no
    --elseif math.random()>0.8 then
    --    combat.Begin({{self},{by}})
    --end
end)