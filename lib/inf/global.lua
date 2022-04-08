
turn = turn or 0

year = year or 1
month = month or 1
week = week or 1
day = day or 1
hour = hour or 0
minute = minute or 0
epoch = epoch or 'CE'



time_callbacks = time_callbacks or {}

function EndTurn()
    turn = turn + 1
    EventActCall('end turn',turn)

    AdvanceTime()
    CallTime(minute,hour)
end
function AdvanceTime()
    minute = minute + 1 
    if minute>=60 then
        hour = hour + 1
        minute = 0
    end
    if hour >=24 then
        day = day + 1
        hour = 0
    end
    if day >30 then
        month = month + 1
        day = 1
    end
    --if week>4 then
    --    month = month + 1
    --    week = 1
    --end
    if month > 12 then
        year = year + 1
        month = 1
    end 
end

function GetTime()  
    return hour..':'..minute
end
function GetTimeDate()  
    return L"[hour]:[minute] [day].[month].[year] [epoch]"
end

function At(hour,min,id,callback)
   local x = hour..':'..min 
   time_callbacks[x] = time_callbacks[x] or {}
   time_callbacks[x][id] = callback
end
function Every(seconds)
end

function CallTime(min,hour)
    local x = hour..':'..min 
    local u = time_callbacks[x]
    if u then 
        for k,v in pairs(u) do
            v()
        end 
    end 
end

--:say('ok!')
for k=1,10 do 
    At(k,12,'test1',function()
        nepeta.task = Task('moveto',jade_room)
    end)
    At(k,22,'test1',function()
        nepeta.task = Task('moveto',garden_e)
    end)
    At(k,32,'test1',function()
        nepeta.task = Task('moveto',aradia_room)
    end)

    
    At(k,42,'test1',function()
        nepeta.task = Task('moveto',jade_room)
    end)
    At(k,50,'test1',function()
        nepeta.task = Task('moveto',garden_e)
    end)
    At(k,58,'test1',function()
        nepeta.task = Task('moveto',aradia_room)
    end)
end