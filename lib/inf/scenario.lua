
scenario_meta = scenario_meta or {}

is_scenario = false

scenario_meta.__index = scenario_meta


scenarios_person = scenarios_person or {}
scenarios_world = scenarios_world or {}
scenarios_manual = scenarios_manual or {}

scenarios_active = scenarios_active or {}



person_list = person_list or {}
person:event_add("on_init","collect_persons",function(self)
    person_list[self] = true
end)



function Scenario(id,data)
    data.id = id
    data.__index = data
    if data.target=='person' then
        scenarios_person[id] = data
    elseif data.target=='world' then
        scenarios_world[id] = data
    else
        scenarios_manual[id] = data
    end
end
function ScenarioRun(id,uid,data) 
    if not scenarios_active[uid] then
        local v = scenarios_manual[id]
        if v then
            local I = setmetatable(data,v)
            I.thread = coroutine.create(function() 
                I:process() 
            end)
            scenarios_active[uid] = I 
            return true
        end
    end
end
function Scene(callback) 
    local I = { thread = coroutine.create(callback) }
    scenarios_active[callback] = I 
    is_scenario = true
    coroutine.resume(I.thread) 
    is_scenario = false
end
 

EventAdd('end turn','scenarios',function()
    for k,v in pairs(scenarios_world) do
        local id = v.id
        if not scenarios_active[id] then
            local t = {}
            if v.condition(t) then
                local I = setmetatable(t,v)
                I.thread = coroutine.create(function()
                    I:process()
                end)
                scenarios_active[id] = I 
            end
        end
    end


    for p,_ in pairs(person_list) do 
        for k,v in pairs(scenarios_person) do 
            local id = v.id..'@'..p.id
            if not scenarios_active[id] then
                local t = {}
                if v.condition(t,p) then
                    t.target = p
                    local I = setmetatable(t,v)
                    I.thread = coroutine.create(function()
                        I:process(I.target)
                    end)
                    scenarios_active[id] = I 
                end
            end
        end
    end

    for k,v in pairs(scenarios_active) do
        local status = coroutine.status(v.thread) 
        if status=='suspended' then
            is_scenario = true
            coroutine.resume(v.thread)  --v:process(v.target) 
            is_scenario = false
            status = coroutine.status(v.thread) 
        end
        if status=='dead' then
            scenarios_active[k] = nil
        end
    end
end)

cor = {}
function cor.wait(turns)
    if is_scenario then
        local eturn = turn+turns
        while turn<eturn do
            coroutine.yield()
        end
    end
end

Scenario("changing",{
    target = 'person',--person, world,
    condition = function(self,target)
        if target:is('jade') then
            self.turn = 'turn'
            return true
        end
    end,
    process = function(self,target) 
        target:say('one',self.turn)
        cor.wait(1)
        target:say('two')
        cor.wait(2)
        target:say("three")
        cor.wait(3)
        target:say("good")
    end,
})