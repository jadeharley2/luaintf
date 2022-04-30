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
    EventCall("task_end",self,self.npc,self.is_complete)
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

