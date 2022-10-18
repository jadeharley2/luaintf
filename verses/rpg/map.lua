
maptile = Def('maptile',{},'room')
function maptile:_get_name()
    local biome = self:adj_get('biome')
    return biome.id
end
--function maptile:_get_image()
--    local biome = self:adj_get('biome')
--    return biome.image
--end

function maptile:setup()
    local biome = self:adj_get('biome')


    local nearcoast =false
    self:foreach_adjascent(function(dir,room,prevroom,visited) 
        if room:is('sea_shallow') then
            nearcoast = true
        end 
    end,1)
    if nearcoast then
        self.image = table.random(biome.nearcoast or biome.images) 
    elseif self.has_road then
        self.image = table.random(biome.withroad or biome.images) 
    else
        self.image = table.random(biome.images) 
    end
end

function loadmap(path,roadlayer,w,h,biomelist,location) 

    local pfile = io.open(path, 'rb') 
    local data = pfile:read('*a')
    io.close(pfile)

    print('loaded zone file')

    local pfile = io.open(roadlayer, 'rb') 
    local data2 = pfile:read('*a')
    io.close(pfile)
 
    print('loaded road file')

    local b = string.byte
    local function getpixel(data,x,y)
        local p = (x+y*w)*3+1
        return {b(data,p),b(data,p+1),b(data,p+2)}
    end
    local function getbinpixel(data,x,y)
        local p = (x+y*w)*3+1
        return data:sub(p,p+2)
    end
    
    
    local grid = {}
    location.grid = grid
    location.gridsize = {x=w,y=h}
    for y=1,h do 
        for x=1,w do
            local bincolor = getbinpixel(data,x,y)
            local biome = biomelist[bincolor]
            if biome then 
                local roadcolor = getbinpixel(data2,x,y)
                local zone = Inst('maptile')
                zone.location = location
                zone.pos = {x=x,y=y}
                zone:adj_set(biome)
                if roadcolor~='\0\0\0' then
                    zone.has_road = true
                end
                grid[x+y*w] = zone
            end
        end
    end 
    print('loaded tiles')
    for y=1,h do
        for x=1,w do
            local zone = grid[x+y*w]
            if zone then
                if x>1 and y>1 then
                    local left = grid[x-1+y*w]
                    if left then
                        MakeRelation(zone,left,direction_west)
                    end
                    local top = grid[x+(y-1)*w]
                    if top then
                        MakeRelation(zone,top,direction_north)
                    end
                end
                zone:setup()
            end
        end
    end 
    print('tiles linked')
    return grid
end