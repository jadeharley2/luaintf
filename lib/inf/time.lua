
turn = turn or 0

year = year or 1
month = month or 1
week = week or 1
day = day or 1
hour = hour or 9
minute = minute or 0
epoch = epoch or 'CE'

weekday = 1
weekday_name = 'monday'
weekday_names = {'monday','tuesday','wednesday','thursday','friday','saturday','sunday'}
weekday_set = {monday=1,tuesday=2,wednesday=3,thursday=4,friday=5,saturday=6,sunday=7}


time_callbacks = time_callbacks or {}
hour_callbacks = hour_callbacks or {}

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
        weekday = weekday + 1
        if weekday==8 then weekday = 1 end 
        weekday_name = weekday_names[weekday]
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

function EveryHour(id,callback)
    hour_callbacks[id] = callback
end

local lasthour = -1
function CallTime(min,hour)
    local x = hour..':'..min 
    local u = time_callbacks[x]
    if u then 
        for k,v in pairs(u) do
            v()
        end 
    end 
    if lasthour~=hour then
        lasthour = hour 
        for k,v in pairs(hour_callbacks) do
            v(hour)
        end
    end
end


function SkyColor(hour)
    if hour>22 or hour < 3 then return "#131d38" end
    if hour == 3 then  return "#1f2d53" end --return "#4d3d2d" end
    if hour == 4 then  return "#2a3d6e" end --return "#71523e" end 
    if hour == 5 then  return "#70545a" end --return "#b66c45" end
    if hour == 6 then  return "#ff8a56" end --return "#ba7e38" end
    if hour == 7 then  return "#ffaa56" end --return "#7c7d75" end
    if hour == 8 then  return "#fed078" end --return "#627ea3" end
    if hour == 9 then  return "#ffefd1" end --return "#6793b8" end
    if hour == 10 then return "#ffffff" end --return "#72b0d7" end
    if hour == 11 then return "#ffffff" end --return "#a1cfe9" end
    if hour == 12 then return "#ffffff" end --return "#aed8f0" end
    if hour == 13 then return "#ffffff" end --return "#b3d9ee" end
    if hour == 14 then return "#ffffff" end --return "#a7d1e9" end
    if hour == 15 then return "#ffffff" end --return "#70b2d4" end
    if hour == 16 then return "#ffefd1" end --return "#779cb9" end
    if hour == 17 then return "#fed078" end --return "#7f90ac" end
    if hour == 18 then return "#ffaa56" end --return "#868269" end
    if hour == 19 then return "#ff8a56" end --return "#ad7739" end
    if hour == 20 then return "#70545a" end --return "#a7613d" end
    if hour == 21 then return "#2a3d6e" end --return "#6a4b37" end
    if hour == 22 then return "#1f2d53" end --return "#413026" end
end

function TestOutdoorStyle(hour)
    local color = SkyColor(hour)
    return "background-color: "..color.." ,background-blend-mode: multiply;" 
end