rpg_verse = Def('rpg_verse',{name="FRPG"},'universe')



Include('species.lua')
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
addbiome(biome_sea)
addbiome(biome_sea_shallow)
addbiome(biome_highland)
addbiome(biome_river)
addbiome(biome_swamp)
addbiome(biome_beach)
addbiome(biome_town)

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