--[[pure lua]]

dofile('lib/script.lua')
Include("lib/string.lua")
Include("lib/table.lua")

--Include("mclr/dsearch.lua")

Include("lib/net.lua")

winapi = require 'winapi'
Include('lib/win.lua')

--[[
    - kinds and objects of kind
    - adjectives
    - events|rules and hooks|rulebooks
    - relations 
    - actions - interaction with world
    - aliases|understand command
]]
Include('lib/inf/init.lua')

Include('lib/defines/space.lua')
Include('lib/defines/misc.lua')
Include('lib/defines/moving_cabin.lua')

Include('lib/verses/homestuck/init.lua')
Include('lib/verses/kaltag/init.lua')
Include('lib/verses/mlp.lua')
--Include('parser.lua')



no_one:act_add(be_action)
no_one.examine = function() 
    printout("use be *name* to become that character") 
    printout("available characters:") 
    local loc_u = {}
    for k,v in pairs(defines) do
        if v:is(person) and v.location ~= nowhere and not players[v] then
            local u = v.universe
            local lu = loc_u[u] or {} 
            lu[#lu+1] = v
            loc_u[u] = lu
        end
    end
    for k,v in pairs(loc_u) do
        printout(L"  [k.name]")
        for kk,vv in ipairs(v) do
            printout(L"    >'be [vv.id]' [vv.name] at [vv.location]")
        end
    end
end

player = no_one


--for k=1,100 do
--
--    local wat = L[[test string with [player] and [player.description] huh [2+3+k]?]]
--    print(wat)
--
--end

function parse(full,com,arg1,arg2,arg3,...)
    --[[
        if direction_map[com] then
            local loc = player.location
            if loc:is(room) then
                local next = loc:dir(com)
                if next then
                    player.location = next
                    examine(next)
                    return true
                else
                    printout("you can't go that way")
                end
            else
                printout("you can't move")
            end
        elseif com=='l' or com=='look' then
            examine(player.location) 
            return true
        elseif com=='x' or com=='examine' then
            if not arg1 then 
                examine(player)
                return true
            elseif arg1=='self' then
                printout('examine self')
                examine(player)
                return true
            else 
                local v = LocalIdentify(arg1)
                if v then
                    examine(v)
                    return true
                else
                    printout('there is no '..arg1)
                end
            end
        elseif com=='take' then
            if arg1 then
                local something = LocalIdentify(arg1)
                if something then
                    something.location = player
                    printout(arg1..' taken')
                else
                    printout('there is no '..arg1)
                end 
            else
                printout('take what?')
            end
        elseif com=='drop' then
            if arg1 then
                local something = LocalIdentify(arg1,player)
                if something then
                    something.location = player.location
                    printout(arg1..' dropped')
                else
                    printout('there is no '..arg1)
                end 
            else
                printout('drop what?')
            end

    ]]
    
    local result = player:act(com,arg1,arg2,arg3,...)
    if result~=nil then 
        return result
    else
        local something = LocalIdentify(arg1)
        if something then
            if something:interact(player,com,arg2,arg3,...) then
                return true 
            end 
        end
        --if com == 'be' then 
        --    local v = Identify(arg1)
        --    if v and v:is(person) then
        --        players[player] = nil
        --        player = v 
        --        players[player] = client
        --        printout('you are now',v)
        --        return true
        --    end
       --elseif com=='talk' then
       --    local something = LocalIdentify(arg1)
       --    if something and something~=player then
       --        if something:is(person) then
       --            player.talk_target = something 
       --            printout('you are now talking to ',something)
       --            return true
       --        end
       --    end 
        --else
        if com == 'actions' then
            if arg1 then
                local something = LocalIdentify(arg1)
                if something then
                    printout('interactions for '..something.name)
                    for k,v in SortedPairs(something:interact_list()) do
                        printout(L" -[k] [v.description]")
                    end
                else
                    printout('there is no '..arg1)
                end
            else
                for k,v in SortedPairs(player:act_list()) do
                    printout(L" -[k] [v.description]")
                end
            end
        elseif com == 'z' or com=='wait' then
            printout('time passes..')
            return true
        elseif com == 'turn' then
            printout('turn: '..tostring(turn))
        elseif player:act_get('say') then
            local tlk = player.talk_target
            if tlk then
                player:say(full)
                if tlk.location == player.location then
                    if not tlk:adj_isset('asleep') then
    --                   tlk:respond(player,full)
                        tlk:intent_respond(player,full)
                        return true
                    end
                end
            else
                local something = LocalIdentify(com)
                if something and something~=player then
                    if something:is(person) then
                        player.talk_target = something 
                        printout('you are now talking to ',something)
                        return true
                    end
                end 
            end
        end
    end
end






function main()
    print('ok!')
    while true do
        local input = io.read():trim()
        if #input>0 then 
            local args = input:split(' ')
            
            local aliased = {ComAlias(unpack(args))}

            if parse(input,unpack(aliased)) then
 
                EndTurn()

            end
        end 
    end
end


function main_server()
    print('ok server!')
    net.start('localhost',9999)
    while true do
        net.accept()

        net.receive(function(c,input)
            client = c
            player = c.person or no_one
            personality = player.personality or player

            local args = input:split(' ')
            local aliased = {ComAlias(unpack(args))}
            if parse(input,unpack(aliased)) then
 
                EndTurn()

            end
            c.person = player
            client = false
        end)  
        EventAdd('player_connected','init',function(c)
            client = c
            player = c.person or no_one 
            examine(player)
            c.person = player
            client = false
        end)
    end
end


 

--testing 


--main_server()
--main()





