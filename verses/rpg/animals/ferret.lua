

species_ferret = Def('ferret',{name='ferret'},'animal') 
species_ferret.species_images = {
    female = "/img/rpg/species/animals/ferret_f.png",
    _ = "/img/rpg/species/animals/ferret_m.png",
} 
species_ferret.unknown_name = 'ferret'
species_ferret.maxhealth = 20
species_ferret.damage = 15
species_ferret.evasion = 80
species_ferret.accuracy = 60
species_ferret.tactic = "flee"
--eats: 

species_ferret:event_add('found','x',function(self,by)
    --if by:is('deer') or by:is('sheep') then 
    --    --if suitable target check (deer etc)
    --    combat.Begin({{self},{by}})
    --elseif by:is('wolf') then 
    --    --no
    --elseif math.random()>0.8 then
    --    combat.Begin({{self},{by}})
    --end
end)