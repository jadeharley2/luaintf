
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
        client.socket:send(table.concat(t,' '))
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
            for k,v in pairs(players) do
                if k~=doer and k.location == doer.location then
                    if v then
                        v.socket:send(desc_other..'\n')
                    else--single
                        printout(desc_other..'\n')
                    end
                end
            end 
        end 
    end
end