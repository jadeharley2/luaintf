
local tc = table.concat
function table.concat(t,sep)
    local ts ={}
    for k,v in pairs(t) do
        ts[k] = tostring(t[k])
    end
    return tc(ts,sep)
end

function table.keys_to_values(t)
    local n = {}
    for k,v in pairs(t) do
        n[#n+1] = k
    end
    return n
end

function table.set(t)
    local r = {}
    for k,v in pairs(t) do
        r[v] = true
    end
    return r
end