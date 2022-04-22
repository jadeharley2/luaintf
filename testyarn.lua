yarn = yarn or {}

function yarn.parse(filename)
    local info = debug.getinfo(2,'S');  
    local str = info.source:sub(2)
    local dir = str:match("(.*/)") or str:match("(.*\\)") or ""
    local f = assert(io.open(dir..filename, "r"))
    local t = f:read("*all")
    f:close()
    local lines = t:split('\n')
    local nodes = {}
    local cnode = {text = {}}
    local textmode = false
    for k,line in ipairs(lines) do 
        if line == '---' then
            textmode = true
        elseif line == '===' then
            textmode = false 
            nodes[cnode.title] = cnode
            cnode = {text = {}} 
        else
            if textmode then
                cnode.text[#cnode.text+1] = line 
            else
                local kv = line:split(':')
                if #kv==2 then
                    if kv[1]=='tags' then
                        cnode[kv[1]] =string.split(string.sub(kv[2],2),' ')
                    else
                        cnode[kv[1]] = string.sub(kv[2],2)
                    end
                end
            end
        end 
    end
    return {nodes = nodes,filename = filename}
end
function yarn.compile(ydata,env)
    local go = function(id)
        ydata.nodes[id].action()
    end
    local env = setmetatable({
        go = go,
        wait = cor.wait,
    },{__index=_ENV})

    for k,v in pairs(ydata.nodes) do
        local text = table.concat(v.text,'\n')
        local f = load(text)--,text,'t') 
        
        debug.setupvalue(f,1,env)
        v.action = f
    end
end
function yarn.run(ydata,id)
    ydata.nodes[id].action()
end

--local fir = yarn.parse('test.yarn')
--yarn.compile(fir)
--
--yarn.run(fir,'test0')
--
--local b = 0