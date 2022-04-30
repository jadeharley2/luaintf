meta_mind = meta_mind or {}

own_self = Def("own_self",'thing') -- memory key

function meta_mind:swap_memory(key1,key2,targ)
    key2 = key2 or key1
    if targ then
        local val1 = self.memory[key1]
        local val2 = targ.memory[key2] 
        self.memory[key1] = val2 
        targ.memory[key2] = val1 
    else
        local val1 = self.memory[key1]
        local val2 = self.memory[key2] 
        self.memory[key1] = val2 
        self.memory[key2] = val1 
    end
end
function meta_mind:swap_random_memory(targ,used_keys,tries)
    local src = table.random({self,targ})
    local dst = IF(src==targ,self,targ)
    src = src.memory
    dst = dst.memory
    for k=1,(tries or 1000) do 
        local key = table.randomkey(src)
        if not used_keys or not used_keys[key] then
            local srcvalue = src[key]
            local dstvalue = dst[key]
            src[key] = dstvalue
            dst[key] = srcvalue
            used_keys[key] = true
            return true, key
        end
    end
    return false
end
function meta_mind:context(f)
    local memory = self.memory
    local ENV = {}
    ENV.__index = function(t,k)
        return memory[k]
    end
    ENV.__newindex = function(t,k,v)
        memory[k] = v
    end
     
    debug.setupvalue(f,1,ENV)
    f(self)
end
--function meta_mind:set_known_prop(target,key,value) 
--    local t = self:make_known(target)
--    t[key] = value
--end
--function meta_mind:get_known_prop(target,key) 
--    local t = self:get_known(target)
--    if t then
--        return t[key]
--    end
--end
--knows({rose,dave,john},"name")
--knows({rose,dave,john},{"name","age"})
--knows({rose,dave,john},{"name",age="age_num"})
--knows({rose,dave,john},{"name",age=function(x) return x.age+30 end})
function meta_mind:knows(target_list,mem_key,target_key) 
    target_key = target_key or mem_key
    for k,v in pairs(target_list) do 
        if type(mem_key)=='table' then
            for k2,v2 in pairs(mem_key) do
                local val
                if type(v2)=='function' then
                    val = v2(v)
                else
                    val = v[v2]
                end

                if type(k2)=='number' then
                    self(v,v2,val)
                else
                    self(v,k2,val)
                end
            end
        else
            self(v,mem_key,v[target_key])
        end
    end
end

function meta_mind:find(key,value)
    local t ={}
    for k,v in pairs(self.memory) do
        if type(v)=='table' then
            if v[key]==value then
                t[k]=v
            end
        end
    end
    return t
end
function meta_mind:first(key,value) 
    for k,v in pairs(self.memory) do
        if type(v)=='table' then
            if v[key]==value then
                return v,k
            end
        end
    end 
end

function meta_mind:get_known(t,key)
    local known = self.memory--.known_things or {}
    --self.memory.known_things = known 
    local v = known[t]
    if key then
        if v then
            return v[key]
        end
    else
        return v
    end
end
function meta_mind:set_known(t,key,value)
    local known = self.memory--.known_things or {}
    --self.memory.known_things = known 
    local v = known[t] or {}
    known[t] = v
    if key then
        v[key] = value
    end
    return v
end
function meta_mind:make_known(t)
    local known = self.memory--.known_things or {}
    --self.memory.known_things = known 
    local v = known[t] or {}
    known[t] = v
    return v
end
function meta_mind:make_fully_known(t)
    local known = self.memory--.known_things or {}
    --self.memory.known_things = known 
    --known[t] = 'fully'
    known[t] = known[t] or {} 
    t:foreach_contains(function(v)
        known[v] = known[v] or {}  
    end,true)
end

function meta_mind:forget(t)
    local known = self.memory--.known_things or {}
    --self.memory.known_things = known 
    known[t] = nil
end
function meta_mind:fully_forget(t)
    local known = self.memory--.known_things or {}
    --self.memory.known_things = known 
    known[t] = nil
    t:foreach_contains(function(v)
        known[v] = nil  
    end,true)
end
function meta_mind:is_known(t,key)
    local known = self.memory--.known_things or {} 
    local v = known[t]
    if key then
        if v then
            return v[key]
        end
    else
        return v
    end
