
thing.image = '/img/items/generic.png'

function css_table_string(t)
    local s = {} 
    for k,v in pairs(t) do
         
        if type(v)=='string' then
            if string.sub(v,1,1)=='#' then --hexcolor
                s[#s+1] = k..': '..v
            else
                s[#s+1] = k..': '..tostring(v)
            end
        else
            s[#s+1] = k..': '..tostring(v)
        end
    end
    return table.concat(s,'; ')
end

thing.view_style = { 
    bg1 =  '#000000',

    bg2d = '#000000',
    bg2l = '#3b3b3b',

    bg3d = 'rgb(56, 56, 56)',
    bg3l = '#1f1f1f',

    text = '#ffffff', 
}    


function hex2rgb(hex)
    hex = hex:gsub("#","")
    if #hex>7 then
        return tonumber("0x"..hex:sub(1,2)), tonumber("0x"..hex:sub(3,4)), tonumber("0x"..hex:sub(5,6)), tonumber("0x"..hex:sub(7,8))
    else
        return tonumber("0x"..hex:sub(1,2)), tonumber("0x"..hex:sub(3,4)), tonumber("0x"..hex:sub(5,6))
    end
end
function rgb2hex(r,g,b,a)
    if a then
        return string.format("#%02X%02X%02X%02X",math.floor(r), math.floor(g), math.floor(b), math.floor(a))
    else 
        return string.format("#%02X%02X%02X", math.floor(r), math.floor(g), math.floor(b))
    end
end

function csscolor2vector(hex)
    if type(hex)=='string' then
        if string.starts_with(hex,'#') then
            return {hex2rgb(hex)}
        elseif string.starts_with(hex,'rgb(') then 
            local prts = hex:sub(5,-2):split(',')
            return {tonumber(prts[1]),tonumber(prts[2]),tonumber(prts[3])} 
        elseif string.starts_with(hex,'rgba(') then 
            local prts = hex:sub(6,-2):split(',')
            return {tonumber(prts[1]),tonumber(prts[2]),tonumber(prts[3]),tonumber(prts[4])}
        end
    end
    return hex
end

function vector_lerp(a,b,delta)
    local nv = {}
    for k,v in ipairs(a) do
        nv[k] = v + (b[k] - v)*delta
    end
    return nv
end

local test1 = csscolor2vector('rgb(22 ,33 ,44)')
local test2 = csscolor2vector('#025029')

local keys = {'bg1','bg2d','bg2l','bg3d','bg3l','text'}
function blend_view_styles(a,b,delta)
    local n = {}
    for k,v in pairs(keys) do
        local v1 = csscolor2vector(a[v])
        local v2 = csscolor2vector(b[v])
        n[v] = rgb2hex(unpack(vector_lerp(v1,v2,delta)))
    end
    return n
end

thing._get_image_style_css = function(self)
    local t = self.image_style or {}
    return css_table_string(t)
end

function css_view_style(t)
    local t2 = {
        ['--bg1-color'] = t.bg1,
    
        ['--bg2d-color'] = t.bg2d,
        ['--bg2l-color'] = t.bg2l,
    
        ['--bg3d-color'] = t.bg3d,
        ['--bg3l-color'] = t.bg3l,
    
        ['--text-color'] = t.text, 
    }

    return css_table_string(t2)
end

thing._get_view_style_css = function(self)
    local t = self.view_style
    return css_view_style(t)
end



function send_map(target, origin_override,known_filter)
    if not target then return end
    

    local loc = origin_override or target.location
    local placecount = 1
    local places = {[loc] = 1}
    local placenames = {tostring(loc)}
    local links = {} 

    local mind = target.mind
    --print(L'center (1)[loc]')
    loc:foreach_adjascent(function(dir,room,prevroom,visited)
        local room_known
        if known_filter then
            room_known = mind:is_known(room)
            local prevroom_known = mind:is_known(prevroom)
 
            if not room_known and not prevroom_known then
                return
            end
        end

        local roomid = places[room]
        if not roomid then
            placecount = placecount + 1
            places[room] = placecount
            if known_filter then
                if not room_known then
                    placenames[placecount] = '???'
                else
                    placenames[placecount] = tostring(room)
                end
            else
                placenames[placecount] = tostring(room)
            end
            roomid = placecount
        end

        local roomid2 = places[prevroom] --should have set already


        if roomid2 and roomid>roomid2 then
            links[#links+1] = roomid..'-'..roomid2 
        end

        --print(L"([roomid])[prevroom] -[dir]-> ([roomid2])[room])") 
    end,100)

    printto(target,'$map:'..table.concat(placenames,',')..';'..table.concat(links,','))

end 





function send_map_grid(target, origin_override,known_filter)
    if not target then return end
    

    local size = 19

    local loc = origin_override or target.location
    local grid = loc.location.grid
    local gridsize = loc.location.gridsize
    if not grid then return end
    local pos = loc.pos
    --width;pixeldata(color)

    local pixeldata = {}
    for y=1,size do
        local py = y+pos.y-10 
        for x=1,size do
            local px = x+pos.x-10
            local idx = px+(py-1)*gridsize.x
            local tile = grid[idx]
            if px>0 and px<=gridsize.x and tile then 
                local color = (tile.tilecolor or "#FFFFFF"):sub(2)
                local subdata = 1*IF(tile.has_road,1,0)--8 bits flags
                pixeldata[#pixeldata+1] = color..string.format("%02X", subdata)
            else
                pixeldata[#pixeldata+1] = "00000000"
            end
        end
    end

 
    printto(target,'$mgrid:'..tostring(size)..';'..table.concat(pixeldata,','))

end 

function send_squad(ply)

    characters = {}
    local s = ply.squad
    if s then
        for k,v in pairs(s.list) do
            local icon = v.icon or v.image or "" 
            if s.leader==v and #characters>0 then
                local temp = characters[1]
                characters[1] = v.id..","..icon..","..v.name 
                characters[#characters+1] = temp 
            else
                characters[#characters+1] = v.id..","..icon..","..v.name  
            end
        end 
    else
        local icon = ply.icon or ply.image or "" 
        characters[1] = ply.id..","..icon..","..ply.name 
    end
    print('$squad:'..table.concat(characters, ';'))
    printout('$squad:',table.concat(characters, ';')) 
    --test_send_squad(ply)
end
function test_send_squad(ply)

    characters = {}
    local s = ply.squad
    if s then
        for k,v in pairs(s.list) do
            local icon = v.icon or v.image or "" 
            if s.leader==v and #characters>0 then
                local temp = characters[1]
                characters[1] = { 
                    id = v.id,
                    icon = icon, 
                    name = v.name
                } 
                characters[#characters+1] = temp 
            else
                characters[#characters+1] ={ 
                    id = v.id,
                    icon = icon, 
                    name = v.name
                } 
            end
        end 
    else
        local icon = ply.icon or ply.image or "" 
        characters[1] ={ 
            id = v.id,
            icon = icon, 
            name = v.name
        } 
    end 
    local msg = json.encode({
        type = 'squad',
        data = {
            characters = characters
        }
    })
    print('$J:'..msg)
    printout('$J:',msg) 
end

function send_health(to, target)
    target = target or to 
    local hp = target.health or 0 
    local food = target.food or 0 
    local water = target.water or 0 
    local maxhp = target.maxhealth or 0 
    local maxfood = target.maxfood or 0 
    local maxwater = target.maxwater or 0 
    if to==target then 
        printto(to,L'$hp:[hp];[maxhp]')
        printto(to,L'$food:[food];[maxfood]')
        printto(to,L'$water:[water];[maxwater]')
    else
        printto(to,L'$hp:[target.id];[hp];[maxhp]')
        --printto(to,L'$food:[target.id];[food];[maxfood]')
        --printto(to,L'$water:[target.id];[water];[maxwater]')
    end
end

function send_inventory(to,target)
    
    local worn = {}
    local things = {} 

    target = target or to

    --flag # key # img # style

    target:foreach('contains',function(k,v)
        if k~=player then
            if k:is('person') then 
           --     things[#things+1] = k
            elseif k.is_worn then 
                worn[#worn+1] = L"e#[k.id]#[k.image]#[k.image_style_css]"
            elseif k:is('body_part') then  
            else
                things[#things+1] = L"i#[k.id]#[k.image]#[k.image_style_css]"
            end 
        end
    end,true)
    for k,v in pairs(things) do
        worn[#worn+1] = v
    end
    local com = L'$inventory:[target.id];'..table.concat( worn, ';')
    printto(to,com)
end

function send_character_visuals(to,target)
    target = target or to 
    
    local data = {}
    if target:is("naga") then
        data.part_STRUCT = 'STRCT_NAGA'
        data.part_HEAD = 'HEAD_NAGA'
        data.part_HAIR_FRONT = 'HAIR_NAGA_FRONT'
        data.part_HAIR_BACK = 'HAIR_NAGA_BACK'
        data.part_PATTERN_BODY = 'PATTERN_BODY_SNAKE'
    elseif target:is("deermorph") then 
        data.part_HEAD = 'HEAD_DEER'
        data.part_EAR_R = "EAR_R_DEER"
        data.part_EAR_L = "EAR_L_DEER"
        data.part_LEG_R = "LEG_R_DEER"
        data.part_LEG_L = "LEG_L_DEER"
        data.part_TAIL = "TAIL_DEER"
    elseif target:is("kobold") then 
        data.part_HEAD = 'HEAD_HUMAN'
        data.part_PATTERN_BODY = 'PATTERN_BODY_SNAKE'
        data.part_EAR_R = "NULL"
        data.part_EAR_L = "NULL"
        data.part_LEG_R = "LEG_R_LIZARD"
        data.part_LEG_L = "LEG_L_LIZARD"
        data.part_TAIL = "TAIL_LIZARD"
        data.part_HAIR_FRONT = 'NULL'
        data.part_HAIR_BACK = 'NULL'
    elseif target:is("foxmorph") then 
        data.part_HEAD = 'HEAD_CIVET' 
        data.part_EAR_R = "EAR_R_FELINE"
        data.part_EAR_L = "EAR_L_FELINE"
        data.part_LEG_R = "LEG_R_FELID"
        data.part_LEG_L = "LEG_L_FELID"
        data.part_TAIL = "TAIL_FELID"
        data.part_HAIR_FRONT = 'NULL'
        data.part_HAIR_BACK = 'NULL'
    end
    if target:is('black') then
        data.i_body_color = "#202020"
        data.i_body_color2 = "#404040"
    elseif target:is('red') then
        data.i_body_color = "#802020"
        data.i_body_color2 = "#AA4040"
    elseif target:is('blue') then
        data.i_body_color = "#202080"
        data.i_body_color2 = "#4040AA"
    elseif target:is('green') then
        data.i_body_color = "#208020"
        data.i_body_color2 = "#40AA40"
    elseif target:is('silver') then
        data.i_body_color = "#808080"
        data.i_body_color2 = "#AAAAAA"
    elseif target:is('purple') then
        data.i_body_color = "#4c06a6"
        data.i_body_color2 = "#8e2fe9"
    elseif target:is('gold') then
        data.i_body_color = "#673515"
        data.i_body_color2 = "#eeb961"
    end

    local msg = json.encode(data)
    printto(to,'$charvisuals:'..msg)
end



showmap_action = Def('showmap_action',{key='map',restrictions = {"!asleep",'!blind'},callback = function(self)    
    send_map_grid(self,nil,false)
    return false -- no enturn
end,description='shorthand: l'},'action')
person:act_add(showmap_action)