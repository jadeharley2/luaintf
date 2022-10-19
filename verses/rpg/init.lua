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


Include('species.lua')
Include('animals.lua')
Include('biomes.lua')
Include('map.lua')


 

--test

biomelist = {}
local sbc = string.char
local function addbiome(biome)
    local r,g,b = hex2rgb(biome.tilecolor)
    local binary = sbc(r)..sbc(g)..sbc(b)
    biomelist[binary] = biome.id
end
 
addbiome(biome_grassland)

addbiome(biome_forest)
addbiome(biome_forest_deep)
addbiome(biome_forest_river)
addbiome(biome_swamp)

addbiome(biome_sea)
addbiome(biome_sea_shallow)
addbiome(biome_beach)

addbiome(biome_river)

addbiome(biome_town)

addbiome(biome_highland)
addbiome(biome_highland_forest)
addbiome(biome_highland_river)

addbiome(biome_steppe)
addbiome(biome_desert_half)
addbiome(biome_desert)
addbiome(biome_desert_rocky)

addbiome(biome_mountain)
addbiome(biome_mountain_forest)
addbiome(biome_glacier)

local path = "C:/_root/projects/src/TileServer/WebRelay/bin/Debug/data/img/rpg/world/wmaptest.raw"
local path2 = "C:/_root/projects/src/TileServer/WebRelay/bin/Debug/data/img/rpg/world/wmaptest_roads.raw"
local map0 = loadmap(path,path2,256,512,biomelist,rpg_verse) 

local somerandomtile = map0[69+129*256]


testnaga = Def('testnaga',{name='Lieya'},"female green naga person")
testnaga.location = somerandomtile

testnaga2 = Def('testnaga2',{name="Areya"},"female gold naga person")
testnaga2.location = somerandomtile
testnaga2.npc = true

testkob = Def('testkob',{name='Xezi'},"female green kobold person")
testkob.location = somerandomtile
testkob.npc = true

print(testkob.icon)
local fir=0