end
function meta_mind:memory_tostring()

    local keyed = {}
    for k,v in pairs(self.memory) do
        if type(k)=='table' then
            keyed[k.id or "?"] = v
        else
            keyed[k] = v
        end
    end

    local lines = {}
    for k,v in SortedPairs(keyed) do 
        if type(v)=='table' then
            local sublines = {}
            for kk,vv in SortedPairs(v) do
                sublines[#sublines+1] = "  "..kk.." = "..tostring(vv)
            end
            if #sublines>0 then
                lines[#lines+1] = "{"..k.."}".." = {"
                for kk,vv in ipairs(sublines) do
                    lines[#lines+1] = "  "..vv
                end
                lines[#lines+1] = "}"
            else
                lines[#lines+1] = "{"..k.."}"
            end
        else
            lines[#lines+1] = k .. ' = ' .. tostring(v)
        end
    end
    return lines
end

function meta_mind:visuals_changed(target,changes)

end
meta_mind.__call = function(self,target,key,value)
    if value~=nil then
        self:set_known(target,key,value)
    else
        return self:get_known(target,key)
    end
end 
meta_mind.__index = meta_mind


person:event_add('on_init','mind',function(self)
    local mind = setmetatable({
        identity = self,
        personality = self,--replace with parameters
        memory = {},
        task = false,
        identities = { [self] = 1 }
    },meta_mind)
    rawset(self,'mind', mind) 
 
    mind.memory[self] = {name = self.name}
    mind.memory[own_self] = mind.memory[self]
    mind.memory.name = self.name
end)
person:event_add('on_turn_end','mind',function(self)
    local mind = rawget(self,'mind')
    if mind then --and (not self.player or self.ai_override) then 
        local t = mind.task 
        if t then 
            if not t.is_started then
                t:Start(self,mind,mind.memory)
            end
            if not t.is_ended then
                t:Update(self,mind,mind.memory)
            else
                mind.task = false
            end
        end
    end
    if mind and mind.memory then
        if self.can_see then
            sense_sight.perceive(self,mind)
        end
        --mind:make_known(self.location)
    end
end)

person._get_can_see = function(self)
    if self:is('blind') then return false end 
    if self:is('sleeping') then return false end
    return true 
end

person._get_personality = function(self)
    return rawget(self,'mind').personality
end
person._set_personality = function(self,value)
    rawget(self,'mind').personality = value
end
--person._get_identity = function(self)
--    return rawget(self,'mind').identity
--end
--person._set_identity = function(self,value)
--    rawget(self,'mind').identity = value
--end
person._get_task = function(self)
    return rawget(self,'mind').task
end
person._set_task = function(self,value)
    rawget(self,'mind').task = value
end

person._get_memory = function(self)
    return rawget(self,'mind').memory or {}
end 

person.get_identity_strength = function(self,identity)
    identity = identity or self
    local mind = self.mind 
    if mind then
        local identities = mind.identities or {}

        local val = identities[identity]
        if val then
            local total = 0 
            for k,v in pairs(mind.identities or {}) do total = total + v end  
            return val/total
        end
    end
    return 0
end
person._get_identities = function(self)
    identity = identity or self
    local mind = self.mind 
    if mind then
        return mind.identities or {}  
    end
    return {}
end
--dominant identity
person._get_identity = function(self) 
    local mind = self.mind 
    if mind then
        local maxv = 0
        local maxid
        for k,v in pairs(mind.identities or {}) do
            if maxv<v then
                maxid = k
                maxv = v
            end
        end
        return maxid
    end
end
person._set_identity = function(self,value)
    identity = identity or self
    local mind = self.mind 
    if mind then
        mind.identities = {[value] = 1}
    end
end
person.set_identity_strength = function(self,identity,value)
    identity = identity or self
    local mind = self.mind 
    if mind and mind.identities then
        local id = mind.identities

        value = math.clamp(value,0,1)
       -- local identities = id
       -- 
       -- local total = 0 
       -- for k,v in pairs(id) do total = total + v end  
       -- local sub = (total - value) /(total-1) 
       -- 
       -- for k,v in pairs(id) do 
       --     id[k] = v-sub
       -- end  

        id[identity] = value
    end
end


Include('sight.lua')

