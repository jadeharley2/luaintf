





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
biome_sea_shallow = Def('sea_shallow',{},'biome')
biome_swamp = Def('swamp',{},'biome')
biome_beach = Def('beach',{},'biome')

biome_town = Def('town',{},'biome')
biome_town.has_road = true
biome_town.images = {
    "/img/rpg/world/zones/town1.png",
    "/img/rpg/world/zones/town2.png",
    "/img/rpg/world/zones/town3.png",
    "/img/rpg/world/zones/town4.png",
    "/img/rpg/world/zones/town5.png",
    "/img/rpg/world/zones/town6.png",
    "/img/rpg/world/zones/town7.png",
    "/img/rpg/world/zones/town8.png",
    "/img/rpg/world/zones/town9.png",
    "/img/rpg/world/zones/town10.png", 
}

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
biome_forest.nearcoast = {
    "/img/rpg/world/zones/coast_forest.png", 
    "/img/rpg/world/zones/coast_forest2.png", 
    "/img/rpg/world/zones/coast_forest3.png", 
    "/img/rpg/world/zones/coast_forest4.png", 
    "/img/rpg/world/zones/coast_forest5.png", 
    "/img/rpg/world/zones/coast_forest6.png", 
    "/img/rpg/world/zones/coast_forest7.png", 
}
biome_forest.withroad = {
    "/img/rpg/world/zones/forest_road0.png", 
    "/img/rpg/world/zones/forest_road1.png", 
    "/img/rpg/world/zones/forest_road2.png", 
    "/img/rpg/world/zones/forest_road3.png", 
    "/img/rpg/world/zones/forest_road4.png", 
    "/img/rpg/world/zones/forest_road5.png", 
    "/img/rpg/world/zones/forest_road6.png", 
    "/img/rpg/world/zones/forest_road7.png", 
    "/img/rpg/world/zones/forest_road8.png", 
    "/img/rpg/world/zones/forest_road9.png", 
    "/img/rpg/world/zones/forest_road10.png", 
    "/img/rpg/world/zones/forest_road11.png", 
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
biome_forest_deep.nearcoast = biome_forest.nearcoast
biome_forest_deep.withroad = biome_forest.withroad

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
biome_grassland.nearcoast = {
    "/img/rpg/world/zones/coast0.png", 
    "/img/rpg/world/zones/coast1.png", 
    "/img/rpg/world/zones/coast2.png", 
    "/img/rpg/world/zones/coast3.png", 
    "/img/rpg/world/zones/coast4.png", 
    "/img/rpg/world/zones/coast5.png", 
    "/img/rpg/world/zones/coast6.png", 
    "/img/rpg/world/zones/coast7.png", 
    "/img/rpg/world/zones/coast8.png", 
    "/img/rpg/world/zones/coast9.png", 
    "/img/rpg/world/zones/coast10.png", 
    "/img/rpg/world/zones/coast11.png", 
    "/img/rpg/world/zones/coast12.png", 
    "/img/rpg/world/zones/coast13.png", 
    "/img/rpg/world/zones/coast14.png", 
    "/img/rpg/world/zones/coast15.png", 
    "/img/rpg/world/zones/coast16.png", 
    "/img/rpg/world/zones/coast17.png", 
    "/img/rpg/world/zones/coast18.png", 
    "/img/rpg/world/zones/coast19.png", 
    "/img/rpg/world/zones/coast20.png", 
    "/img/rpg/world/zones/coast21.png", 
    "/img/rpg/world/zones/coast22.png", 
    "/img/rpg/world/zones/coast23.png", 
    "/img/rpg/world/zones/coast24.png", 
    "/img/rpg/world/zones/coast25.png", 
    "/img/rpg/world/zones/coast26.png", 
    "/img/rpg/world/zones/coast27.png", 
    "/img/rpg/world/zones/coast28.png", 
}
biome_grassland.withroad = {
    "/img/rpg/world/zones/grassland_road0.png", 
    "/img/rpg/world/zones/grassland_road1.png", 
    "/img/rpg/world/zones/grassland_road2.png", 
    "/img/rpg/world/zones/grassland_road3.png", 
    "/img/rpg/world/zones/grassland_road4.png", 
    "/img/rpg/world/zones/grassland_road5.png", 
    "/img/rpg/world/zones/grassland_road6.png", 
    "/img/rpg/world/zones/grassland_road7.png", 
    "/img/rpg/world/zones/grassland_road8.png", 
    "/img/rpg/world/zones/grassland_road9.png", 
    "/img/rpg/world/zones/grassland_road10.png", 
}

biome_highland.images = {
    "/img/rpg/world/zones/highland1.png", 
    "/img/rpg/world/zones/highland2.png", 
    "/img/rpg/world/zones/highland3.png", 
    "/img/rpg/world/zones/highland4.png", 
    "/img/rpg/world/zones/highland5.png", 
    "/img/rpg/world/zones/highland6.png", 
}
biome_highland.nearcoast = biome_grassland.nearcoast

biome_river.images = {
    "/img/rpg/world/zones/river_med.png", 
    "/img/rpg/world/zones/river_med2.png", 
    "/img/rpg/world/zones/river_med3.png", 
    "/img/rpg/world/zones/river_med4.png",  
}
biome_river.nearcoast = biome_grassland.nearcoast
biome_sea.images = {
    "/img/rpg/world/zones/ocean.png", 
    "/img/rpg/world/zones/ocean2.png", 
    "/img/rpg/world/zones/ocean3.png", 
    "/img/rpg/world/zones/ocean4.png", 
    "/img/rpg/world/zones/ocean5.png",  
}
biome_sea_shallow.images = biome_sea.images 
biome_beach.images = { 
    "/img/rpg/world/zones/coast14.png",  
    "/img/rpg/world/zones/coast20.png",  
    "/img/rpg/world/zones/coast22.png", 
    "/img/rpg/world/zones/coast23.png", 
    "/img/rpg/world/zones/coast_forest2.png", 
    "/img/rpg/world/zones/coast7.png", 
    "/img/rpg/world/zones/coast10.png",   
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
biome_grassland.tilecolor = "#98d91b"
biome_forest.tilecolor = "#3d8114"
biome_forest_deep.tilecolor = "#316a0f"
biome_sea.tilecolor = "#1d5187"
biome_sea_shallow.tilecolor = "#2980ad"
biome_highland.tilecolor = "#b0aa90"
biome_river.tilecolor = "#53a4ff"
biome_swamp.tilecolor = "#2e675a" 
biome_beach.tilecolor = "#e7dba0"
biome_town.tilecolor = "#f3a387"


function biome_sea:is_passable(target)
    local species = target:adj_get('species')
    if species then
        if not species:is('aquatic') or not species:is('avian') then
            printout("you can't swim there")
            return false
        end
    end
end