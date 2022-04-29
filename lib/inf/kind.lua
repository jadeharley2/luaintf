
defines = defines or {}
kind_def = kind_def or {}
turn_kind_def = turn_kind_def or {}

adjective = adjective or false
adjective_def = adjective_def or {}

instidcount = instidcount or 0

function Def(id,data,kind)

    local old_data
    if id then
        old_data = defines[id] or {}
        if defines[id] then
            rawset(old_data,'__newindex', nil) 
            rawset(old_data,'__index', nil) 
        end 
    else
        old_data = {}
    end

    if data==nil then 
        data = old_data
        data.name = id 
        --data = { name = id}  
    elseif type(data) == 'string' then -- Def('Sarah','person')
        kind = data
        data = old_data
        data.name = id 
        --data = { name = id}
    else
        local nd = data 
        for k,v in pairs(data) do
            old_data[k] = v
        end
        data = old_data
    end

    local adjectives

    if id then   
        data.id = id
    end 


    if kind then 
        adjectives =string.split(kind,' ')
         
        kind = adjectives[#adjectives]
        adjectives[#adjectives] = nil


        local parent = defines[kind]
        --for k,v in pairs(parent) do
        --    if data[k]==nil then
        --        data[k] = v
        --    end
        --end
        data.base = parent 
        local this_meta = {
            __index = data,
            __newindex = function(tt,kk,vv)
                rawset(data,kk,vv)
            end,
        }
        data._this = setmetatable({ },this_meta)--get and set raw values 
        
        rawset(data,'__index',rawget(parent,'__index'))
        rawset(data,'__newindex',rawget(parent,'__newindex'))
        rawset(data,'__tostring',rawget(data,'__tostring') or rawget(parent,'__tostring'))
        
        setmetatable(data,parent)
    end
    if id then 
        defines[id] = data
    end
    data:call('on_init')
    data:event_call('on_init')
    

    if id and data:is(adjective) then 
        adjective_def[id] = data
    end

    if adjectives then
        for k,v in pairs(adjectives) do
            data:adj_set(v)
        end
    end

    return data;
end
function Inst(kind,data) 
    data = data or {}
    local kindparts = kind:split(' ')
    local nid = kindparts[#kindparts]..'_inst'..tostring(instidcount)
    data.id = nid
    instidcount = instidcount + 1
    return Def(nil,data,kind)
end
function Setup(data,a)
    local args = a:split(' ')
    for k,v in pairs(args) do
        local f = v:sub(1,1)
        if f == '-' or f=='!' then
            data:adj_unset(v:sub(2))
        else
            local x = defines[v]
            if x and not x:is('adjective') then
                local parent = x
                
                setmetatable(data,nil)

                data.base = parent 
                data.__index = parent.__index
                data.__newindex = parent.__newindex
                data.__tostring = data.__tostring or parent.__tostring
        
                setmetatable(data,parent)
            else
                data:adj_set(v)
            end
        end
    end
end

function Identify(id)
    if type(id)=='string' then
        return defines[id]
    else
        return id
    end
end
EventAdd('end turn','kind update',function(turn)
    for k,v in pairs(turn_kind_def) do
        k:call('on_turn_end')
        k:event_call('on_turn_end')
    end
end)
function InheritableSet(kind,key)

    local set_meta = {
       -- values = {},
        getall = function(t)
            local r = {}
            local self = kind
            while self and t do
                for k,v in pairs(t) do
                    if r[k] == nil then
                        r[k] = v
                    end
                end

                --local tadj = rawget(self,'adjectives')
                --if tadj then
                --    for ak,_ in pairs(tadj) do
                --        local at = adjective_def[ak]
                --        if at then
                --            local v = rawget(at,k)
                --            if v then return v end
                --        end
                --    end
                --end

                self = rawget(self,'base') 
                if self then
                    t = rawget(self,key) 
                end
            end
            for k,v in pairs(r) do
                if v==false then r[k] = nil end
            end
            return r
        end
    }
    set_meta.__index = function(t,k)
        if k == 'getall' then return set_meta.getall end

        local self = kind
        while self and t do
            local v = rawget(t,k)
            if v then return v end

            local tadj = rawget(self,'adjectives')
            if tadj then
                for ak,_ in pairs(tadj) do
                    local at = adjective_def[ak]
                    if at then
                        local v = rawget(at,k)
                        if v then return v end
                    end
                end
            end

            self = rawget(self,'base') 
            if self then
                t = rawget(self,key) 
            end
        end
    end

    set_meta.__newindex = function(t,k,v)
        rawset(t,k,v)
    end


    local set = setmetatable({},set_meta)
    kind[key] = set
    return set
end


foreach_type = function(self,callback,include_self)
    local c 
    if include_self then 
        c = self
    else
        c = self.base
    end
    while c do
        local r = callback(c)
        if r then return r end
        c = c.base
    end
end


thing = Def('thing',{
    --name = "A thing",
    --_get_name = function(s) return s.id end,
    _get_description = LF"You see nothing special about [self].", 
    foreach = function(self,key,callback,thisonly)
        local s = self
        while s do
            local t = rawget(s,key)
            if t then
                for k,v in pairs(t) do
                    callback(k,v)
                end
            end
            
            if thisonly then
                return 
            end

            local tadj = rawget(self,'adjectives')
            if tadj then
                for ak,_ in pairs(tadj) do
                    local at = adjective_def[ak]
                    if at then
                        local t = rawget(at,key)
                        if t then
                            for k,v in pairs(t) do
                                callback(k,v)
                            end
                        end
                    end
                end
            end



            s = s.base
        end
    end,
    foreach_type = foreach_type,
    first = function(self,key,callback,thisonly)
        local s = self
        while s do
            local t = rawget(s,key)
            if t then
                for k,v in pairs(t) do
                    local rez = callback(k,v)
                    if rez then 
                        return rez
                    end
                end
            end
            if thisonly then
                return 
            end


            local tadj = rawget(self,'adjectives')
            if tadj then
                for ak,_ in pairs(tadj) do
                    local at = adjective_def[ak]
                    if at then
                        local t = rawget(at,key)
                        if t then
                            for k,v in pairs(t) do
                                local rez = callback(k,v)
                                if rez then 
                                    return rez
                                end
                            end
                        end
                    end
                end
            end
 

            s = s.base
        end
    end,
    collect = function(self,key,callback,thisonly)
        local s = self
        local rez_ray = {}
        while s do
            local t = rawget(s,key)
            if t then
                for k,v in pairs(t) do
                    rez_ray[#rez_ray+1] = callback(k,v) 
                end
            end
            if thisonly then
                return rez_ray
            end

            local tadj = rawget(s,'adjectives')
            if tadj then
                for ak,_ in pairs(tadj) do
                    local at = adjective_def[ak]
                    if at then
                        local t = rawget(at,key)
                        if t then
                            for k,v in pairs(t) do
                                rez_ray[#rez_ray+1] = callback(k,v) 
                            end
                        end
                    end
                end
            end


            s = s.base
        end
        return rez_ray
    end,
    --this kind
    --this adjective kinds
    --parent kind 
    --...
    __index = function(t,k)
        if k=='this' then 
            return rawget(t,'_this')
        end
        local prop_id
        local topt = t
        local sub5 = k:sub(1,5)
        if sub5~='_get_' and sub5~='_set_' then
            prop_id = '_get_'..k
            --local get_f = t['_get_'..k]
            --if get_f then
            --    return get_f(t)
            --end
        end 
        while t do
            if prop_id then
                local get_f = rawget( t,prop_id)
                if get_f then
                    return get_f(topt)
                end
            end
 
            --do not inherit name from adjectives
            --try to redirect it
            local adj_key
            local adj_prop
            if k=='name' then
                adj_key = 'nounname'
                adj_prop = '_get_nounname'
            else
                adj_key = k
                adj_prop = prop_id
            end


            if k~='id' then
                local tadj = rawget(t,'adjectives')
                if tadj then
                    for ak,_ in pairs(tadj) do
                        local at = adjective_def[ak]
                        if at then 
                            if adj_prop then
                                local get_f = rawget( at,adj_prop)
                                if get_f then
                                    return get_f(topt)
                                end
                            end 

                            local v = rawget(at,adj_key)
                            if v~=nil then  
                                return v 
                            end
                        end
                    end
                end
            end

            local v = rawget(t,k)
            if v~=nil then  
                return v 
            end
            
            t = t.base
        end
    end,
    __newindex = function(t,k,v)   
        if k:sub(1,5)~='_set_' then
            local set_f = t['_set_'..k]
            if set_f then
                set_f(t,v)
                return
            end
        end   
        rawset(t,k,v)
    end,
    __tostring = function(t)
        return t.name
    end,
    rawget = function(t,k)
        return rawget(t,k)
    end, 
    call = function(t,k,...)
        local f = t[k] 
        if f then
            return f(t,...)
        end
    end,
    ensure = function(t,k,v)
        local x = rawget(t,k)
        if x==nil then
            t[k] = v
            return v
        end
        return x
    end,

    event_add = function(self,id,eid,callback)
        local k ='_event_'..id
        local t = rawget(self,k)
        if not t then
            t = InheritableSet(self,k)
            rawset(self,k,t)
        end
        t[eid] = callback
    end,
    event_del = function(self,id,eid)
        local k ='_event_'..id
        local t = rawget(self,k)
        if t then
            t[eid] = nil
        end
    end,
    event_call = function(self,id,...)
        local k ='_event_'..id
        local set = self[k]
        if set then
            for k,v in pairs(set:getall()) do
                local r = v(self,...)
                if r~=nil then return r end
            end
        end
    end,

    adj_set = function(self,k) 
        if type(k)=='table' then
            for _,v in pairs(k) do self:adj_set(v) end
        else
            local t = rawget(self,'adjectives')
            if not t then
                t = {}--InheritableSet(self,'adjectives')
                rawset(self,'adjectives',t)
            end
            t[k] = true
        end
    end,
    adj_unset = function(self,k) 
        if type(k)=='table' then
            for _,v in pairs(k) do self:adj_unset(v) end
        else
            local t = rawget(self,'adjectives')
            if not t then
                t = {}--InheritableSet(self,'adjectives')
                rawset(self,'adjectives',t)
            end
            t[k] = false
        end
    end,
    adj_isset = function(self,k)
        return foreach_type(self,function(b) 
            local a = rawget(b,'adjectives')
            if a then 
                return a[k]  
            end
        end,true)

        --local a = self.adjectives
        --return a and a[k] 
    end,
    adj_getall = function(self)
        return self.adjectives:getall()
    end,
    adj_describe = function(self, adj_type)
        local x = {}
        for k,v in pairs(self.adjectives:getall()) do
            local t = adjective_def[k] 
            if t then
                if not adj_type or t:is(adj_type) then 
                    x[#x+1] = t.name
                end
            end
        end
        return table.concat(x,' ')
    end,
    adj_describe2 = function(self, s)
        s = s or self.name
        for k,v in pairs(self.adjectives:getall()) do
            local t = adjective_def[k] 
            if t then
                s = t:describe2(self,s) or s
            end
        end
        return s
    end,
    setup = function(self,a)
        Setup(self,a)
    end,
    is = function(self,k)
        if self == k then return true end
        if self.id == k then return true end
        if type(k)=='string' and self:adj_isset(k) then return true end
        local base = self.base 
        while base do 
            if base==k or base.id == k then return true end 
            base = base.base
        end
        return false
    end, 
    set_updating = function(self,enabled)
        if enabled then
            turn_kind_def[self] = true
        else
            turn_kind_def[self] = nil
        end
    end,
    
    make_sound = function(self,text,mode)  
        mode = mode or 'ambient'
        self.location:foreach('contains',function(k,v)
            local hear = k.hear 
            if hear then
                hear(k,self,text,mode)
            end
        end)  
    end,
    make_sound_inside = function(self,text,mode)  
        mode = mode or 'ambient'
        self:foreach('contains',function(k,v)
            local hear = k.hear 
            if hear then
                hear(k,self,text,mode)
            end
        end)  
    end,

    find = function(self,a)
        local args = a:split(' ')
        return self:first('contains',function(x)
            for k,v in pairs(args) do
                if not x:is(v) then
                    return nil
                end
            end
            return x
        end)
    end,
    findall = function(self,a)
        local args = a:split(' ')
        return self:collect('contains',function(x)
            for k,v in pairs(args) do
                if not x:is(v) then
                    return nil
                end
            end
            return x
        end)
    end,
})
InheritableSet(thing,'adjectives')


function LocalIdentify(id,location)
    if id then
        if type(id) == 'string' then
            location = location or player.location

            local c = location:collect('contains',function(k,v)
                if k:is(id) then
                    return k
                end
            end) 
            if #c>0 then 
                for k,v in pairs(c) do
                    if v.id==id then
                        return v
                    end
                end
                return c[1]
            end 

            
            local candidates = {}
            location:foreach('contains',function(k,v)
                if k.name:find_anycase(id) then
                    candidates[string.levenshtein(k.name, id) ]= k
                end
            end)

            for k,v in AscendingPairs(candidates) do
                return v
            end
            
            --or location:first('contains',function(k,v)
            --    if k.name:find_anycase(id) then
            --        return k
            --    end
            --end)
        else
            return id  
        end
    end
end

function ListIdentify(id,list)
    if id then
        if type(id) == 'string' then
            for k,v in pairs(list) do
                if v:is(id) then
                    return v
                end
            end
            for k,v in pairs(list) do
                if v.name:find_anycase(id) then
                    return v
                end
            end 
        else
            return id  
        end
    end
end
function ReachableIdentify(id,user,room)
    user = user or player
    room = room or user.location
    local lst = {}
    room:call('get_reachables',user,lst)
    if lst then
        return ListIdentify(id,lst)
    end
end

adjective = Def('adjective','thing')
adjective.describe = function(target,str)
    return str
end

