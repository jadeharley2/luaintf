

species_fox = Def('fox',{name='fox'},'animal') 
species_fox.species_images = {
    female = "/img/rpg/species/animals/fox_f.png",
    _ = "/img/rpg/species/animals/fox_m.png",
} 
species_fox.species_names = {
    female = "Vixen",
    _ = "Renard",
} 
species_fox.maxhealth = 60
species_fox.damage = 30
species_fox.evasion = 60
species_fox.accuracy = 70
species_fox.tactic = "flee"
species_fox.unknown_name = "Fox"
--eats: insects, birds, eggs, vegetation

species_fox:event_add('found','x',function(self,by)
    --if by:is('deer') or by:is('sheep') then 
    --    --if suitable target check (deer etc)
    --    combat.Begin({{self},{by}})
    --elseif by:is('wolf') then 
    --    --no
    --elseif math.random()>0.8 then
    --    combat.Begin({{self},{by}})
    --end
end)