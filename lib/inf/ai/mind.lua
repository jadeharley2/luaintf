
person:event_add('on_init','mind',function(self)
    local mind = {
        identity = self,
        personality = self,--replace with parameters
        memory = {},
        task = false,
    }
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
person._get_task = function(self)
    return rawget(self,'mind').task
end
person._set_task = function(self,value)
    rawget(self,'mind').task = value
end

person._get_memory = function(self)
    return rawget(self,'mind').memory
end 