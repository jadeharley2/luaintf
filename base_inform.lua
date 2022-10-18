--[[pure lua]]

dofile('lib/script.lua')
Include("lib/math.lua")
Include("lib/string.lua")
Include("lib/table.lua")
Include("lib/io.lua")

--Include("mclr/dsearch.lua")

Include("lib/net.lua")

if not IS_MOBILE then 
    winapi = require 'winapi'
    Include('lib/win.lua')
end 

--[[
    - kinds and objects of kind
    - adjectives
    - events|rules and hooks|rulebooks
    - relations 
    - actions - interaction with world
    - aliases|understand command
]]
Include('lib/inf/init.lua')

Include("testyarn.lua")

Include('lib/defines/space.lua')
Include('lib/defines/moving_cabin.lua')
Include('lib/defines/costume.lua')
Include('lib/defines/furniture.lua')
Include('lib/defines/misc.lua')

Include('verses/homestuck/init.lua')
Include('verses/kaltag/init.lua')
Include('verses/mlp/init.lua')
Include('verses/rpg/init.lua')



--Include('parser.lua')
warp_c = Def('warp_c',{name = "Subspace Central"},'room')
warp_c.image = '/img/background/space_dark.png'

warp_mlp = Def('warp_mlp',{name = "Subspace mlp"},'room')
warp_fk = Def('warp_fk',{name = "Subspace fk"},'room')
warp_hs = Def('warp_hs',{name = "Subspace hs"},'room')
warp_mlp.image = '/img/background/space_dark.png'
warp_fk.image = '/img/background/space_dark.png'
warp_hs.image = '/img/background/space_dark.png'

MakeRelation(warp_c,warp_mlp,direction_east)
MakeRelation(warp_c,warp_fk,direction_west)
MakeRelation(warp_c,warp_hs,direction_south)

local p1 = Inst('portal') p1.location = warp_hs 
local p2 = Inst('portal') p2.location = rose_forest
MakeRelation(p1,p2,portal_link)

local p1 = Inst('portal') p1.location = warp_fk
local p2 = Inst('portal') p2.location = engine_room
MakeRelation(p1,p2,portal_link)

local p1 = Inst('portal') p1.location = warp_mlp
local p2 = Inst('portal') p2.location = castle_library
MakeRelation(p1,p2,portal_link)



Inst('spell_book').location = rose_room




no_one:act_add(be_action)
no_one.examine = function() 
    printout("use be *name* to become that character") 
    printout("available characters:") 
    local loc_u = {}
    for k,v in pairs(defines) do
        if v:is(person) and v.location ~= nowhere and not players[v] then
            local u = v.universe
            if u then
                local lu = loc_u[u] or {} 
                lu[#lu+1] = v
                loc_u[u] = lu
            end
        end
    end
    local chars = {}
    for k,v in pairs(loc_u) do
        printout(L"  [k.name]")
        for kk,vv in ipairs(v) do
            if not vv.npc then
                printout(L"    >'be [vv.id]' [vv.name] at [vv.location]")
                chars[vv.id] = 'be '..vv.id
            end
        end
    end
    local c2 = {}
    for k,v in SortedPairs(chars) do
        c2[#c2+1] = v
    end
     
    printout('$actions:',table.concat(c2, ';'))
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
    
    if arg1 then
        local something = ReachableIdentify(arg1)
        if something then
            if something:interact(player,com,arg2,arg3,...) then
                return true 
            end 
        end
    end

    local result = player:act(com,arg1,arg2,arg3,...)
    if result~=nil then 
        return result
    else
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
                local something = LocalIdentify(arg1) or LocalIdentify(arg1,player)
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


--local test0 = jade.mind:memory_tostring()
--for k,v in ipairs(test0) do
--    print(v)
--end


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

is_running = is_running or false
timescale = timescale or 1
function main_server()
    if is_running then return end 
    is_running = true 

    print('ok server!')
    net.start('localhost',9999)
    local nextcheck = 0
    local update_files = {}
    if winapi then
        local LAST_WRITE,FILE_NAME =
                winapi.FILE_NOTIFY_CHANGE_LAST_WRITE,
                winapi.FILE_NOTIFY_CHANGE_FILE_NAME
        local dir = string.sub(arg[0],1,-12)
        local wtch,err =winapi.watch_for_file_changes(dir,LAST_WRITE+FILE_NAME,true,function(ch,fn)
            if not string.starts_with(fn,'.') and string.ends_with(fn,'.lua') then
                print('file changed',ch,fn) 
                update_files[fn] = true
            end
        end)
        print('filesystem watcher',dir,wtch,err)
    end

    EventAdd('end turn','status update',function(turn)
        for k,v in pairs(players) do
            v:send(L'$status:turn [turn] time [GetTimeDate()] \n')
            if (v.nextturn or 0)<=turn then
                v:send(L'$unblock:\n')
            end
        end
    end)

    
    EventAdd('end turn','sleep timescale',function(turn)
        local asleep = 0
        local awake = 0
        for k,v in pairs(players) do
            if v.person and v.person~=no_one then
                if v.person:is("asleep") then
                    asleep=asleep+1
                else
                    awake=awake+1
                end
            end
        end
        if awake==0 and asleep>0 then
            timescale = timescale + (0.1-timescale)*0.2
        else
            timescale = 1
        end
    end)
    
    EventAdd('player_connected','init',function(c)
        client = c
        player = c.person or no_one  
        print('$display:target;clear')
        print('$display:background;clear')
        print('$display:line;clear')
        print('$display:clothes;clear')
        examine(player)
        c.person = player
        client = false
    end)
    EventAdd('player_disconnected','init',function(c)
        if players[c.person]==c then
            players[c.person] = nil
        end
        print(c.person,'leaves')
    end)
    
    while true do
        net.accept()

        net.receive(function(c,input)
            if (c.nextturn or 0)<=turn then
                SETPLAYER(c) 

                local args = input:split(' ')
                local aliased = {ComAlias(unpack(args))}
                if parse(input,unpack(aliased)) then
    
                -- EndTurn()
                c.nextturn = turn+1
                printout("$block:")
                end
                c.person = player
                SETPLAYER() 
            end
        end)  
        
        local ctime = os.clock()
        if nextcheck<ctime then
            net.check()
            nextcheck = ctime + timescale
            EndTurn()
        end

        if winapi then
            winapi.sleep(1)

            for k,v in pairs(update_files) do
                update_files[k] = nil
                Include(k)
            end
        end
    end
end


 

--testing 


--main_server()
--main()





