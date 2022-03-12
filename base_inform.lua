--[[pure lua]]

dofile('lib/script.lua')
Include("lib/string.lua")
Include("lib/table.lua")

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

Include('lib/verses/homestuck.lua')
Include('lib/verses/kaltag.lua')
Include('lib/verses/mlp.lua')
--Include('parser.lua')


person:response("hi|hello|hey",function(s,t)   
    local tr = table.random
    local name = s.memory['mind_'..t.id] or t
    s:say(tr({'hi','hello','hey'}).. tr({",",'!'}) .. tr({"",L" [name]"}))   
end)
person:response("how are you",function(s,t) 
    s:say(L"i'm [s.mood]")  
end)
person:response("who are you",function(s,t) 
    local mn = s.memory.name 
    if mn~=s.name then
        local wannalie = s.memory.swap_lie
        if wannalie==nil then
            wannalie = math.random()>0.5
            s.memory.swap_lie = wannalie
        end

        if not wannalie then
            local real_id = LocalIdentify(mn) 
            t.memory['mind_'..s.id] = real_id or mn
            if real_id then
                t.memory['mind_'..real_id.id] = s
            end
            local variation = table.random({
                "I am [mn]",
                "I am [mn] now",
                "I am... or was [mn]"})
            s:say(L(variation)) 

            return
        end 
    end

    local variation = table.random({
        "I am [s]",
        "My name is [s]"})
    s:say(L(variation))  
    
end)
person:response("follow me",function(s,t)  
    s:say("ok")  
    s.task = Task('follow',t)
end)


person:response("do",function(s,t,str)  
    local args = str:sub(4):split(' ') 
    
    local something = LocalIdentify(args[2])
    if something then
        if something:interact(s,args[1],args[3],args[4],args[5]) then
            return true 
        end 
    end

    s:act(unpack(args))
    --s:say(L"i'm [s.mood]")  
end)



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
                    for k,v in pairs(something:interact_list()) do
                        printout(L" -[k] [v.description]")
                    end
                else
                    printout('there is no '..arg1)
                end
            else
                for k,v in pairs(player:act_list()) do
                    printout(L" -[k] [v.description]")
                end
            end
        elseif com == 'z' or com=='wait' then
            return true
        elseif com == 'turn' then
            printout('turn: '..tostring(turn))
        elseif player:act_get('say') then
            local tlk = player.talk_target
            if tlk then
                player:say(full)
                if tlk.location == player.location then
                    tlk:respond(player,full)
                    return true
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





