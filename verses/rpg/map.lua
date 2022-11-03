
maptile = Def('maptile',{
    description = '',
},'room')
function maptile:_get_name()
    local biome = self:adj_get('biome')
    return (biome.name or biome.id) .. ' ('..tostring(self.pos.x)..','..tostring(self.pos.y)..')'
end 
--function maptile:_get_image()
--    local biome = self:adj_get('biome')
--    return biome.image
--end
function maptile:on_enter(doer)
    local population = self.population 
    if population then
        for k,v in pairs(self.population) do
            if v>math.random() then
                local p = Inst(string.trim(k))
                p.location = self
                p.is_temporary = true
                printout('spawned '..k)
                p:event_call('found',doer)
            end
        end
    end
end
function maptile:on_exit(doer)
    self:foreach_contains(function(x)
        if x.is_temporary then
            x.location = nil
        end
    end)
end

function maptile:setup()
    local biome = self:adj_get('biome') 


    local nearcoast =false
    self:foreach_adjascent(function(dir,room,prevroom,visited) 
        if room:is('sea_shallow') then
            nearcoast = true
        end 
    end,1)

    local seed = self.seed
    if seed then 
        math.randomseed(seed)
        self.seed = seed
    end
    
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
    return tilemap(grid,w,h)
end



map_meta = map_meta or {}

function map_meta:tile(x,y)
    if type(x)=='table' then
        y = x[2]
        x = x[1] 
    end
    return self.tiles[x+(y-1)*self.w]
end

map_meta.__index = map_meta

function tilemap(tiles,width,height)
    return setmetatable({tiles=tiles,w=width,h=height},map_meta)
end



local function linktiles(grid,w,h)
    
    for y=1,h do
        for x=1,w do
            local pid = x+(y-1)*w
            local zone = grid[pid]
            if zone then
                if x>1 then
                    local left = grid[pid-1]
                    if left then
                        MakeRelation(zone,left,direction_west)
                    end
                end
                if y>1 then 
                    local top = grid[pid-w]
                    if top then
                        MakeRelation(zone,top,direction_north)
                    end
                end
                zone:setup()
            end
        end
    end 
end


local b = string.byte
local function getpixel(data,x,y,w)
    local p = (x+(y-1)*w-1)*3+1
    return {b(data,p),b(data,p+1),b(data,p+2)}
end
local function getbinpixel(data,x,y,w)
    local p = (x+(y-1)*w-1)*3+1
    return data:sub(p,p+2)
end
function loadmap2(w,h,location,layers) 
    local files = {}

    for k,v in ipairs(layers) do
        local pfile = io.open(v.path, 'rb')  
        files[k] = pfile:read('*a')
        io.close(pfile)
        print('loaded layer data',k,v.path)
    end
 
    local oneseed
    local tilecount = 0
    local grid = {}
    location.grid = grid
    location.gridsize = {x=w,y=h}
    for k,v in ipairs(layers) do
        local data = files[k]
        local code = {}
        local codecolor = {}
        local seedoffset = {}
        for k2,v2 in pairs(v.code) do
            if #k2>3 then
                local cr,cg,cb = hex2rgb(k2)
                local bin = string.char(cr).. string.char(cg).. string.char(cb)


                local prt = v2:split(':') 
                if #prt>1 then
                    v2 = prt[1]
                    seedoffset[bin] = tonumber(prt[2])
                end

                code[bin]=v2
                codecolor[bin] = k2
            else
                code[k2]=v2
            end

        end
        local t = v.type
        local is_adj = t.adjective
        local is_bool = t.boolean
        local is_tilecolor = t.tilecolor
        local makeall = v.makeall
        oneseed = v.oneseed or oneseed
        for y=1,h do 
            for x=1,w do
                local bincolor = getbinpixel(data,x,y,w)
                local value = code[bincolor]
                if value or makeall then 
                    local pid = x+(y-1)*w
                    local zone = grid[pid]
                    if not zone then
                        zone = Inst('maptile')
                        grid[pid] = zone
                        zone.location = location
                        zone.pos = {x=x,y=y}
                        zone.seed = (oneseed or pid) + (seedoffset[bincolor] or 0)
                        tilecount = tilecount + 1
                    end

                    if value then 
                        if is_adj then
                            zone:adj_set(value)
                        end
                        if is_bool then
                            zone[value] = true
                        end
                        if is_tilecolor then 
                            zone.tilecolor = codecolor[bincolor]
                        end
                    else
                        local heh=0
                    end
 
                end
            end
        end 
        print('loaded layer',k)
    end
    print(tilecount,'tiles placed')
    if oneseed then
        print('global seed:',oneseed)
    else
        print('using positional seed')
    end
    if tilecount == 0 then
        error("no tiles found on map!")
    end

    linktiles(grid,w,h) 
    print('tiles linked')
    return tilemap(grid,w,h)
end

