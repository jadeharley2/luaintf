local operation = {}
--state, operation

--operation(state) -> new state

--goal - state

local function move_arghash(loc,dir)
    return tostring(loc)..'move'..dir
end
local function arghash(loc,key,dir)
    return tostring(loc)..key..dir
end
local function checknotset(t,key)
    if not t[key] then
        t[key] = true 
        return true
    end
end
local movement_variations = {
    move = {
        argcount = 1,
        act = function(state,args)
            local loc = state.location
            local nloc = loc[args[1]]
            if nloc then
                state.location = nloc
                state.location_name = nloc.name
                return true
            end  
        end,   

        get_arg = {
            function(state,closed)
                local loc = state.location
                local r ={}
                if loc.n and checknotset(closed,arghash(loc,'move','n')) then r[#r+1] = 'n' end
                if loc.w and checknotset(closed,arghash(loc,'move','w')) then r[#r+1] = 'w' end
                if loc.s and checknotset(closed,arghash(loc,'move','s')) then r[#r+1] = 's' end
                if loc.e and checknotset(closed,arghash(loc,'move','e')) then r[#r+1] = 'e' end
                return r
            end,
        }, 
    },
}
local directions = {'w','e','n','s'}
local variations = {
    move = {
        argcount = 1,
        norepetitions = true,
        act = function(state,args)
            local loc = state.location
            local nloc = args[1]
            
            local path = get_possible_states(movement_variations,state,{location_name = nloc})
            
            if path and #path>0 then
                for k,v in ipairs(path) do
                    movement_variations[v.act].act(state,v.args)
                end
                --state.location = nloc
                return true
            end  
        end,   

        get_arg = {
            function(state,closed) 
                local loc = state.location
                local open = {loc}
                local closed = {}
                for k=1,10 do
                    local newopen = {}
                    for _,U in pairs(open) do
                        closed[U] = true 

                        for kk,vv in ipairs(directions) do
                            local nxt = U[vv]
                            if nxt then
                                if checknotset(closed,arghash(nil,'move',nxt.name)) then 
                                    newopen[#newopen+1] = nxt
                                end
                            end
                        end
                    end
                    open = newopen
                end
                local args = {}
                for k,v in pairs(closed) do
                    args[#args+1] = k.name
                end
                return args
            end,
        },
        --filter = function(state,args, closed)
        --    local loc = state.location
        --    local dir = args[1]
        --    local hash = tostring(loc)..'move'..dir
        --    if not closed[hash] then
        --        closed[hash] = true
        --        return true 
        --    end
        --end
    },
    take = {
        argcount = 1,
        act  = function(state,args)
            local loc = state.location
            local id = args[1]
            if loc.contains then
                for k,v in pairs(loc.contains) do
                    if v.name==id then
                        loc.contains[k] = nil
                        for kk=1,state.inventory_size do 
                            local key = 'inventory_'..kk
                            if kk>1 then
                                local lLOAL = 0
                            end
                            if not state[key] then 
                                state[key] = v
                                return true 
                            end
                        end
                    end
                end
            end
        end,  
        get_arg = {
            function(state,closed)
                local loc = state.location
                local r ={}
                if loc.contains then
                    for k,v in pairs(loc.contains) do
                        --if checknotset(closed,arghash(loc,'take',v.name)) then 
                            r[#r+1] = v.name
                        --end 
                    end
                end
                return r
            end,
        },
    },
    wear = {
        argcount = 1,
        act  = function(state,args) 
            local id = args[1]
            local key = 'inventory_'..id
            local item = state[key]
            if item then
                local slot = item.slot 
                state[key] = false
                state['equipped_'..slot] = item
                return true
            end 
        end,  
        get_arg = {
            function(state,closed)
                local r ={}
                for kk=1,state.inventory_size do 
                    local item = state['inventory_'..kk]
                    if item then
                        --if checknotset(closed,arghash(loc,'wear',item.name)) then 
                            r[#r+1] = kk
                        --end 
                    end
                end
                return r
            end,
        },
    }
}
 

function check_goal(state,goal)
    local score = 0
    local count = 0
    for k,v in pairs(goal) do
        if state[k] == v then
            score = score + 1--return false
        end
        count = count + 1
    end
    return score/count
end

function get_possible_states(variations,start,goal,debug)--,actions,closed) 
    --actions = actions or {}

    local open = {{state = start, actions = {},closed = {}}} 

    local maxscore = 0
    
    while true do 
        local nextstates = {}
        if #open>0 then
            for _,V in pairs(open) do
                local actions = V.actions 
                local state = V.state
                local closed = V.closed

                for k,v in pairs(variations) do

                    local fine = true
                    if v.norepetitions then
                        local lastact = actions[#actions]
                        if lastact and lastact.act==k then
                            fine =false 
                        end 
                    end
                    
                    if fine then
                        local args = {}
                        for k1=1,v.argcount do 
                            args[k1] = v.get_arg[k1](state,closed) 
                        end
                        if #args>0 then
                            local perm = table.permutations(unpack(args))
                            for k1,args in pairs(perm) do 
                                if v.filter == nil or v.filter(state,args,closed) then 

                                    local newstate = table.copy(state)
                                    if v.act(newstate,args) then
                                        local newactions = table.copy(actions)
                                        newactions[#newactions+1] = {
                                            act = k,
                                            args = args, 
                                        }
                                        local goal_score = check_goal(newstate,goal)
                                        if goal_score >= 1 then
                                            return newactions
                                        else
                                            if goal_score>maxscore then
                                                maxscore = goal_score
                                            end 
                                            nextstates[#nextstates+1] = {state = newstate, actions = newactions, closed = table.copy(closed), score = goal_score}
                                            --local r = get_possible_states(newstate,goal,newactions,closed)
                                            --if r then return r end
                                        end 
                                    end
                                else
                                    local fhag = 0
                                end
                            end
                        else
                            local faF= 0
                        end
                        --a = {1,2,3}
                        --b = {a,b,c}
                        --r = {1,a},{1,b},
                    end
                end
            end

            open ={}
            for k,v in ipairs(nextstates) do 
                if v.score>=maxscore then
                    open[#open+1] = v
                end 
            end
            --open = nextstates
            if debug then
                print('new #open',#open)
                for k,v in ipairs(open) do
                    print(table.concat(strfy(v.actions),'->'))
                end
                local afaf = 0
            end


        else
            return false
        end
    end

    return nil
end

function strfy(t)
    local r = {}
    for k,v in ipairs(t) do
        r[k] = v.act..'('..table.concat(v.args,', ')..')'
    end
    return r
end

local function lnk(a,b,c,d)
    a[c] = b 
    b[d] = a
end

local cloth1 = {name='cloth1',slot = 'body'}
local cloth2 = {name='cloth2',slot = 'legs'}
local cloth3 = {name='cloth3',slot = 'head'}

local room1 = {name='R1'}
local room2 = {name='R2'}
local room3 = {name='R3'}
local room4 = {name='R4'}
local room5 = {name='R5'}
local room6 = {name='R6'}

lnk(room1,room2,'w','e')  
lnk(room2,room3,'w','e') 
lnk(room2,room4,'n','s')  
lnk(room4,room5,'n','s')  
lnk(room5,room6,'w','e')  
--[[

    6 - 5
        |
        4   
        |
    3 - 2 - 1

]]

room1.contains = {cloth3}
room4.contains = {cloth1} 
room6.contains = {cloth2}

local test_state = {
    location = room1, 
    inventory_size = 10,
}
local goal_state = { 
    inventory_1 = cloth1,
    inventory_2 = cloth2,
}
 





local result = strfy(get_possible_states(variations,test_state,goal_state,true) or {})

local UU = 325
local ua=0
