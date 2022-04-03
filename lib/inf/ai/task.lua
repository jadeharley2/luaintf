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
    OnInit = function(self,target)
        self.target = target
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
                    
                end
            end
        end
    end, 
})
