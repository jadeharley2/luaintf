

biome_town = Def('town',{name='town'},'biome')
biome_town.tilecolor = "#f3a387"
biome_town.has_road = true
biome_town.needs_costs_water = 0 
biome_town.needs_costs_food = 0
biome_town.needs_gains_food = 50
biome_town.needs_gains_water = 50
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


biome_town_tiles = Def('town_tiles',{name='town'},'biome')
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