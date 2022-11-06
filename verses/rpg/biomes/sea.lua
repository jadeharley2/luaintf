
biome_sea = Def('sea',{name='open sea'},'biome')
biome_sea.tilecolor = "#1d5187"
biome_sea.needs_costs_food = 40
biome_sea.needs_costs_water = 20 
biome_sea.needs_gains_water = 0
biome_sea.images = {
    "/img/rpg/world/zones/ocean.png", 
    "/img/rpg/world/zones/ocean2.png", 
    "/img/rpg/world/zones/ocean3.png", 
    "/img/rpg/world/zones/ocean4.png", 
    "/img/rpg/world/zones/ocean5.png",  
}

biome_sea_shallow = Def('sea_shallow',{name='shallow sea'},'biome')
biome_sea_shallow.tilecolor = "#2980ad"
biome_sea_shallow.needs_costs_food = 40
biome_sea_shallow.needs_costs_water = 20 
biome_sea_shallow.needs_gains_water = 0
biome_sea_shallow.images = biome_sea.images 


function biome_sea:is_passable(target)
    local species = target:adj_get('species')
    if species then
        if not species:is('aquatic') or not species:is('avian') then
            printout("you can't swim there")
            return false
        end
    end
end

biome_beach = Def('beach',{name='beach'},'biome')
biome_beach.tilecolor = "#e7dba0"
biome_beach.images = { 
    "/img/rpg/world/zones/coast14.png",  
    "/img/rpg/world/zones/coast20.png",  
    "/img/rpg/world/zones/coast22.png", 
    "/img/rpg/world/zones/coast23.png", 
    "/img/rpg/world/zones/coast_forest2.png", 
    "/img/rpg/world/zones/coast7.png", 
    "/img/rpg/world/zones/coast10.png",   
}

