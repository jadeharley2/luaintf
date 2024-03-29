
package.path = 'modules/?.lua;' .. package.path 
package.cpath = 'modules/?.dll;' .. package.cpath 

function Include(path,up)
    local info = debug.getinfo(2+(up or 0),'S');  
    local str = info.source:sub(2)
    local dir = str:match("(.*/)") or str:match("(.*\\)") 
    if dir then
        print('Include: '..dir..path)
      --  local status, err = pcall(function() 
        if IS_MOBILE then
            df(dir..path)
        else
            dofile(dir..path)
        end
      --  end)
        if err then print(status,err) end
    else
        print('Include: '..path)
      --  local status, err = pcall(function() 
        if IS_MOBILE then
            df(path)
        else
            dofile(path)
        end 
      --  end)
        if err then print(status,err) end
    end
end
  
--[[
local R = require
function require(path)
    local module_path = 'modules/'..string.gsub(path,'%.','/')
    if io.exists(module_path..'.lua') or io.exists(module_path..'.dll') then
        local module_path2 = 'modules.'..path 
        return R(module_path2)
    end

    local info = debug.getinfo(2,'S');  
    local str = info.source:sub(2)
    local dir = str:match("(.*/)")
    if dir and (io.exists(dir..'.lua') or io.exists(dir..'.dll')) then   
        dir = string.gsub(dir,'/','.')
        return R(dir..path) 
    else 
        return R(path)
    end
end
]]

function error_handler(x) 
    print ("error! ", x)
    print(debug.traceback())
end
      
unpack = table.unpack



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


