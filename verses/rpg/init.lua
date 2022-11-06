rpg_verse = Def('rpg_verse',{name="FRPG"},'universe')


function adj_choice_tree(self, tree)
    for k,v in pairs(tree) do
        if k~='_' and self:is(k) then
            if type(v)=='table' then
                return adj_choice_tree(self,v)
            else
                return v
            end
        end
    end
    local def = tree._ 
    if def then
        if type(def)=='table' then
            return adj_choice_tree(self,def)
        else
            return def
        end
    end
end

thing.adj_choice_tree = adj_choice_tree


DefConditional('can_combat','!dead in_combat !asleep !blind')
DefConditional('can_move','!dead !in_combat !asleep !blind')
DefConditional('can_look','!dead !asleep !blind')
DefConditional('can_talk','!dead !asleep !mute !animal')

Include('squad.lua')
Include('combat.lua')
Include('craft.lua')
Include('needs.lua')

Include('species.lua')
Include('animals.lua')
Include('items.lua')
Include('biomes.lua')
Include('map.lua')

Include('world.lua')

Include('addons.lua')
  

local somerandomtile = rpg_maps.map0:tile(80+maptest2_offset[1],120+maptest2_offset[2])

testnaga = Def('testnaga',{name='Lieya'},"female green naga person")
testnaga.location = somerandomtile

testnaga2 = Def('testnaga2',{name="Areya"},"female gold naga person")
testnaga2.location = somerandomtile
testnaga2.npc = true

testkob = Def('testkob',{name='Xezi'},"female green kobold person")
testkob.location = somerandomtile
testkob.npc = true

testdeer = Def('testdeer',{name='Deeer'},"female deermorph person")
testdeer.location = somerandomtile
testdeer.npc = true

testskunk = Def('testskunk',{name='Skunk'},"female skunkmorph person")
testskunk.location = somerandomtile
testskunk.npc = true
 
testfox = Def('testfox',{name='Fox'},"female foxmorph person")
testfox.location = somerandomtile
testfox.npc = true

testfennec = Def('testfennec',{name='Fenne'},"female fennecmorph person")
testfennec.location = somerandomtile
testfennec.npc = true

testnaga.mind:knows({testkob,testnaga2},"name")
testnaga2.mind:knows({testkob,testnaga},"name")
testkob.mind:knows({testnaga,testnaga2},"name")

local S = squad.Create(testnaga)
S:Join(testnaga2)
S:Join(testkob)


print(testkob.icon)
local fir=0