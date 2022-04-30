IS_MOBILE = true
local info = debug.getinfo(1,'S') 
local str = info.source:sub(2,-11-7)
   print(str)
df = dofile
function dofile(x)
   df(str..x)
end

local sleeptime=0
function print_c_msg(...)
    local inp = {...}
    for k,v in pairs(inp) do
        inp[k] = tostring(v)
    end

    local text = table.concat(inp,' ')
    local k = 1
    local tl = #text
    local set = false
    while k<=tl do 
        local char = text:sub(k,k)
        if char == '$' then --$rk RED $wk
            
            
             
            set=true
            k = k + 3
        elseif char == '%' then --%1
            local c1 = tonumber(text:sub(k+1,k+1))/4
            k = k + 2
            sleeptime = c1
        else 
            io.write(char)
            k = k + 1
            if sleeptime>0 then
                
            end
        end
    end
    io.write('\r\n')
    sleeptime = 0
    
end






dofile('base_inform.lua')
main()