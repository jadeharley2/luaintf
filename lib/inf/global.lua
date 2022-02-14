
client = false
player = false
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
    print_c_msg('    '..a,...)
end