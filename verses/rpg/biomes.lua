





biome = Def('biome',{},"adjective")



biome_forest = Def('forest',{name='forest'},'biome')
biome_forest_deep = Def('forest_deep',{name='deep forest'},'biome')
biome_forest_river = Def('forest_river',{name='forest river'},'biome')
biome_forest_caveentrance = Def('forest_caveentrance',{name='forest cave entrance'},'biome')
biome_grassland = Def('grassland',{name='grassland'},'biome')
biome_lake = Def('lake',{name='lake'},'biome')
biome_river = Def('river',{name='river'},'biome')
biome_sea = Def('sea',{name='open sea'},'biome')
biome_sea_shallow = Def('sea_shallow',{name='shallow sea'},'biome')
biome_swamp = Def('swamp',{name='swamp'},'biome')
biome_beach = Def('beach',{name='beach'},'biome')

biome_steppe = Def('steppe',{name='steppe'},'biome')
biome_desert = Def('desert',{name='sand desert'},'biome')
biome_desert_half = Def('desert_half',{name='half desert'},'biome')
biome_desert_rocky = Def('desert_rocky',{name='rocky desert'},'biome')

biome_highland = Def('highland',{name='highlands'},'biome')
biome_highland_forest = Def('highland_forest',{name='highland forest'},'biome')
biome_highland_river = Def('highland_river',{name='highland river'},'biome')

biome_mountain = Def('mountain',{name='mountains'},'biome')
biome_mountain_forest = Def('mountain_forest',{name='mountain forest'},'biome')
biome_glacier = Def('glacier',{name='glacier'},'biome')

biome_cave = Def('cave',{name='cave'},'biome')



biome_cave.images = {
    "/img/rpg/world/zones/cave0.png",
    "/img/rpg/world/zones/cave1.png",
    "/img/rpg/world/zones/cave2.png",
    "/img/rpg/world/zones/cave3.png",
    "/img/rpg/world/zones/cave4.png",
    "/img/rpg/world/zones/cave5.png",
    "/img/rpg/world/zones/cave6.png",
    "/img/rpg/world/zones/cave7.png",
    "/img/rpg/world/zones/cave8.png",
    "/img/rpg/world/zones/cave9.png",
    "/img/rpg/world/zones/cave10.png",
    "/img/rpg/world/zones/cave11.png",
    "/img/rpg/world/zones/cave12.png",
    "/img/rpg/world/zones/cave13.png",
    "/img/rpg/world/zones/cave14.png",
    "/img/rpg/world/zones/cave15.png",
    "/img/rpg/world/zones/cave16.png",
    "/img/rpg/world/zones/cave17.png",
    "/img/rpg/world/zones/cave18.png",
    "/img/rpg/world/zones/cave19.png",
    "/img/rpg/world/zones/cave20.png",
    "/img/rpg/world/zones/cave21.png",
    "/img/rpg/world/zones/cave22.png",
    "/img/rpg/world/zones/cave23.png",
    "/img/rpg/world/zones/cave24.png",
    "/img/rpg/world/zones/cave25.png",
    "/img/rpg/world/zones/cave26.png",
    "/img/rpg/world/zones/cave27.png",
    "/img/rpg/world/zones/cave28.png", 
}

biome_steppe.images = {
    "/img/rpg/world/zones/steppe0.png",
    "/img/rpg/world/zones/steppe1.png",
    "/img/rpg/world/zones/steppe2.png",
    "/img/rpg/world/zones/steppe3.png",
    "/img/rpg/world/zones/steppe4.png",
    "/img/rpg/world/zones/steppe5.png",
    "/img/rpg/world/zones/steppe6.png",
    "/img/rpg/world/zones/steppe7.png",
    "/img/rpg/world/zones/steppe8.png",
    "/img/rpg/world/zones/steppe9.png",
    "/img/rpg/world/zones/steppe10.png",
    "/img/rpg/world/zones/steppe11.png",
    "/img/rpg/world/zones/steppe12.png",
    "/img/rpg/world/zones/steppe13.png",
    "/img/rpg/world/zones/steppe14.png",
    "/img/rpg/world/zones/steppe15.png",
    "/img/rpg/world/zones/steppe16.png",
    "/img/rpg/world/zones/steppe17.png",
    "/img/rpg/world/zones/steppe18.png",
    "/img/rpg/world/zones/steppe19.png",
}
biome_steppe.withroad = {
    "/img/rpg/world/zones/steppe_road0.png",
    "/img/rpg/world/zones/steppe_road1.png",
    "/img/rpg/world/zones/steppe_road2.png",
    "/img/rpg/world/zones/steppe_road3.png",
    "/img/rpg/world/zones/steppe_road4.png",
}