function load_lmap(path,location,layers) 
    local tempswap = temp
    Include(path,1)
    local tiledata = temp 
    temp = tempswap

    local w = tiledata.w
    local h = tiledata.h 
    local oneseed
    local tilecount = 0
    local grid = {}
    for k,v in ipairs(layers) do
        local data = tiledata.layers[k]

        local indexmap = {} -- [hexcolor = id]
        for k2,v2 in pairs(data.index) do
            indexmap[string.lower(v2)] = k2
        end
        

        local code = {}
        local codecolor = {}
        local seedoffset = {}
        for k2,v2 in pairs(v.code) do
            if #k2>3 then -- hex color key 
                local prt = v2:split(':') 
                if #prt>1 then
                    v2 = prt[1]
                    local cid = indexmap[k2]
                    if not cid then 
                        error(L'unknown zone index color [v2]')
                    end
                    code[cid]=v2
                    seedoffset[cid] = tonumber(prt[2])
                else
                    local cid = indexmap[k2]
                    if not cid then 
                        error(L'unknown zone index color [v2]')
                    end
                    code[cid]= v2
                    codecolor[cid] = k2
                end
            else -- binary color key
                local hex = string.lower(rgb2hex(b(k2,1),b(k2,2),b(k2,3)))
                local cid = indexmap[hex]
                if not cid then 
                    error(L'unknown zone index color [v2]')
                end
                code[cid]=v2
            end
        end



        local t = v.type
        local is_adj = t.adjective
        local is_bool = t.boolean
        local is_tilecolor = t.tilecolor
        local makeall = v.makeall
        oneseed = v.oneseed or oneseed
        for y=1,h do 
            local row = data.data[y]
            local singlevalue = type(row)=='number'
            local value
            local index
            local skip = false
            if singlevalue then
                index = row+1
                value = code[index]
                if not value and not makeall then
                    skip=true
                end
            end
            if not skip then
                for x=1,w do
                    if not singlevalue then
                        index = row[x]+1
                        value = code[index]
                    end

                    if value or makeall then 
                        local pid = x+(y-1)*w
                        local zone = grid[pid]
                        if not zone then
                            zone = Inst('maptile')
                            grid[pid] = zone
                            zone.location = location
                            zone.pos = {x=x,y=y}
                            zone.seed = (oneseed or pid) + (seedoffset[index] or 0)
                            tilecount = tilecount + 1
                        end

                        if value then 
                            if is_adj then
                                zone:adj_set(value)
                            end
                            if is_bool then
                                zone[value] = true
                            end
                            if is_tilecolor then 
                                zone.tilecolor = codecolor[index]
                            end
                        else
                            local heh=0
                        end
    
                    end
                end
            end
        end 
        print('loaded layer',k)
 

    end

    print(tilecount,'tiles placed')
    if oneseed then
        print('global seed:',oneseed)
    else
        print('using positional seed')
    end
    if tilecount == 0 then
        error("no tiles found on map!")
    end
    linktiles(grid,w,h) 
    location.grid = grid
    location.gridsize = {x=w,y=h}
    print('tiles linked')
    return tilemap(grid,w,h)
end
function load_tmap(map,location,layers)

    local idx = layers.code 

    local rows = string.replace(map,'\r',''):split('\n')
    local h = #rows-1
    local w = #(rows[1])
    local grid = {} 


    local oneseed = layers.oneseed
    for y=1,h do
        local row = rows[y]
        for x=1,w do
            local c = row:sub(x,x)
            if c~=' ' then
                local d = idx[c]
                if d then
                    local pid = x+(y-1)*w 
                    
                    zone = Inst('maptile')
                    grid[pid] = zone
                    zone.location = location
                    zone.pos = {x=x,y=y}
                    zone.seed = (oneseed or pid)
                    
                    zone:adj_set(d)
                end
            end
        end
    end
    linktiles(grid,w,h) 
    location.grid = grid
    location.gridsize = {x=w,y=h}
    return tilemap(grid,w,h)
end

function maplink(mode,from,fpos,to,tpos)
    if mode == "inset" then
        local ftile = from:tile(fpos)

        local ajas = ftile:adjascent(true)
        local n = ajas.n
        local s = ajas.s
        local w = ajas.w
        local e = ajas.e
        --local ttile = to:tile(tpos)

        DestroyRelations(ftile,direction)

        local tw = to.w 
        local th = to.h
        local halfw = math.floor(tw/2)
        local halfh = math.floor(th/2)
        local mn = to:tile(math.floor(halfw),1)
        local ms = to:tile(math.floor(halfw),th)
        local mw = to:tile(1,math.floor(halfh))
        local me = to:tile(tw,math.floor(halfh))
        MakeRelation(n,mn,direction_south,true)
        MakeRelation(s,ms,direction_north,true)
        MakeRelation(w,mw,direction_east,true)
        MakeRelation(e,me,direction_west,true)

        for x=1,tw do
            local ttile_top = to:tile(x,1)
            if ttile_top and n then
                MakeRelation(ttile_top,n,direction_north,true)
            end

            local ttile_bot = to:tile(x,th)
            if ttile_bot and s then
                MakeRelation(ttile_bot,s,direction_south,true)
            end
        end
        for y=1,th do
            local ttile_left = to:tile(1,y)
            if ttile_left and w then
                MakeRelation(ttile_left,w,direction_west,true)
            end

            local ttile_right = to:tile(tw,y)
            if ttile_right and e then
                MakeRelation(ttile_right,e,direction_east,true)
            end
        end
        local LOL =0
    elseif mode=="down" then
        local ftile = from:tile(fpos)
        local ttile = to:tile(tpos)
        MakeRelation(ftile,ttile,direction_down)
    elseif mode=="in" then
        local ftile = from:tile(fpos)
        local ttile = to:tile(tpos)
        MakeRelation(ftile,ttile,direction_in)
    end

end