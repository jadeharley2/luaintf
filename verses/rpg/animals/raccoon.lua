

species_raccoon = Def('raccoon',{name='raccoon'},'animal') 
species_raccoon.species_images = {
    female = "/img/rpg/species/animals/raccoon_f.png",
    _ = "/img/rpg/species/animals/raccoon_m.png",
} 
species_raccoon.unknown_name = 'raccoon'
species_raccoon.maxhealth = 40
species_raccoon.damage = 25
species_raccoon.evasion = 60
species_raccoon.accuracy = 40
species_raccoon.tactic = "flee"
--eats: 

species_raccoon:event_add('found','x',function(self,by)
    --if by:is('deer') or by:is('sheep') then 
    --    --if suitable target check (deer etc)
    --    combat.Begin({{self},{by}})
    --elseif by:is('wolf') then 
    --    --no
    --elseif math.random()>0.8 then
    --    combat.Begin({{self},{by}})
    --end
end)