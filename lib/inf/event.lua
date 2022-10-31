
global_events = {}
delayed_events = {}
function EventCall(name,...)
    local container = global_events[name] 
    if container then
        for k,f in pairs(container) do
            local status, ret = xpcall(f,error_handler,...)
            if status and ret ~= nil then
                return ret
            end
        end
    end
end
function EventAdd(name,id,callback)
    local container = global_events[name] or {}
    global_events[name] = container
    container[id] = callback
end
function EventRemove(name,id)
    local container = global_events[name]
    if container then
        container[id] = nil
    end
end
function SingleEvent(name,id,callback)
    EventAdd(name,id,function(...)
        EventRemove(name,id)
        callback(...)
    end)
end

function EventActCall(name,...)
    local r = EventCall("before "..name,...)
    if r ~= nil then return r end
    r = EventCall(name,...)
    if r ~= nil then return r end
    return EventCall("after "..name,...) 
end


function DefAction(name,callback)
    EventAdd('act_'..name,'main',callback)
end
function DoAction(name,...)
    EventCall('act_'..name,...)
end


function Delay(turns, callback)
    local target = turn + turns

    local c = delayed_events[target] or {}
    delayed_events[target] = c
    c[#c+1] = callback 
end
function InvokeDelayed()
    for k,v in pairs(delayed_events) do
        if k<=turn then
            for kk,vv in pairs(v) do
                xpcall(vv,error_handler)
            end
            delayed_events[k] = nil
        end
    end
end
EventAdd('end turn','delayed',InvokeDelayed)