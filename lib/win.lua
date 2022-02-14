
local ct = { 
    
    k = winapi.col_black,
    B = winapi.col_darkblue,
    G = winapi.col_darkgreen,
    C = winapi.col_darkcyan,
    R = winapi.col_darkred,
    M = winapi.col_darkmagenta,
    Y = winapi.col_darkyellow,
    v = winapi.col_gray,
    V = winapi.col_darkgray,
    b = winapi.col_blue,
    g = winapi.col_green,
    c = winapi.col_cyan,
    r = winapi.col_red,
    m = winapi.col_magenta,
    y = winapi.col_yellow,
    w = winapi.col_white, 
}

local sleeptime = 0
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
            local c1 = ct[text:sub(k+1,k+1)]
            local c2 = ct[text:sub(k+2,k+2)] 
           -- winapi.set_console_text_color(c1,c2) 
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
                sleep(sleeptime)
            end
        end
    end
    io.write('\r\n')
    sleeptime = 0
    if set then
      --  winapi.set_console_text_color(winapi.col_white,winapi.col_black) 
    end
end