
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


showmap_action = Def('showmap_action',{key='map',restrictions = {"!asleep",'!blind'},callback = function(self)    
    send_map(self,nil,true)
    return false -- no enturn
end,description='shorthand: l'},'action')
person:act_add(showmap_action)