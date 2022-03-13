function Include(path)
    local info = debug.getinfo(2,'S');  
    local str = info.source:sub(2)
    local dir = str:match("(.*/)")
    if dir then
        print('Include: '..dir..path)
        dofile(dir..path)
    else
        print('Include: '..path)
        dofile(path)
    end
end

function error_handler(x) 
    print ("error! ", x)
    print(debug.traceback())
end
      
unpack = table.unpack



--[[ --outdated 
function L(str)
    local faf = debug.getinfo(2,'f')
    local upfunc = faf.func
    local k,env = debug.getupvalue(upfunc,1)


    local parsed = ""
    local lastid = 0
    --local command_mode = false

    for k=1,#str do
        local char = str:sub(k,k)
        if char=='[' then
            parsed = parsed .. str:sub(lastid,k-1)
            --command_mode = true
            lastid = k+1
        elseif char ==']' then
            local command = str:sub(lastid,k-1)
            local v = env[command]
            if v then
                if type(v) == 'function' then
                    parsed = parsed .. tostring( v() )
                else
                    parsed = parsed .. tostring( v )
                end
            else
                local f = load('return '..command,'com','t',env) 
                
                parsed = parsed .. tostring( f() )
            end
            --command_mode=false
            lastid = k+1
        end
    end
    parsed = parsed .. str:sub(lastid,#str)
    return parsed

end
]]
function emptystr() return "" end

local function make_com(str,noreturn)

    local lastid = 0
    --local command_mode = false

    local index = false

    local parts = {}

    local level = 0
    for k=1,#str do
        local char = str:sub(k,k)
        if char=='[' then 
            if level == 0 then 
                local s = str:sub(lastid,k-1)
                if #s>0 then
                    parts[#parts+1] = '[['..s..']]'
                end
                --command_mode = true
                lastid = k+1
            end
            level = level + 1
        elseif char ==']' then
            level = level - 1
            if level == 0 then 
                local command = str:sub(lastid,k-1)
                local made_index = false
                
                local cparts = command:split('|')
                if #cparts>1 then
                    local subs = {}
                    for k,v in pairs(cparts) do
                        subs[k] = make_com(v,true) or '[['..v..']]'
                    end
                    --if noreturn then
                        parts[#parts+1] = 'table.random({'..table.concat(subs,',')..'})'
                    --else
                    --    parts[#parts+1] = 'return table.random({'..table.concat(subs,',')..'})'
                    --end
                else
                    if command:sub(1,1) == '!' then -- set as indexed table
                        command = command:sub(2) 
                        if #command==0 then
                            index = false
                        else
                            index = string.replace(command,';','')
                        end 
                        made_index = true 
                    end
                    
                    local lc = #command
                    if lc>0 then
                        
                        if command:sub(lc,lc) ==';' then -- mute 
                            parts[#parts+1] = 'emptystr('..command:sub(1,lc-1)..')' 
                        else
                            if index and not made_index then
                                parts[#parts+1] = 'tostring('..index..'.'..command..' or '..command..')' 
                            else
                                parts[#parts+1] = 'tostring('..command..')' 
                            end
                        end
                    end
                end

               
            
                --command_mode=false
                lastid = k+1
            else

            end
        end
    end

    if lastid==0 then return false end -- no commands

    local s = str:sub(lastid,#str)
    if #s>0 then 
        parts[#parts+1] = '[['..s..']]'
    end
 
    if noreturn then
        if #parts==1 then
            return parts[1]
        else
            return 'table.concat({ ' ..table.concat(parts,', ')..' })'
        end
    else
        if #parts==1 then
            return 'return '..parts[1]
        else
            return 'return table.concat({ ' ..table.concat(parts,', ')..' })'
        end
    end
end

local function GatherLocalvars(x) 
    local localvars = {} 
    local a = 1
    while true do
      local name, value = debug.getlocal(3+(x or 0), a)
      if not name then break end
      localvars[name] = value 
      a = a + 1
    end 
    return setmetatable(localvars,{__index=_ENV}) 
end

local lc_cache = {}
function L(str,up1) 

    local r = lc_cache[str]
    if r~=nil then 
        if r then
            debug.setupvalue(r,1,GatherLocalvars(up1))
            return r()
        else
            return str
        end
    end

    local com = make_com(str)
    if com then
        local cfun = load(com)
        lc_cache[str] = cfun
        debug.setupvalue(cfun,1,GatherLocalvars(up1))

        return cfun()
    else--no code
        lc_cache[str] = false
        return str
    end

end
function L2(str) 
    return L(L(str,1),1)
end

function LF(str)

    local localvars = {}

    local a = 1
    while true do
      local name, value = debug.getlocal(2, a)
      if not name then break end
      localvars[name] = value 
      a = a + 1
    end
    --localvars.self = localvars['(temporary)'] or localvars.self
    

    setmetatable(localvars,{__index=_ENV})
    

    local com ='return function(self) '..make_com(str)..' end'
 
    local cfun = load(com)()
    --lc_cache[str] = cfun
    debug.setupvalue(cfun,1,localvars)

    return cfun
end

function IF(condition,a,b)
    if condition then return a else return b end
end

function sleep(s)
    if type(s) ~= "number" then
        error("Unable to wait if parameter 'seconds' isn't a number: " .. type(s))
    end
    -- http://lua-users.org/wiki/SleepFunction
    local ntime = os.clock() + s/10
    repeat until os.clock() > ntime
end

function table.random(t) 
    local c = 0
    local u = {}
    for k,v in pairs(t) do
        c = c + 1
        u[c] = v
    end
    
    local id = math.random(c)
    return u[id]
end
function table.randomkv(t) 
    local c = 0
    local u = {}
    for k,v in pairs(t) do
        c = c + 1
        u[c] = {k,v}
    end
    if c==0 then return nil end
    local id = math.random(c)
    local r = u[id]
    return r[1], r[2]
end

function table.count(t)
    local c = 0
    for k,v in pairs(t) do c = c+1 end
    return c
end

