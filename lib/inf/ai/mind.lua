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

meta_mind.__index = meta_mind


person:event_add('on_init','mind',function(self)
    local mind = setmetatable({
        identity = self,
        personality = self,--replace with parameters
        memory = {},
        task = false,
    },meta_mind)
    rawset(self,'mind', mind) 
    mind.memory.name = self.name
end)
person:event_add('on_turn_end','mind',function(self)
    local mind = rawget(self,'mind')
    if mind then 
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
end)

person._get_personality = function(self)
    return rawget(self,'mind').personality
end
person._set_personality = function(self,value)
    rawget(self,'mind').personality = value
end
person._get_identity = function(self)
    return rawget(self,'mind').identity
end
person._set_identity = function(self,value)
    rawget(self,'mind').identity = value
end
person._get_task = function(self)
    return rawget(self,'mind').task
end
person._set_task = function(self,value)
    rawget(self,'mind').task = value
end

person._get_memory = function(self)
    return rawget(self,'mind').memory
end 