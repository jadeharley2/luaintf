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
Include('items.lua')
Include('biomes.lua')
Include('map.lua')
Include('combat.lua')

  
 

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
addbiome(biome_forest_caveentrance)
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



local map0 = load_lmap('maps/wmaptest.lua',rpg_verse,{
    {
        type = {adjective=true}, 
        code = biomelist,
    },
    {
        type = {boolean=true}, 
        code = {
            ["#a4a4a4"] = "has_road"
        },
    }
}) 

--[[
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
]]





tile_fence = Def('tile_fence','adjective') 
tile_house = Def('tile_house','adjective') 

local nopasss = function(target)
    return false
end
tile_house.is_passable = nopasss
tile_fence.is_passable = nopasss


rpg_town_a = Def('rpg_town_a','thing')
rpg_town_a.location = rpg_verse

--[[
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
]]


local map1_town_a = load_lmap('maps/town_a.lua',rpg_town_a,{
    {
        type = {adjective=true}, 
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

local roomcodes = {
    code = {
        R = "house_room",
        C = "house_corridor",
        E = "house_entrance",
    }
}
local house =  Def('rpg_town_a_house00','thing')
local house_map = load_tmap([[
 R
RC
 E
]],house,roomcodes)
maplink("in", map1_town_a,{7,14},house_map,{2,3}) 

local house = Def('rpg_town_a_house01','thing')
local house_map = load_tmap([[
R R
CCC
  E
]],house,roomcodes)
maplink("in", map1_town_a,{8,11},house_map,{3,3}) 

local house = Def('rpg_town_a_house02','thing')
local house_map = load_tmap([[
R R
CCC
E  
]],house,roomcodes)
maplink("in", map1_town_a,{10,9},house_map,{1,3}) 

local house = Def('rpg_town_a_house03','thing')
local house_map = load_tmap([[
R R
CCC
R E
]],house,roomcodes)
maplink("in", map1_town_a,{15,8},house_map,{3,3}) 

local house = Def('rpg_town_a_house04','thing')
local house_map = load_tmap([[
 R
RE
]],house,roomcodes)
maplink("in", map1_town_a,{19,7},house_map,{2,2}) 

local house = Def('rpg_town_a_house05','thing')
local house_map = load_tmap([[
CR
C
CR
E
]],house,roomcodes)
maplink("in", map1_town_a,{22,7},house_map,{1,4}) 

local house = Def('rpg_town_a_house06','thing')
local house_map = load_tmap([[
CE
C
CR
R
]],house,roomcodes)
maplink("in", map1_town_a,{21,9},house_map,{2,1}) 

local house = Def('rpg_town_a_house07','thing')
local house_map = load_tmap([[
E
R
]],house,roomcodes)
maplink("in", map1_town_a,{17,10},house_map,{1,1}) 

local house = Def('rpg_town_a_house08','thing')
local house_map = load_tmap([[
R R
CCC
E R
]],house,roomcodes)
maplink("in", map1_town_a,{19,13},house_map,{1,3}) 

local house = Def('rpg_town_a_house09','thing')
local house_map = load_tmap([[
R R
CCC
R E
]],house,roomcodes)
maplink("in", map1_town_a,{20,16},house_map,{3,3}) 

--main hall
local house = Def('rpg_town_a_house10','thing')
local house_map = load_tmap([[
R E R
CCCCC
R C R
  C
 RCR
  R
]],house,roomcodes)
maplink("in", map1_town_a,{19,18},house_map,{3,1}) 


local house = Def('rpg_town_a_house11','thing')
local house_map = load_tmap([[
 E 
 CR
RC 
]],house,roomcodes)
maplink("in", map1_town_a,{18,27},house_map,{2,1}) 

local house = Def('rpg_town_a_house12','thing')
local house_map = load_tmap([[
 E
RC
 C
RC
]],house,roomcodes)
maplink("in", map1_town_a,{15,27},house_map,{2,1}) 

local house = Def('rpg_town_a_house13','thing')
local house_map = load_tmap([[
   R E
RCCCCC
 R R R
]],house,roomcodes)
maplink("in", map1_town_a,{12,27},house_map,{6,1}) 

local house = Def('rpg_town_a_house14','thing')
local house_map = load_tmap([[
 E
RC
 C
RC
]],house,roomcodes)
maplink("in", map1_town_a,{7,25},house_map,{2,1}) 

local house = Def('rpg_town_a_house15','thing')
local house_map = load_tmap([[
RC
 C
RC
 E
]],house,roomcodes)
maplink("in", map1_town_a,{7,23},house_map,{2,4}) 

local house = Def('rpg_town_a_house16','thing')
local house_map = load_tmap([[
 E
RC
 R
]],house,roomcodes)
maplink("in", map1_town_a,{12,22},house_map,{2,1}) 

local house = Def('rpg_town_a_house17','thing')
local house_map = load_tmap([[
ECC
R R
]],house,roomcodes)
maplink("in", map1_town_a,{14,21},house_map,{1,1}) 


local house = Def('rpg_town_a_house18','thing')
local house_map = load_tmap([[
 E
RC
 R
]],house,roomcodes)
maplink("in", map1_town_a,{15,18},house_map,{2,1}) 

local house = Def('rpg_town_a_house19','thing')
local house_map = load_tmap([[
R 
CR
E 
]],house,roomcodes)
maplink("in", map1_town_a,{14,15},house_map,{1,3}) 


local house = Def('rpg_town_a_house20','thing')
local house_map = load_tmap([[
R R
ECC
]],house,roomcodes)
maplink("in", map1_town_a,{14,12},house_map,{1,2}) 

local house = Def('rpg_town_a_house21','thing')
local house_map = load_tmap([[
R R
CCE
]],house,roomcodes)
maplink("in", map1_town_a,{12,12},house_map,{3,2}) 


local house = Def('rpg_town_a_house22','thing')
local house_map = load_tmap([[
R R
RCE
]],house,roomcodes)
maplink("in", map1_town_a,{12,15},house_map,{3,2}) 


local house = Def('rpg_town_a_house23','thing')
local house_map = load_tmap([[
RCE
R R
]],house,roomcodes)
maplink("in", map1_town_a,{12,17},house_map,{3,1}) 


local house = Def('rpg_town_a_house24','thing')
local house_map = load_tmap([[
CCE
R R
]],house,roomcodes)
maplink("in", map1_town_a,{8,18},house_map,{3,1}) 

local house = Def('rpg_town_a_house25','thing')
local house_map = load_tmap([[
RC
 C
RC
 E
]],house,roomcodes)
maplink("in", map1_town_a,{15,25},house_map,{2,4}) 
---

rpg_cave0 = Def('rpg_cave0','thing')
rpg_cave0.location = rpg_verse

local cave0_g = load_lmap('maps/cave0.lua',rpg_cave0,{
    {
        type = {adjective=true},  
        --oneseed = 347242,
        code = {
            ["#2980ad"] = "cave", 
            ["#9e9e9e"] = "cave",  
            ["#98d91b"] = "forest_caveentrance",
        },
    },
    --{
    --    type = {adjective=true,tilecolor=true}, 
    --    code = {
    --        ["#53a4ff"] = "tile_water",
    --        ["#98d91b"] = "tile_grass",
    --        ["#3d8114"] = "tile_tree",
    --        ["#a4a4a4"] = "tile_road",
    --        ["#421d03"] = "tile_fence",
    --        ["#8b5a39"] = "tile_house",
    --        ["#c68355"] = "tile_house_entrance",
    --    },
    --},
}) 
maplink("down", map0,{83,116},cave0_g,{12,28})
maplink("down", map0,{88,112},cave0_g,{29,14})

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