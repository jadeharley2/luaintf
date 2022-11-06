
biome_lake = Def('lake',{name='lake'},'biome')
biome_lake.needs_costs_water = 0 
biome_lake.needs_gains_water = 20

biome_river = Def('river',{name='river'},'biome')
biome_river.tilecolor = "#53a4ff"
biome_river.needs_costs_water = 0 
biome_river.needs_gains_water = 20
biome_river.images = {
    "/img/rpg/world/zones/river_med.png", 
    "/img/rpg/world/zones/river_med2.png", 
    "/img/rpg/world/zones/river_med3.png", 
    "/img/rpg/world/zones/river_med4.png",  
}
biome_river.nearcoast = biome_grassland.nearcoast

biome_swamp = Def('swamp',{name='swamp'},'biome')
biome_swamp.tilecolor = "#2e675a" 
biome_swamp.needs_costs_food = 40
biome_swamp.needs_gains_water = 5
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
