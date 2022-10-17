
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
    self.image = table.random(biome.images) 
end

function loadmap(path,w,h,biomelist,location) 
    local pfile = io.open(path, 'rb') 
    local data = pfile:read('*a')
    io.close(pfile)
 
    local b = string.byte
    local function getpixel(x,y)
        local p = (x+y*w)*3+1
        return {b(data,p),b(data,p+1),b(data,p+2)}
    end
    local function getbinpixel(x,y)
        local p = (x+y*w)*3+1
        return data:sub(p,p+2)
    end
    
    print('loaded map file')
    
    local grid = {}
    for y=1,h do 
        for x=1,w do
            local bincolor = getbinpixel(x,y)
            local biome = biomelist[bincolor]
            if biome then 
                local zone = Inst('maptile')
                zone.location = location
                zone:adj_set(biome)
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