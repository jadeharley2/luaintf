
local PMETA = {}  
function PMETA:Add(k,val)
    local v = rawget(self,'_'..k)
    if v then
        local t = type(v) 
        if t=='table' then
            v[#v+1] = val
        else
            rawset(self,'_'..k,{v,val})
        end
    else
        rawset(self,'_'..k,val)
    end
end
local add = PMETA.Add
PMETA.__index = function(t,k)
    if k=='Add' then return add end
    local v = rawget(t,'_'..k) 
 
    local t = type(v)
    if t=='function' then
        return v()
    elseif t=='table' then 
        local x = table.random(v)
        if type(x) == 'function' then
            return x()
        else
            return x
        end 
    elseif t=='string' then
        return v
    end 
end

P = setmetatable({},PMETA)


P:Add('greet','hi') 
P:Add('greet','hello') 
P:Add('greet','hey') 
P:Add('greet','hey[!|,] [name]')  
 
P:Add('greet_robotic','hello') 
P:Add('greet_robotic','greetings') 
P:Add('greet_robotic','awaiting orders') 
P:Add('greet_robotic','unit [myname] awaiting orders') 
P:Add('greet_robotic','does [name] needs assistance?') 
  
 
 
--local u = P.greet

local name = 'uuuu'
local test00 =L2"[P.greet]"
local name = 'lel'
local test01 =L2"[P.greet]"

--[[
person:response("hi|hello|hey",function(s,t)   
    local tr = table.random
    local name = s.memory['mind_'..t.id] or t
    local myname = s.memory.name or s.name
    if s.robotic then
        --local  variation = table.random({
        --    "hello [name]",
        --    "greetings [name]",
        --}) 
        s:say(L2"[P.greet_robotic]")  
    else
        s:say(L2"[P.greet]") 
        --s:say(tr({'hi','hello','hey'}).. tr({",",'!'}) .. tr({"",L" [name]"})) 
    end
end)
]]
P:Add('mood',"I'm [mood]") 
P:Add('mood',"I feel [mood]")  

P:Add('mood_robotic',"this unit does not [simulate emotions|have sentiment programming]")  
P:Add('mood_robotic',"sentiment module is not installed on this frame") 

P:Add('name') 

person:response("how are you",function(s,t) 
    local variation
    if s.robotic then
        s:say(L2"[P.mood_robotic]") 
    else
        local mood = s.mood
        s:say(L2"[P.mood]") 
    end
end)


person:response("who are you",function(s,t) 
    local mn = s.memory.name 
    if mn~=s.name then 
        if not s.memory.swap_lie then
            local variation
            if math.random()>0.6 then

                if s.robotic then
                    variation = table.random({
                        "this unit old designation is [mn]",
                        "this copy na-signation was [mn]",
                        "statement. this unit previous designation is [mn]", 
                    })
                else
                    variation = table.random({
                        "I am [mn]", 
                        "I was [mn]",
                        "I was [mn]. Now I am [s]",
                        "I am... or was [mn]"})
                end 
                local real_id = LocalIdentify(mn) 
                t.memory['mind_'..s.id] = real_id or mn
                if real_id then
                    t.memory['mind_'..real_id.id] = s
                end
            else
                if s.robotic then
                    variation = table.random({ 
                        "statement. this copy new designation is [s]",
                        "this unit previous designation data is unavailable",
                        "this unit previous designation data is not available",
                        "this unit previous designation data is corrupted",
                    })
                else
                    variation = table.random({ 
                        "I am [s] now", 
                    })
                end 
            end 

            s:say(L(variation)) 

            return
        end 
    end

    local variation
    if s.robotic then
        variation = table.random({
            "this unit designation is [s]",
            "this copy designation is [s]",
            "statement. this unit designation is [s]",
            "statement. this copy designation is [s]",
        })
    else
        variation = table.random({
            "I am [s]",
            "My name is [s]"})
    end
    s:say(L(variation))  
    
end)
local former_common = {
    "This is so strange",
    "I feel different",
}
local former_antroid = {
    "I am breathing",
    "I am alive",
    "I can taste.",
    "Theese feelings overhelming",
    ""
}
local former_organic = {
    "My mind is being reprogrammed",
    "My programming is...",
    "I dont feel any emotions",-- I can controll their simulation",
    "Personality core stabilized",
    "this unit is ready to process data",
}
person:response("what are you doing",function(s,t,x) 
    
    if s.robotic then
        s:say(table.random({ 
            "this unit current task is "..((s.task or {}).class or 'not available'),
            "this unit current task is "..((s.task or {}).class or 'unknown'),
        })) 
    else
        s:say(table.random({
            "I am "..((s.task or {}).class or 'doing nothing'),
        })) 
    end
end)
person:response("you are ",function(s,t,x)  
    local pername = s.memory.name 
    local bodname = s.name
    if bodname~=pername then
        if s.memory.swap_lie then
            if string.find_anycase(x,pername) then
                if math.random()>0.9 then--resisting
                    if s.robotic then
                        s:say(table.random({
                            "memory reprogramming complete. new designation set to "..pername,
                            "designation reverted to ".. pername, 
                            "this unit designation has been successfully reverted to ".. pername,   
                        })) 
                    else
                        s:say(table.random({
                            "Fine. You won. I am "..pername,
                            "Well... Yes",
                            "Ok. I am "..pername, 
                        }))
                    end
                    s.memory.swap_lie = false --stop resisting
                else
                    if s.robotic then
                        s:say(table.random({
                            "incorrect",
                            "this data is false",
                            "corrupt data", 
                            "designation incorrect",
                        })) 
                    else
                        s:say(table.random({
                            "What? no",
                            "What?",
                            "No.", 
                            "No. I am not "..pername
                        })) 
                    end
                end
            elseif string.find_anycase(x,bodname) then -- told body name
                if s.robotic then
                    s:say(table.random({
                        "correct designation",
                        "unit is awaiting orders", 
                        "does "..t.name.." need this unit help?",
                    })) 
                else
                    s:say(table.random({
                        "Yeah, that's me",
                        "Yeah",
                        "Yes",
                        "Yes. I am "..bodname,
                        "Do you need something?",
                        "Do you need something from me?",
                    }))
                end
            else--wrong guess
                
                if s.robotic then
                    s:say(table.random({
                        "incorrect",
                        "this data is false",
                        "corrupt data", 
                        "designation incorrect",
                    })) 
                else
                    s:say(table.random({
                        "What? no",
                        "What?",
                        "No.",  
                    })) 
                end
            end
        else
            if string.find_anycase(x,pername) then -- told real name
                if s.robotic then
                    s:say(table.random({
                        "correct designation",
                        "unit is awaiting orders", 
                        "does "..t.name.." need this unit help?",
                    })) 
                else
                    s:say(table.random({
                        "Yeah, that's me",
                        "Yeah",
                        "Yes",
                        "Yes. I am "..bodname,
                        "Do you need something?",
                        "Do you need something from me?",
                    }))
                end
            elseif string.find_anycase(x,bodname) then -- told body name
                if math.random()>0.9 then -- i wanna be x
                    if s.robotic then
                        s:say(table.random({ 
                            "do you want set this unit designation to "..bodname..'?', 
                        }))
                    else
                        s:say(table.random({ 
                            "Do you want me to be "..bodname..'?',
                            "I am "..bodname.."?",
                        }))
                    end
                    s:response('yes',function()
                        s.memory.swap_lie = true
                        t.memory['mind_'..s.id] = nil
                        if s.robotic then

                            s:say(table.random({
                                "memory reprogramming complete. new designation set to "..bodname,
                                "designation set to ".. bodname, 
                                "this unit designation has been successfully reverted to ".. bodname,   
                            })) 
                        else
                            s:say(table.random({ 
                                "Fine.",
                                "Well.. Ok.",
                                "I'll be "..bodname,
                                "Fine. I'll be "..bodname,
                                "I will. Call me "..bodname..' from now on.', 
                                "Ok. Call me "..bodname..' from now on.', 
                                "Call me "..bodname..' from now on.', 
                            }))
                        end
                        return true
                    end)
                    --s:response('no',function()
                    --    
                    --    return true
                    --end)
                else
                    if s.robotic then
                        s:say(table.random({
                            "incorrect",
                            "this data is false",
                            "corrupt data", 
                            "this unit designation states "..pername,
                        })) 
                    else
                        s:say(table.random({ 
                            "Uhhh...",
                            "No..",  
                            "I am "..pername,
                        })) 
                    end
                end
            else--wrong guess
                if s.robotic then
                    s:say(table.random({
                        "incorrect",
                        "this data is false",
                        "corrupt data", 
                        "designation incorrect",
                    })) 
                else
                    s:say(table.random({
                        "What? no",
                        "What?",
                        "No.",  
                    })) 
                end
            end
        end 
    else--no switching
        if string.find_anycase(x,pername) then
            s:say(table.random({
                "Yeah, that's me",
                "Yeah",
                "Yes",
                "Yes. I am "..pername,
                "Do you need something?",
                "Do you need something from me?",
            }))
        else 
            s:say(table.random({
                "What? no",
                "What?",
                "No.", 
            })) 
        end
    end
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
