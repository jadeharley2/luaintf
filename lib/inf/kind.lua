
defines = {

}
kind_def = {
    
}
turn_kind_def = {

}
function Def(id,data,kind)
    if data==nil then 
        data = {name = id}
    end
    if type(data) == 'string' then -- Def('Sarah','person')
        kind = data
        data = {name = id}
    end

    data.id = id
    if kind then 
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
        
        data.__index = parent.__index
        data.__newindex = parent.__newindex
        data.__tostring = parent.__tostring
        
        setmetatable(data,parent)
    end
    defines[id] = data
    data:call('on_init')
    return data;
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
thing = Def('thing',{
    name = "A thing",
    _get_description = LF"You see nothing special about [self.name].",
    foreach = function(self,key,callback)
        local s = self
        while s do
            local t = rawget(s,key)
            if t then
                for k,v in pairs(t) do
                    callback(k,v)
                end
            end
            s = s.base
        end
    end,
    first = function(self,key,callback)
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
            s = s.base
        end
    end,
    collect = function(self,key,callback)
        local s = self
        local rez_ray = {}
        while s do
            local t = rawget(s,key)
            if t then
                for k,v in pairs(t) do
                    rez_ray[#rez_ray+1] = callback(k,v) 
                end
            end
            s = s.base
        end
        return rez_ray
    end,
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

            local v = rawget(t,k)
            if v then  
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

    adj_set = function(self,k) 
        if type(k)=='table' then
            for _,v in pairs(k) do self:adj_set(v) end
        else
            local t = rawget(self,'adjectives')
            if not t then
                t = InheritableSet(self,'adjectives')
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
                t = InheritableSet(self,'adjectives')
            end
            t[k] = false
        end
    end,
    adj_isset = function(self,k)
        local a = self.adjectives
        return a and a[k] 
    end,
    adj_getall = function(self)
        return self.adjectives:getall()
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
})
InheritableSet(thing,'adjectives')


function LocalIdentify(id,location)
    if id then
        location = location or player.location
        return location:first('contains',function(k,v)
            if k:is(id) then
                return k
            end
        end) or location:first('contains',function(k,v)
            if k.name:find_anycase(id) then
                return k
            end
        end)
    end
end
