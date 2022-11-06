
biome = Def('biome',{},"adjective")

room.needs_costs_food = 10
room.needs_costs_water = 10 
room.needs_gains_food = 2
room.needs_gains_water = 2

 
Include('biomes/plains.lua')

Include('biomes/cave.lua')
Include('biomes/dark.lua')
Include('biomes/desert.lua')
Include('biomes/forest.lua')
Include('biomes/highland.lua')
Include('biomes/infused.lua')
Include('biomes/inlandwater.lua')
Include('biomes/mountain.lua')
Include('biomes/sea.lua')
Include('biomes/tectonic.lua')
Include('biomes/town.lua') 

 



biome_river.population = { 
    ["female white sheep"]  = 0.001,
    ["male white sheep"]    = 0.001, 
    ["female otter"]        = 0.005,
    ["male otter"]          = 0.005,
    ["female fox"]          = 0.008,
    ["male fox"]            = 0.007,
}
biome_grassland.population = {
    ["female white sheep"]  = 0.001,
    ["male white sheep"]    = 0.001, 
    ["female fox"]          = 0.0007,
    ["male fox"]            = 0.0006,
    ["female brown wolf"]   = 0.0004,
    ["male brown wolf"]     = 0.0005,
    ["female black sheep"]  = 0.0002,
    ["male black sheep"]    = 0.0002, 
    ["female deer"]         = 0.0001,
    ["male deer"]           = 0.0001, 

    ["ruby"]        = 0.001,
    ["emerald"]     = 0.001,
    ["sapphire"]    = 0.001,
    ["diamond"]     = 0.0002,
    ["topaz"]       = 0.0005,
}
biome_forest_river.population = {
    ["female deer"]         = 0.01,
    ["male deer"]           = 0.01,
    ["female squirrel"]     = 0.01,
    ["male squirrel"]       = 0.01,
    ["female otter"]        = 0.005,
    ["male otter"]          = 0.005,
    ["female fox"]          = 0.008,
    ["male fox"]            = 0.007,
    ["female raccoon"]      = 0.004,
    ["male raccoon"]        = 0.003,
    ["female ferret"]       = 0.004,
    ["male ferret"]         = 0.005,
}
biome_swamp.population = {
    ["female otter"]        = 0.005,
    ["male otter"]          = 0.005,
    ["female raccoon"]      = 0.004,
    ["male raccoon"]        = 0.003,
}
biome_forest.population = {
    ["female deer"]         = 0.01,
    ["male deer"]           = 0.01,
    ["female squirrel"]     = 0.01,
    ["male squirrel"]       = 0.01,
    ["female fox"]          = 0.008,
    ["male fox"]            = 0.007,
    ["female raccoon"]      = 0.004,
    ["male raccoon"]        = 0.003,
    ["female ferret"]       = 0.004,
    ["male ferret"]         = 0.005,
    ["female gray wolf"]    = 0.004,
    ["male gray wolf"]      = 0.005,
    ["female brown wolf"]   = 0.0004,
    ["male brown wolf"]     = 0.0005,

    
    ["ruby"]            = 0.001,
    ["emerald"]         = 0.001,
    ["sapphire"]        = 0.001,
    ["topaz"]           = 0.0005,
    ["diamond"]         = 0.0002,
}
biome_forest_deep.population = {
    ["female deer"]         = 0.01,
    ["male deer"]           = 0.01,
    ["female squirrel"]     = 0.01,
    ["male squirrel"]       = 0.01,
    ["female ferret"]       = 0.004,
    ["male ferret"]         = 0.005,
    ["female fox"]          = 0.008,
    ["male fox"]            = 0.007,
    ["female gray wolf"]    = 0.006,
    ["male gray wolf"]      = 0.007,
    ["female skunk"]        = 0.001,
    ["male skunk"]          = 0.001, 
    ["female brown wolf"]   = 0.0007,
    ["male brown wolf"]     = 0.0007, 
    
    ["ruby"]        = 0.003,
    ["emerald"]     = 0.003,
    ["sapphire"]    = 0.003,
    ["topaz"]       = 0.003,
    ["diamond"]     = 0.001,
}
biome_steppe.population = {
    ["female coyote"]       = 0.002, 
    ["male coyote"]         = 0.002, 
    ["female aardwolf"]     = 0.001, 
    ["male aardwolf"]       = 0.001, 
    ["female jackal"]       = 0.001, 
    ["male jackal"]         = 0.001, 
    ["female fennec"]       = 0.0007, 
    ["male fennec"]         = 0.0007, 
}
biome_desert_half.population = { 
    ["female fennec"]     = 0.007, 
    ["male fennec"]     = 0.007, 
}
biome_desert.population = { 
    ["female fennec"]     = 0.002, 
    ["male fennec"]     = 0.002, 
}
biome_desert_rocky.population = { 
    ["female fennec"]     = 0.005, 
    ["male fennec"]     = 0.005, 
    ["female coyote"]     = 0.002, 
    ["male coyote"]     = 0.002, 
    ["female jackal"]       = 0.001, 
    ["male jackal"]         = 0.001, 
}
biome_town.population = {
    ["female brown kobold person"]  = 0.9,
    ["female brown kobold person "] = 0.9,
    ["male brown kobold person"]    = 0.9,
    ["male brown kobold person "]   = 0.9,
    ["female green kobold person"]  = 0.9,
    ["female green kobold person "] = 0.9,
    ["male green kobold person"]    = 0.9,
    ["male green kobold person "]   = 0.9,
}
biome_cave.population = { 
    ["ruby"]        = 0.01,
    ["emerald"]     = 0.01,
    ["sapphire"]    = 0.01,
    ["topaz"]       = 0.005,
    ["diamond"]     = 0.002,
}

 