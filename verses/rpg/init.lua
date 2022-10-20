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

 
--test!!!
Include('wmap.lua')
print(temp)
 

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

local maps_dir = "C:/_root/projects/src/TileServer/WebRelay/bin/Debug/data/img/rpg/world/"
local path = maps_dir.."wmaptest.raw"
local path2 = maps_dir.."wmaptest_roads.raw"
--local map0 = loadmap(path,path2,256,512,biomelist,rpg_verse) 

local map0 = loadmap2(256,512,rpg_verse,{
    {
        type = {adjective=true},
        path = maps_dir.."wmaptest.raw",
        code = biomelist,
    },
    {
        type = {boolean=true},
        path = maps_dir.."wmaptest_roads.raw",
        code = {
            ["#a4a4a4"] = "has_road"
        },
    }
}) 





tile_fence = Def('tile_fence','adjective') 
tile_house = Def('tile_house','adjective') 

local nopasss = function(target)
    return false
end
tile_house.is_passable = nopasss
tile_fence.is_passable = nopasss


rpg_town_a = Def('rpg_town_a','thing')
rpg_town_a.location = rpg_verse


local map1_town_a = loadmap2(32,32,rpg_town_a,{
    {
        type = {adjective=true},
        path = maps_dir..'town_a_zones.raw',
        makeall = true,
        oneseed = 242538,
        code = {
            ["#53a4ff"] = "river",
            ["#98d91b"] = "grassland",
            ["#3d8114"] = "forest",
            ["#a4a4a4"] = "grassland", --road
            ["#8b5a39"] = "town_tiles:1", 
            ["#e06410"] = "town_tiles:2", 
            ["#603010"] = "town_tiles:3", 
            ["#a78269"] = "town_tiles:4", 
            ["#d9a989"] = "town_tiles:5", 
            ["#e69a66"] = "town_tiles:6", 
            ["#916a4f"] = "town_tiles:7", 
            ["#734627"] = "town_tiles:8", 
        },
    },
    {
        type = {adjective=true,tilecolor=true},
        path = maps_dir..'town_a.raw',
        code = {
            ["#53a4ff"] = "tile_water",
            ["#98d91b"] = "tile_grass",
            ["#3d8114"] = "tile_tree",
            ["#a4a4a4"] = "tile_road",
            ["#421d03"] = "tile_fence",
            ["#8b5a39"] = "tile_house",
            ["#c68355"] = "tile_house_entrance",
        },
    },
}) 

maplink("inset", map0,{84+1,124+1},map1_town_a)

local somerandomtile = map0:tile(80,120)

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