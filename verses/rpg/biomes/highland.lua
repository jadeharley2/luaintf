
biome_subhighland = Def('subhighland',{name='midlands'},'biome')
biome_subhighland.tilecolor = "#c7ab69"
biome_subhighland.needs_costs_water = 18 
biome_subhighland.needs_costs_food = 15
biome_subhighland.images = {
    "/img/rpg/world/zones/subhighlands1.png", 
    "/img/rpg/world/zones/subhighlands2.png", 
    "/img/rpg/world/zones/subhighlands3.png", 
    "/img/rpg/world/zones/subhighlands4.png", 
    "/img/rpg/world/zones/subhighlands5.png", 
    "/img/rpg/world/zones/subhighlands6.png", 
    "/img/rpg/world/zones/subhighlands7.png", 
    "/img/rpg/world/zones/subhighlands8.png", 
    "/img/rpg/world/zones/subhighlands9.png", 
    "/img/rpg/world/zones/subhighlands10.png", 
    "/img/rpg/world/zones/subhighlands11.png", 
    "/img/rpg/world/zones/subhighlands12.png",  
}
biome_subhighland.withroad = {
    "/img/rpg/world/zones/subhighlands_road1.png", 
    "/img/rpg/world/zones/subhighlands_road2.png", 
    "/img/rpg/world/zones/subhighlands_road3.png", 
    "/img/rpg/world/zones/subhighlands_road4.png", 
    "/img/rpg/world/zones/subhighlands_road5.png", 
    "/img/rpg/world/zones/subhighlands_road6.png", 
}

biome_highland = Def('highland',{name='highlands'},'biome')
biome_highland.tilecolor = "#b0aa90"
biome_highland.needs_costs_water = 25 
biome_highland.needs_costs_food = 20
biome_highland.images = {
    "/img/rpg/world/zones/highland1.png", 
    "/img/rpg/world/zones/highland2.png", 
    "/img/rpg/world/zones/highland3.png", 
    "/img/rpg/world/zones/highland4.png", 
    "/img/rpg/world/zones/highland5.png", 
    "/img/rpg/world/zones/highland6.png", 
}
biome_highland.nearcoast = biome_grassland.nearcoast

biome_highland_forest = Def('highland_forest',{name='highland forest'},'biome')
biome_highland_forest.tilecolor = "#9cb090"
biome_highland_forest.needs_costs_food = 20
biome_highland_forest.images = {
    "/img/rpg/world/zones/highland_forest.png", 
    "/img/rpg/world/zones/highland_forest2.png", 
    "/img/rpg/world/zones/highland_forest3.png", 
    "/img/rpg/world/zones/highland_forest4.png",  
}
biome_highland_forest.nearcoast = biome_highland_forest.nearcoast

biome_highland_river = Def('highland_river',{name='highland river'},'biome')
biome_highland_river.tilecolor = "#83b5c3"
biome_highland_river.needs_costs_water = 0 
biome_highland_river.needs_costs_food = 20
biome_highland_river.needs_gains_water = 20
biome_highland_river.images = {
    "/img/rpg/world/zones/highland_river.png", 
    "/img/rpg/world/zones/highland_river2.png", 
    "/img/rpg/world/zones/highland_river3.png", 
}