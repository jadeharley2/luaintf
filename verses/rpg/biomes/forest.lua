
biome_forest = Def('forest',{name='forest'},'biome')
biome_forest.tilecolor = "#3d8114"
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

biome_forest_deep = Def('forest_deep',{name='deep forest'},'biome')
biome_forest_deep.tilecolor = "#316a0f"
biome_forest_deep.needs_costs_food = 20
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

biome_forest_river = Def('forest_river',{name='forest river'},'biome')
biome_forest_river.tilecolor = "#34a98f"
biome_forest_river.needs_costs_water = 0 
biome_forest_river.needs_gains_water = 20
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

biome_forest_caveentrance = Def('forest_caveentrance',{name='forest cave entrance'},'biome')
biome_forest_caveentrance.tilecolor = "#829361"
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

biome_rainforest = Def('rainforest',{name='jungle'},'biome')
biome_rainforest.tilecolor = "#0c5833" 
biome_rainforest.needs_costs_food = 30
biome_rainforest.needs_costs_water = 20 
biome_rainforest.needs_gains_water = 5
biome_rainforest.images = {
    "/img/rpg/world/zones/rainforest1.png", 
    "/img/rpg/world/zones/rainforest2.png", 
    "/img/rpg/world/zones/rainforest3.png", 
    "/img/rpg/world/zones/rainforest4.png", 
    "/img/rpg/world/zones/rainforest5.png", 
    "/img/rpg/world/zones/rainforest6.png", 
    "/img/rpg/world/zones/rainforest7.png", 
    "/img/rpg/world/zones/rainforest8.png", 
    "/img/rpg/world/zones/rainforest9.png", 
    "/img/rpg/world/zones/rainforest10.png", 
    "/img/rpg/world/zones/rainforest11.png", 
    "/img/rpg/world/zones/rainforest12.png", 
    "/img/rpg/world/zones/rainforest13.png",  
}

biome_rainforest_stream = Def('rainforest_stream',{name='jungle stream'},'biome')
--biome_rainforest_stream.tilecolor = "#000000"
biome_rainforest_stream.needs_costs_food = 30
biome_rainforest_stream.needs_costs_water = 15 
biome_rainforest_stream.needs_gains_water = 20
biome_rainforest_stream.images = {
    "/img/rpg/world/zones/rainforest_stream1.png", 
    "/img/rpg/world/zones/rainforest_stream2.png", 
    "/img/rpg/world/zones/rainforest_stream3.png", 
    "/img/rpg/world/zones/rainforest_stream4.png", 
    "/img/rpg/world/zones/rainforest_stream5.png", 
    "/img/rpg/world/zones/rainforest_stream6.png", 
    "/img/rpg/world/zones/rainforest_stream7.png", 
    "/img/rpg/world/zones/rainforest_stream8.png", 
    "/img/rpg/world/zones/rainforest_stream9.png",  
}