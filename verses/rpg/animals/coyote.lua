

species_coyote = Def('coyote',{name='coyote'},'animal') 
species_coyote.species_images = {
    female = "/img/rpg/species/animals/coyote_f.png",
    _ = "/img/rpg/species/animals/coyote_m.png",
} 
species_coyote.unknown_name = 'coyote'
species_coyote.maxhealth = 50
species_coyote.damage = 30
species_coyote.evasion = 60
species_coyote.accuracy = 45
species_coyote.tactic = "flee"
--eats: 

species_coyote:event_add('found','x',function(self,by)
    --if by:is('deer') or by:is('sheep') then 
    --    --if suitable target check (deer etc)
    --    combat.Begin({{self},{by}})
    --elseif by:is('wolf') then 
    --    --no
    --elseif math.random()>0.8 then
    --    combat.Begin({{self},{by}})
    --end
end)