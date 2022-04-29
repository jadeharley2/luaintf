
local function prepare_schedule_inner(sched,once)
    for k,v in pairs(sched) do
        local at = v.at 
        if at then 
            --for k2,v2 in pairs(weekday_names) do
            --    if string.gmatch(at,v2) then
            --        v.weekday = k2
            --        at = string.gsub(at,v2,'')
            --        break
            --    end
            --end
            local prt = at:split(':')
            v.hour = tonumber(prt[1])
            v.minute = tonumber(prt[2])
        end
        v.once = true--once
        if v.oncomplete then
            prepare_schedule_inner(v.oncomplete,true)
        end
        if v.onfailed then
            prepare_schedule_inner(v.onfailed,true)
        end
    end
end
local function prepare_schedule(sched)
    for kk,vv in pairs(sched) do
        if vv.days then
            local range = vv.days:split('-')
            if #range==2 then
                local wstart = weekday_set[range[1]:trim()]
                local wend = weekday_set[range[2]:trim()]
                if wstart and wend then
                    if wstart<=wend then
                        vv.condition = function()
                            return weekday>=wstart and weekday<=wend
                        end
                    else --if wstart>wend then thursday-monday (4-1) 1 and 4,5,6,7
                        vv.condition = function()
                            return weekday>=wend or weekday<=wstart  
                        end
                    end
                end
            else
                local array = vv.days:split(',')
                local ws = {}
                for k,v in pairs(array) do  ws[weekday_set[v:trim()]]=true end

                vv.condition = function()
                    return ws[weekday] 
                end
                
            end
        end
        prepare_schedule_inner(vv.schedule)
    end
    return sched
end
local taskpool_meta = {}

taskpool_meta.__add = function(a,b)
    if b.task then -- single task
        a[#a+1] = b
    else --task array
        for k,v in ipairs(b) do
            a[#a+1] = v
        end
    end
    return a
end
taskpool_meta.__sub = function(a,b)
    local temp = {}

    if b.task then -- single task
        for k,v in ipairs(a) do 
            if v~=b then
                temp[#temp+1] = v
            end
        end
    else --task array
        local set = {}
        for k,v in pairs(b) do set[v] = true end 

        for k,v in ipairs(a) do 
            if not set[v] then
                temp[#temp+1] = v
            end
        end
    end
    return setmetatable(temp,taskpool_meta)
end

taskpool_meta.__index = taskpool_meta

function TaskPool(list)
    return setmetatable(list or {},taskpool_meta)
end

local function RunNodeInner(self,v,npc,mind,memory)
    if v.task then 
        self.task = v
        v.task:Start(npc,mind,memory)
    elseif v.schedule then
        local sched_node = self.schedule[v.schedule]
        self.taskpool = TaskPool(sched_node.schedule)
        print('task pool change',npc,self.daytype,'->',v.schedule)
        self.daytype = v.schedule
    end
end
local function RunNode(self,v,npc,mind,memory)
    if v.delay then
        Scene(function()
            cor.wait(v.delay)
            RunNodeInner(self,v,npc,mind,memory)
        end)
    else
        RunNodeInner(self,v,npc,mind,memory)
    end
end
AddTaskType('doschedule', {
    OnInit = function(self,schedule)
        self.schedule = schedule
    end,
    OnStart = function(self,npc,mind,memory) 
        self.schedule = prepare_schedule(self.schedule or npc.schedule) 
    end,
    OnUpdate = function(self,npc,mind,memory)
        --(not v.weekday or v.weekday==weekday) and 

        if self.day ~= day then
            self.daytype = nil
        end

        if not self.daytype then
            for k,v in pairs(self.schedule) do
                if v.condition and v.condition(self,npc) then
                    self.taskpool = TaskPool(v.schedule)
                    self.daytype = k
                    self.day = day 
                    break
                end
            end
        end

        if not self.taskpool then
            Fail()
        end

        for k,v in pairs(self.taskpool) do
            if v.hour==hour and v.minute == minute then

                local valid = true 

                local t = v.task
                if t then 
                    if t.is_started then
                        valid = false
                    end
                    if t==self.task then 
                        valid = false
                    end 
                end 
                
                if valid then
                    RunNode(self,v,npc,mind,memory)
                end
            end
        end 

        local node = self.task
        if node then
            local t = node.task 
            if not t.is_ended then
                t:Update(npc,mind,mind.memory)
            else
                if node.once then
                    self.taskpool = self.taskpool - node
                end
                self.task = nil 
                if t.is_complete and node.oncomplete then 
                    self.taskpool = self.taskpool + node.oncomplete
                    for k,v in pairs(node.oncomplete) do
                        if not v.hour then
                            RunNode(self,v,npc,mind,memory)
                        end
                    end 
                elseif t.is_failed and node.onfailed then  
                    self.taskpool = self.taskpool + node.onfailed
                    for k,v in pairs(node.onfailed) do
                        if not v.hour then
                            RunNode(self,v,npc,mind,memory)
                        end
                    end 
                else 
                end
                --reset
                t.is_started = false 
                t.is_ended = false 
            end
        else
            for k,v in pairs(self.taskpool) do
                if not v.hour then
                    RunNode(self,v,npc,mind,memory)
                end
            end

        end
    end, 
})  