--[[pure lua]]

dofile('lib/script.lua')
Include("lib/string.lua")

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


Include('kaltag.lua')
--Include('parser.lua')

jade = Def('jade','person')
aradia = Def('aradia','person')


MakeRelation(jade,aradia,likes)

jade_room = Def('jade_room',{},'room')
jade_room._get_name = LF[[[IF(player==jade,"My","Jade's")] room]]

aradia_room = Def('aradia_room',{},'room')
aradia_room._get_name = LF[[[IF(player==aradia,"My","Aradia's")] room]]
--
    --function(s) return IF(player==jade,"My room","Jade's room") end
--[[ function(s) 
    if player==jade then
        return "My room"
    else
        return "Jade's room"
    end
end]]
chamber = Def('chamber',{name = "Chamber"},'room')
chamber.on_enter = function(s,t) print('welcome',t) end
MakeRelation(jade_room,chamber,direction_down)

upper_hall = Def('upper_hall',{name = "Upper hall"},'room')
MakeRelation(upper_hall,chamber,direction_east)
MakeRelation(upper_hall,aradia_room,direction_north)

garden_c = Def('garden_c',{name = "Central garden atrium"},'room')
garden_w = Def('garden_w',{name = "West garden atrium"},'room')
garden_s = Def('garden_s',{name = "South garden atrium"},'room')
garden_n = Def('garden_n',{name = "North garden atrium"},'room')
garden_e = Def('garden_e',{name = "East garden atrium"},'room')
MakeRelation(garden_c,upper_hall,direction_up)
MakeRelation(garden_c,garden_w,direction_west)
MakeRelation(garden_c,garden_e,direction_east)
MakeRelation(garden_c,garden_n,direction_north)
MakeRelation(garden_c,garden_s,direction_south)


local ajd = jade_room:adjascent(true)


jade:adj_set({"nerdy","female"})  

aradia:adj_set({"gothic","female"})  

jade.location = jade_room
aradia.location = jade_room
person.mood = "ok"

local all = jade:adj_getall()

print('jade is female - ',jade:is('female'))
print('jade is person - ',jade:is('person'))
print('jade is thing - ',jade:is('thing'))
print('jade is male - ',jade:is('male'))
print('jade description - ',jade.description)
print('jade location - ',jade.location)


keytar = Def("keytar","thing")
keytar.location = jade_room


person:response("hi|hello|hey",function(s,t)  
    s:say(table.random({'hi','hello','hey'}).. table.random({",",'!'}) .. table.random({"",L" [t]"}))   
end)
person:response("how are you",function(s,t) 
    s:say(L"i'm [s.mood]")  
end)



jade:response("bodyswap",function(s,t) 
    s:say("what is it?") 
    s:response("i want to swap with you",function(s,t) 
        s:say("i like your idea") 

        s:say("i dont like this") 
        
        s:say("how?") 
    
    end,true)
end)


no_one = Def('no_one','person')
no_one:act_add(be_action)
no_one.examine = function() 
    printout("use be *name* to become that character") 
    printout("available characters:") 
    for k,v in pairs(defines) do
        if v:is(person) and v.location ~= nowhere and not players[v] then
            printout(L"  > [v.name] at [v.location]")
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
    if result then 
        return true
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
            player = c.person or player

            local args = input:split(' ')
            local aliased = {ComAlias(unpack(args))}
            if parse(input,unpack(aliased)) then
 
                EndTurn()

            end
            c.person = player
            client = false
        end)  
    end
end


 








main_server()
--main()





