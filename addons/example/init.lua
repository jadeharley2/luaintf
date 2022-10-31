
rubber_foxmorph = Def('rubber_foxmorph',{name='Rubber Fox'},'animal')
rubber_foxmorph.image = '/img/rpg/characters/rubber_fox.png'
rubber_foxmorph.unknown_name = 'Rubber Fox'
rubber_foxmorph.maxhealth = 50
rubber_foxmorph.damage = 30
rubber_foxmorph.evasion = 60
rubber_foxmorph.accuracy = 30
rubber_foxmorph.tactic = "attack"

--on found by player
rubber_foxmorph:event_add('found','x',function(self,by)
    if by:is('deer') or by:is('sheep') then  
        combat.Begin({{self},{by}})
    elseif by:is('wolf') then 
        --no
    elseif math.random()>0.8 then
        combat.Begin({{self},{by}})
    end
end)

--spawn chances (biomedef).population[(def)] = probability
biome_grassland.population['rubber_foxmorph'] = 0.04 --4%