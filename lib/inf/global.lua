
turn = turn or 0

time_callbacks = time_callbacks or {}

function EndTurn()
    turn = turn + 1
    EventActCall('end turn',turn)

    local h = math.floor(turn/60)
    local m = turn-h*60
    CallTime(m,h+1)
end

function GetTime() 
    local h = math.floor(turn/60)
    local m = turn-h*60 
    return (h+1)..':'..m
end

function At(hour,min,id,callback)
   local x = hour..':'..min 
   time_callbacks[x] = time_callbacks[x] or {}
   time_callbacks[x][id] = callback
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