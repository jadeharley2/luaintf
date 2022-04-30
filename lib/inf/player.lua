
players = players or {}


client = false
player = false
personality = false


function SETPLAYER(C,per)
    if C then
        client = C 
        player = C.person or no_one
        personality = player.personality or player
    else
        client = false
        player = per
        personality = false 
    end
end
function SETPERSON(P)
    if P then 
        player = P 
        client = P.player
        personality = P.personality or P
    else
        client = false
        player = false
        personality = false
    end
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

function printto(target,a,a1,a2,a3,a4,a5,a6)
    if target:is(room) then
        target:foreach("contains",function(k,v)
            if k.player then
                printto(k,a,a1,a2,a3,a4,a5,a6)
            end
        end)
    else
        local client = target.player
        if client then
            local t = {'   ',a,a1,a2,a3,a4,a5,a6}
            for k,v in pairs(t) do
                t[k] = tostring(v)
            end
            t[#t+1] = '\n'
            client:send(table.concat(t,' '))
        end
    end
    if a:sub(1,1)~='$' then
        print_c_msg('    '..a,a1,a2,a3,a4,a5,a6)
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
function send_style(person,override)
    local ply = person.player
    local sty = override or person.view_style_css
    if ply and sty then 
        ply:send('$style:'..sty..'\n');
    end
end

function others_action(doer,callback)
    local cp = player 
    local cc = client

    for k,v in pairs(players) do
        local loc = doer.location
        if k~=doer and k.location == loc then
            --player = k
            --client = v
            SETPLAYER(v)
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
            --player = k
            --client = v
            SETPLAYER(v)
            callback(k,v)
        end
    end 


    player = cp 
    client = cc 
end




thing._get_player = function(self)
    return players[self]
end
thing._set_player = function(self,val)
    local oldp = players[self]
    if oldp then
        oldp.person = nil 
    end

    players[self] = val
    if val then
        val.person = self 
    end
end