biome_desert.images = {
    "/img/rpg/world/zones/desert_dunes0.png",
    "/img/rpg/world/zones/desert_dunes1.png",
    "/img/rpg/world/zones/desert_dunes2.png",
    "/img/rpg/world/zones/desert_dunes3.png",
    "/img/rpg/world/zones/desert_dunes4.png",
    "/img/rpg/world/zones/desert_dunes5.png",
    "/img/rpg/world/zones/desert_dunes6.png",
    "/img/rpg/world/zones/desert_dunes7.png",
    "/img/rpg/world/zones/desert_dunes8.png",
    "/img/rpg/world/zones/desert_dunes9.png",
    "/img/rpg/world/zones/desert_dunes10.png",
    "/img/rpg/world/zones/desert_dunes11.png",
    "/img/rpg/world/zones/desert_dunes12.png",
    "/img/rpg/world/zones/desert_dunes13.png",
    "/img/rpg/world/zones/desert_dunes14.png",
    "/img/rpg/world/zones/desert_dunes15.png",
    "/img/rpg/world/zones/desert_dunes16.png",
    "/img/rpg/world/zones/desert_dunes17.png",
    "/img/rpg/world/zones/desert_dunes18.png",
    "/img/rpg/world/zones/desert_dunes19.png",
    "/img/rpg/world/zones/desert_dunes20.png",
    "/img/rpg/world/zones/desert_dunes21.png",
    "/img/rpg/world/zones/desert_dunes22.png",
    "/img/rpg/world/zones/desert_dunes23.png",
    "/img/rpg/world/zones/desert_dunes24.png", 
} 
biome_desert.nearcoast = {
    "/img/rpg/world/zones/desert_dunes_coast0.png",
    "/img/rpg/world/zones/desert_dunes_coast1.png",
    "/img/rpg/world/zones/desert_dunes_coast2.png",
    "/img/rpg/world/zones/desert_dunes_coast3.png",
    "/img/rpg/world/zones/desert_dunes_coast4.png",
    "/img/rpg/world/zones/desert_dunes_coast5.png", 
}
biome_desert_half.images = {
    "/img/rpg/world/zones/desert_plants0.png",
    "/img/rpg/world/zones/desert_plants1.png",
    "/img/rpg/world/zones/desert_plants2.png",
    "/img/rpg/world/zones/desert_plants3.png",
    "/img/rpg/world/zones/desert_plants4.png",
    "/img/rpg/world/zones/desert_plants5.png", 
    "/img/rpg/world/zones/desert_plants6.png", 
    "/img/rpg/world/zones/desert_plants7.png", 
}
biome_desert_half.nearcoast = {
    "/img/rpg/world/zones/desert_plants_coast0.png",
    "/img/rpg/world/zones/desert_plants_coast1.png",
    "/img/rpg/world/zones/desert_plants_coast2.png",
    "/img/rpg/world/zones/desert_plants_coast3.png",
    "/img/rpg/world/zones/desert_plants_coast4.png", 
}
biome_desert_rocky.images = {
    "/img/rpg/world/zones/desert_rocks0.png",
    "/img/rpg/world/zones/desert_rocks1.png",
    "/img/rpg/world/zones/desert_rocks2.png",
    "/img/rpg/world/zones/desert_rocks3.png",
    "/img/rpg/world/zones/desert_rocks4.png", 
    "/img/rpg/world/zones/desert_rocks5.png",
    "/img/rpg/world/zones/desert_rocks6.png",
    "/img/rpg/world/zones/desert_rocks7.png",
    "/img/rpg/world/zones/desert_rocks8.png",
    "/img/rpg/world/zones/desert_rocks9.png",
    "/img/rpg/world/zones/desert_rocks10.png",
    "/img/rpg/world/zones/desert_rocks11.png",
    "/img/rpg/world/zones/desert_rocks12.png",
    "/img/rpg/world/zones/desert_rocks13.png",
    "/img/rpg/world/zones/desert_rocks14.png",
    "/img/rpg/world/zones/desert_rocks15.png",
    "/img/rpg/world/zones/desert_rocks16.png",
    "/img/rpg/world/zones/desert_rocks17.png",
    "/img/rpg/world/zones/desert_rocks18.png",
    "/img/rpg/world/zones/desert_rocks19.png",
    "/img/rpg/world/zones/desert_rocks20.png",
    "/img/rpg/world/zones/desert_rocks21.png",
    "/img/rpg/world/zones/desert_rocks22.png",
    "/img/rpg/world/zones/desert_rocks23.png",
    "/img/rpg/world/zones/desert_rocks24.png", 
    "/img/rpg/world/zones/desert_rocks25.png",
    "/img/rpg/world/zones/desert_rocks26.png",
    "/img/rpg/world/zones/desert_rocks27.png",
}
biome_desert_rocky.nearcoast = {
    "/img/rpg/world/zones/desert_rocks_coast0.png",
    "/img/rpg/world/zones/desert_rocks_coast1.png",
    "/img/rpg/world/zones/desert_rocks_coast2.png", 
}

