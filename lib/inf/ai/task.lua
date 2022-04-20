task_types = task_types or {}

task_meta = task_meta or {}


function task_meta:Init(...)
    self:OnInit(...) 
end

function task_meta:Start(npc,mind,memory)
    self.npc = npc
    self.is_started = true
    self:OnStart(npc,mind,memory)
end
function task_meta:Update(npc,mind,memory)
    self:OnUpdate(npc,mind,memory)
end
function task_meta:Complete()
    self.is_complete = true
    self:End()
end
function task_meta:Fail()
    self.is_failed = true 
    self:End()
end
function task_meta:End() 
    self.is_ended = true
    local mind = rawget(self.npc,'mind')
    if mind and mind~=no_mind then
        self:OnEnd(self.npc,mind,mind.memory)
    end
    if self.is_complete then
        if self.next_on_completed then
            self.npc.task = self.next_on_completed
        end
    else
        if self.next_on_failed then
            self.npc.task = self.next_on_failed
        end
    end
end

function task_meta:OnInit() end
function task_meta:OnStart() end
function task_meta:OnUpdat() end
function task_meta:OnEnd() end

function task_meta:Add(task)
    self.subs = self.subs or {}
    self.subs[#self.subs+1] = task
end

function task_meta:Next(task)
    self.next_on_completed = task
    self.next_on_failed = task
end
function task_meta:NextCompleted(task)
    self.next_on_completed = task 
end
function task_meta:NextFailed(task)
    self.next_on_failed = task 
end
function task_meta:is(t)
    return self.class == t 
end



task_meta.__index = task_meta


function AddTaskType(typename,table) 
    for k,v in pairs(task_meta) do
        if table[k]==nil then
            table[k] = v
        end
    end
    table.class = typename
    table.__index = table
    task_types[typename] = table
end

function Task(type,...)
    local x = setmetatable({},task_types[type])
    x:Init(...)
    return x
end

--test!

AddTaskType('shout', {
    OnInit = function(self,shout)
        self.shout = shout or 'some shout!'
    end,
    OnStart = function(self,npc,mind,memory)
        npc:response('stop it',function()
            npc:say('ok! ok!')
            self:Complete()
            return true
        end)
        npc:say('im started! '..self.shout)
    end,
    OnUpdate = function(self,npc,mind,memory)
        npc:say('im updated! '..self.shout)
    end,
    OnEnd = function(self,npc,mind,memory)
        npc:say('im ended! '..self.shout)
    end,
})
AddTaskType('follow', {
    OnInit = function(self,target)
        self.target = target
    end,
    OnStart = function(self,npc,mind,memory)
        npc:response('stop following',function()
            npc:say('ok!')
            self:Complete()
            return true
        end) 
    end,
    OnUpdate = function(self,npc,mind,memory)
        local loc = npc.location
        local tloc = self.target.location
        if loc~=tloc then
            local d = loc:direction_to(tloc)
            if d then
                npc:act('move',d)
            else
                loc:first('contains',function(v)
                    if v:is(portal) then
                        local o = v:other_side()
                        if o and o.location == tloc then
                            v:interact(npc,'trough')
                        end
                    end
                end)
                
                --idk where to go!
            end
        end
    end, 
})

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

local function astar(srcroom,trgroom)
    local open = {{c=srcroom,l={}}}
    local closed = {}

    for u=1,100 do
        local newopen = {}
        for k,seq in pairs(open) do
            local last = seq.c
            for k2,v2 in pairs(last:adjascent(true)) do 
                if v2==trgroom then
                    seq.l[#seq.l+1] = k2
                    return seq.l
                elseif not closed[v2] then
                    local l2 = table.copy(seq.l)
                    l2[#l2+1] = k2

                    newopen[#newopen+1] = {c=v2,l=l2}
                end
            end
            closed[last] = true
        end
        if #newopen==0 then 
            return 
        end
        open = newopen
    end
end

AddTaskType('moveto', {
    OnInit = function(self,target,fail_tolerance)
        self.target = target
        self.fail_tolerance = fail_tolerance or 999999
    end,
    OnStart = function(self,npc,mind,memory) 
    end,
    OnUpdate = function(self,npc,mind,memory)
        local loc = npc.location
        local tloc = self.target 
        if loc~=tloc then
            local path = astar(loc,tloc)
            if path then
                local d = path[1]
                if d then
                    npc:act('move',d)
                else 
                    self.fail_tolerance = self.fail_tolerance - 1
                    if self.fail_tolerance<0 then
                        self:Fail()
                    end
                end
            end
        else
            self:Complete()
        end
    end, 
})

AddTaskType('act', {
    OnInit = function(self,action,...)
        self.action = action
        self.arguments  = {...}
    end,
    OnStart = function(self,npc,mind,memory) 

        local args = self.arguments

        if #args>0 then
            local target = self.arguments[1]
            local something = LocalIdentify(target,npc.location) or LocalIdentify(target,npc)
            if something then
                local result = something:interact(npc,self.action,args[2],args[3],args[4])
                if result~=nil then
                    if result then
                        self:Complete()
                    else
                        self:Fail()
                    end
                    return
                end 
            end
        end 

        if npc:act(self.action,unpack(args)) then
            self:Complete()
        else
            self:Fail()
        end
    end,
    OnUpdate = function(self,npc,mind,memory)
    end, 
})

