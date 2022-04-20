local meta_mind = {}

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
function meta_mind:make_known(t)
    local known = self.memory.known_things or {}
    self.memory.known_things = known 
    known[t] = true
end
function meta_mind:make_fully_known(t)
    local known = self.memory.known_things or {}
    self.memory.known_things = known 
    --known[t] = 'fully'
    known[t] = true 
    t:foreach_contains(function(v)
        known[v] = true  
    end,true)
end
function meta_mind:forget(t)
    local known = self.memory.known_things or {}
    self.memory.known_things = known 
    known[t] = nil
end
function meta_mind:fully_forget(t)
    local known = self.memory.known_things or {}
    self.memory.known_things = known 
    known[t] = nil
    t:foreach_contains(function(v)
        known[v] = nil  
    end,true)
end
function meta_mind:is_known(t)
    local known = self.memory.known_things or {} 
    local v = known[t]
    return known[t] 
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
    mind.memory.name = self.name
end)
person:event_add('on_turn_end','mind',function(self)
    local mind = rawget(self,'mind')
    if mind and (not self.player or self.ai_override) then 
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
    if mind then
        mind:make_known(self.location)
    end
end)

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

