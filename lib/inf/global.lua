
client = false
player = false
personality = false

players = {}
turn = 0

function EndTurn()
    turn = turn + 1
    EventActCall('end turn',turn)
end

function printout(a,...)
    if client then
        local t = {'   ',a,...}
        for k,v in pairs(t) do
            t[k] = tostring(v)
        end
        t[#t+1] = '\n'
        client:send(table.concat(t,' '))
    end
    if a:sub(1,1)~='$' then
        print_c_msg('    '..a,...)
    end
end

function describe_action(doer,desc_doer,desc_other,everywhere)

    if doer==player then
        if desc_doer then printout(desc_doer) end
    end
    if desc_other then
        if everywhere then
            net.broadcast(desc_other,players[doer])
        else--if player.location==doer.location then
            local loc = doer.location
            for k,v in pairs(players) do
                if k~=doer and k.location == loc then
                    if v then
                        v:send(desc_other..'\n')
                    else--single
                        printout(desc_other..'\n')
                    end
                end
            end 
        end 
    end
end

function others_action(doer,callback)
    local cp = player 
    local cc = client

    for k,v in pairs(players) do
        local loc = doer.location
        if k~=doer and k.location == loc then
            player = k
            client = v
            callback(k,v)
        end
    end 


    player = cp 
    client = cc 
end
function location_action(location,callback)
    local cp = player 
    local cc = client

    for k,v in pairs(players) do 
        if k.location == location then
            player = k
            client = v
            callback(k,v)
        end
    end 


    player = cp 
    client = cc 
end