biome_town = Def('town',{name='town'},'biome')
biome_town_tiles = Def('town_tiles',{name='town'},'biome')
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
biome_town_tiles.images = biome_town.images


biome_house_room = Def('house_room',{name='house_room'},'biome')
biome_house_corridor = Def('house_corridor',{name='house_corridor'},'biome')
biome_house_entrance = Def('house_entrance',{name='house_entrance'},'biome')

biome_house_room.images = biome_town.images
biome_house_corridor.images = biome_town.images
biome_house_entrance.images = biome_town.images

biome_house_room.tilecolor = "#963c00"
biome_house_corridor.tilecolor = "#8b5a39"
biome_house_entrance.tilecolor = "#c68355"

biome_forest.images = {
    "/img/rpg/world/zones/forest_light0.png",
    "/img/rpg/world/zones/forest.png", 
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
biome_forest_river.images = {
    "/img/rpg/world/zones/river_small_forest.png",  
    "/img/rpg/world/zones/river_small_forest2.png", 
    "/img/rpg/world/zones/river_small_forest3.png", 
    "/img/rpg/world/zones/river_small_forest4.png", 
    "/img/rpg/world/zones/river_small_forest5.png", 
    "/img/rpg/world/zones/river_small_forest6.png", 
    "/img/rpg/world/zones/river_small_forest7.png", 
    "/img/rpg/world/zones/river_small_forest8.png", 
    "/img/rpg/world/zones/river_small_forest9.png", 
    "/img/rpg/world/zones/river_small_forest10.png", 
    "/img/rpg/world/zones/river_small_deepforest.png",  
    "/img/rpg/world/zones/river_small_deepforest2.png", 
    "/img/rpg/world/zones/river_small_deepforest3.png", 
    "/img/rpg/world/zones/river_small_deepforest4.png", 
    "/img/rpg/world/zones/river_small_deepforest5.png", 
    "/img/rpg/world/zones/river_small_deepforest6.png", 
    "/img/rpg/world/zones/river_small_deepforest7.png", 
    "/img/rpg/world/zones/river_small_deepforest8.png", 
    "/img/rpg/world/zones/river_small_deepforest9.png",  
}
biome_forest_caveentrance.images = { 
    "/img/rpg/world/zones/cave_entrance0.png", 
    "/img/rpg/world/zones/cave_entrance1.png", 
    "/img/rpg/world/zones/cave_entrance2.png", 
    "/img/rpg/world/zones/cave_entrance3.png", 
    "/img/rpg/world/zones/cave_entrance4.png", 
    "/img/rpg/world/zones/cave_entrance5.png", 
    "/img/rpg/world/zones/cave_entrance6.png", 
    "/img/rpg/world/zones/cave_entrance7.png", 
    "/img/rpg/world/zones/cave_entrance8.png", 
    "/img/rpg/world/zones/cave_entrance9.png", 
    "/img/rpg/world/zones/cave_entrance10.png", 
    "/img/rpg/world/zones/cave_entrance11.png", 
    "/img/rpg/world/zones/cave_entrance12.png", 
    "/img/rpg/world/zones/cave_entrance13.png", 
    "/img/rpg/world/zones/cave_entrance14.png", 
    "/img/rpg/world/zones/cave_entrance15.png", 
    "/img/rpg/world/zones/cave_entrance16.png", 
    "/img/rpg/world/zones/cave_entrance17.png", 
    "/img/rpg/world/zones/cave_entrance18.png", 
    "/img/rpg/world/zones/cave_entrance19.png", 
    "/img/rpg/world/zones/cave_entrance20.png", 
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
biome_highland_forest.images = {
    "/img/rpg/world/zones/highland_forest.png", 
    "/img/rpg/world/zones/highland_forest2.png", 
    "/img/rpg/world/zones/highland_forest3.png", 
    "/img/rpg/world/zones/highland_forest4.png",  
}
biome_highland_forest.nearcoast = biome_highland_forest.nearcoast
biome_highland_river.images = {
    "/img/rpg/world/zones/highland_river.png", 
    "/img/rpg/world/zones/highland_river2.png", 
    "/img/rpg/world/zones/highland_river3.png", 
}

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
biome_mountain.images = {
    "/img/rpg/world/zones/mountain.png", 
    "/img/rpg/world/zones/mountain2.png", 
    "/img/rpg/world/zones/mountain3.png", 
    "/img/rpg/world/zones/mountain4.png", 
    "/img/rpg/world/zones/mountain5.png",  
    "/img/rpg/world/zones/mountain6.png",   
}
biome_mountain_forest.images = {
    "/img/rpg/world/zones/mountain_forest.png", 
    "/img/rpg/world/zones/mountain_forest2.png", 
    "/img/rpg/world/zones/mountain_forest3.png", 
    "/img/rpg/world/zones/mountain_forest4.png", 
    "/img/rpg/world/zones/mountain_forest5.png",  
    "/img/rpg/world/zones/mountain_forest6.png",   
    "/img/rpg/world/zones/mountain_forest7.png",   
}
biome_glacier.images = {
    "/img/rpg/world/zones/mountain_glacier.png", 
    "/img/rpg/world/zones/mountain_glacier2.png", 
    "/img/rpg/world/zones/mountain_glacier3.png", 
    "/img/rpg/world/zones/mountain_glacier4.png", 
    "/img/rpg/world/zones/mountain_glacier5.png",  
    "/img/rpg/world/zones/mountain_glacier6.png",   
}

biome_grassland.tilecolor = "#98d91b"
biome_forest.tilecolor = "#3d8114"
biome_forest_deep.tilecolor = "#316a0f"
biome_forest_river.tilecolor = "#34a98f"
biome_forest_caveentrance.tilecolor = "#829361"
biome_swamp.tilecolor = "#2e675a" 

biome_sea.tilecolor = "#1d5187"
biome_sea_shallow.tilecolor = "#2980ad"
biome_beach.tilecolor = "#e7dba0"

biome_river.tilecolor = "#53a4ff"

biome_town.tilecolor = "#f3a387"

biome_steppe.tilecolor = "#bcd240"
biome_desert_half.tilecolor = "#ced68b"
biome_desert.tilecolor = "#e2c437"
biome_desert_rocky.tilecolor = "#c58840"

biome_highland.tilecolor = "#b0aa90"
biome_highland_forest.tilecolor = "#9cb090"
biome_highland_river.tilecolor = "#83b5c3"

biome_mountain.tilecolor = "#e5e5e5"
biome_mountain_forest.tilecolor = "#ddf3c7"
biome_glacier.tilecolor = "#add8e4"
biome_cave.tilecolor = "#9e9e9e"
 

function biome_sea:is_passable(target)
    local species = target:adj_get('species')
    if species then
        if not species:is('aquatic') or not species:is('avian') then
            printout("you can't swim there")
            return false
        end
    end
end



biome_grassland.population = {
    ["female deer"] = 0.0001,
    ["male deer"] = 0.0001, 
    ["female white sheep"] = 0.001,
    ["male white sheep"] = 0.001, 
    ["female black sheep"] = 0.0002,
    ["male black sheep"] = 0.0002, 
    ["female brown wolf"] = 0.0004,
    ["male brown wolf"] = 0.05,

    ["ruby"] = 0.001,
    ["emerald"] = 0.001,
    ["sapphire"] = 0.001,
    ["topaz"] = 0.0005,
    ["diamond"] = 0.0002,
}
biome_forest.population = {
    ["female deer"] = 0.01,
    ["male deer"] = 0.01,
    ["female gray wolf"] = 0.004,
    ["male gray wolf"] = 0.005,
    ["female brown wolf"] = 0.0004,
    ["male brown wolf"] = 0.0005,

    
    ["ruby"] = 0.001,
    ["emerald"] = 0.001,
    ["sapphire"] = 0.001,
    ["topaz"] = 0.0005,
    ["diamond"] = 0.0002,
}
biome_forest_deep.population = {
    ["female deer"] = 0.01,
    ["male deer"] = 0.01,
    ["female gray wolf"] = 0.006,
    ["male gray wolf"] = 0.007,
    ["female brown wolf"] = 0.0007,
    ["male brown wolf"] = 0.0007,

    
    ["ruby"] = 0.003,
    ["emerald"] = 0.003,
    ["sapphire"] = 0.003,
    ["topaz"] = 0.003,
    ["diamond"] = 0.001,
    ["ec_flask_woods"] = 0.1,
}
biome_town.population = {
    ["female brown kobold person"] = 0.9,
    ["female brown kobold person "] = 0.9,
    ["male brown kobold person"] = 0.9,
    ["male brown kobold person "] = 0.9,
    ["female green kobold person"] = 0.9,
    ["female green kobold person "] = 0.9,
    ["male green kobold person"] = 0.9,
    ["male green kobold person "] = 0.9,
}