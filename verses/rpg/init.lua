rpg_verse = Def('rpg_verse',{name="FRPG"},'universe')



Include('map.lua')





species = Def('species','adjective')


anthro = Def('anthro','adjective')

canine = Def('canine','anthro species')
feline = Def('feline','anthro species')
naga = Def('naga','anthro species')
naga.species_images = {
    black = {
        female = "/img/rpg/species/anthros/naga_black_f.png",
        _ = "/img/rpg/species/anthros/naga_black_m.png",
    },
    green = {
        female = "/img/rpg/species/anthros/naga_green_f.png",
        _ = "/img/rpg/species/anthros/naga_green_m.png",
    },
    blue = {
        female = "/img/rpg/species/anthros/naga_blue_f.png",
        _ = "/img/rpg/species/anthros/naga_blue_m.png",
    },
    purple = { 
        female = "/img/rpg/species/anthros/naga_purple_f.png",
        _ = "/img/rpg/species/anthros/naga_purple_m.png",
    },
    black = { 
        female = "/img/rpg/species/anthros/naga_black_f.png",
        _ = "/img/rpg/species/anthros/naga_black_m.png",
    },
    gold = { 
        female = "/img/rpg/species/anthros/naga_gold_f.png",
        _ = "/img/rpg/species/anthros/naga_gold_m.png",
    },
    silver = { 
        female = "/img/rpg/species/anthros/naga_silver_f.png",
        _ = "/img/rpg/species/anthros/naga_silver_m.png",
    },
    _ = {--red
        female = "/img/rpg/species/anthros/naga_red_f.png",
        _ = "/img/rpg/species/anthros/naga_red_m.png",
    }
}

local function adj_choice_tree(self, tree)
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

function naga:_get_image()
    return adj_choice_tree(self,self.species_images)
end





testnaga = Def('testnaga',{},"female green naga person")










biome = Def('biome',{},"adjective")


biome_forest = Def('forest',{},'biome')
biome_forest_deep = Def('deep_forest',{},'biome')
biome_grassland = Def('grassland',{},'biome')
biome_desert = Def('desert',{},'biome')
biome_highland = Def('highland',{},'biome')
biome_mountains = Def('mountains',{},'biome')
biome_lake = Def('river',{},'biome')
biome_river = Def('river',{},'biome')
biome_sea = Def('sea',{},'biome')
biome_swamp = Def('swamp',{},'biome')

biome_forest.images = {
    "/img/rpg/world/zones/forest_light0.png",
    "/img/rpg/world/zones/forest.png",
    "/img/rpg/world/zones/forest1.png",
    "/img/rpg/world/zones/forest2.png",
    "/img/rpg/world/zones/forest3.png",
    "/img/rpg/world/zones/forest4.png",
    "/img/rpg/world/zones/forest5.png",
    "/img/rpg/world/zones/forest6.png",
    "/img/rpg/world/zones/forest7.png",
}
biome_forest_deep.images = {
    "/img/rpg/world/zones/forest_deep.png",
    "/img/rpg/world/zones/forest_deep2.png",
    "/img/rpg/world/zones/forest_deep3.png",
    "/img/rpg/world/zones/forest_deep4.png",
    "/img/rpg/world/zones/forest_deep5.png",
    "/img/rpg/world/zones/forest_deep6.png",
    "/img/rpg/world/zones/forest_deep7.png",
    "/img/rpg/world/zones/forest_deep8.png",
    "/img/rpg/world/zones/forest_deep9.png",
    "/img/rpg/world/zones/forest_deep10.png",
    "/img/rpg/world/zones/forest_deep11.png",
    "/img/rpg/world/zones/forest_deep12.png",
    "/img/rpg/world/zones/forest_deep13.png",
    "/img/rpg/world/zones/forest_deep14.png",
    "/img/rpg/world/zones/forest_deep15.png", 
}
biome_grassland.images = {
    "/img/rpg/world/zones/grassland_plains.png",
    "/img/rpg/world/zones/grassland_plains2.png",
    "/img/rpg/world/zones/grassland_plains3.png",
    "/img/rpg/world/zones/grassland_plains4.png",
    "/img/rpg/world/zones/grassland_plains5.png",
    "/img/rpg/world/zones/grassland_plains6.png",
    "/img/rpg/world/zones/grassland_hills.png",
    "/img/rpg/world/zones/grassland_hills2.png",
    "/img/rpg/world/zones/grassland_hills3.png",
    "/img/rpg/world/zones/grassland_hills4.png",
    "/img/rpg/world/zones/grassland_hills5.png",
    "/img/rpg/world/zones/grassland_hills6.png",
    "/img/rpg/world/zones/grassland_hills7.png",
}
biome_highland.images = {
    "/img/rpg/world/zones/highland1.png", 
    "/img/rpg/world/zones/highland2.png", 
    "/img/rpg/world/zones/highland3.png", 
    "/img/rpg/world/zones/highland4.png", 
    "/img/rpg/world/zones/highland5.png", 
    "/img/rpg/world/zones/highland6.png", 
}
biome_river.images = {
    "/img/rpg/world/zones/river_med.png", 
    "/img/rpg/world/zones/river_med2.png", 
    "/img/rpg/world/zones/river_med3.png", 
    "/img/rpg/world/zones/river_med4.png",  
}
biome_sea.images = {
    "/img/rpg/world/zones/ocean.png", 
    "/img/rpg/world/zones/ocean2.png", 
    "/img/rpg/world/zones/ocean3.png", 
    "/img/rpg/world/zones/ocean4.png", 
    "/img/rpg/world/zones/ocean5.png",  
}
biome_swamp.images = {
    "/img/rpg/world/zones/swamp.png", 
    "/img/rpg/world/zones/swamp2.png", 
    "/img/rpg/world/zones/swamp3.png", 
    "/img/rpg/world/zones/swamp4.png", 
    "/img/rpg/world/zones/swamp5.png",  
    "/img/rpg/world/zones/swamp6.png",  
    "/img/rpg/world/zones/swamp7.png",  
    "/img/rpg/world/zones/swamp8.png",  
    "/img/rpg/world/zones/swamp9.png",  
    "/img/rpg/world/zones/swamp10.png",  
    "/img/rpg/world/zones/swamp11.png",   
}
--test

biomelist = {}
local sbc = string.char
local function addbiome(color,biome)
    local r,g,b = hex2rgb(color)
    local binary = sbc(r)..sbc(g)..sbc(b)
    biomelist[binary] = biome.id
end

addbiome("98d91b",biome_grassland)
addbiome("3d8114",biome_forest)
addbiome("316a0f",biome_forest_deep)
addbiome("1d5187",biome_sea)
addbiome("b0aa90",biome_highland)
addbiome("53a4ff",biome_river)
addbiome("2e675a",biome_swamp)

local path = "C:/_root/projects/src/TileServer/WebRelay/bin/Debug/data/img/rpg/world/wmaptest.raw"
local map0 = loadmap(path,256,512,biomelist,rpg_verse) 

local somerandomtile = map0[69+109*256]

testnaga.location = somerandomtile
local fir=0