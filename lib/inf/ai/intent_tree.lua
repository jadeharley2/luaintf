--[[
person:intent_response(function(self,from,intent,dialogue,text)
    if text:sub(1,3)=='dox' then
        local args = text:sub(5):split(' ')  
        local something = LocalIdentify(args[2]) or LocalIdentify(args[2],self)
        if something then
            if something:interact(self,args[1],args[3],args[4],args[5]) then
                return true 
            end 
        end
    
        self:act(unpack(args)) 
        return true 
    end
    if intent.request then
        if intent.forget then
            if dialogue.topic then
                self:intent_say('ok',true) 
                dialogue.topic = nil
                return true
            else
                self:intent_say('forget what?',true) 
            end
        elseif intent.follow then
            if intent.start then
                local target = LocalIdentify(intent.target)
                if target=='me' then target = from end 
                if target and target:is(person) then
                    self:intent_say('ok',true) 
                    self.task = Task('follow',target)
                else
                    self:intent_say('follow who?',true) 
                end
            elseif intent.stop then
                if self.task and self.task:is('follow') then
                    self:intent_say('ok',true) 
                    self.task = false
                else
                    self:intent_say('i am not following anyone',true) 
                end
            end
        elseif intent.exchange then
            if intent.clothes then
                local my_gear = self.clothes
                local from_gear = from.clothes

                self:intent_say('ok',true) 

                for k,v in pairs(my_gear) do 
                    self:act('give',v,from)
                end
                for k,v in pairs(from_gear) do 
                    from:act('give',v,self)
                end
            end
        end
    end
    if dialogue.topic == "bodyswap" then
        if intent.question then 
            if intent.check_possession and intent.target:find("book") then
                self:intent_say('oh',true) 
                self:intent_say('yes i have it',true) 
            elseif intent.reason then --why?
                if dialogue.agreed then
                    self:intent_say("i want to be you",true) 
                else
                    self:intent_say("i don't want to",true) 
                    if self.personality.empathic then
                        self:intent_say('sorry') 
                    end
                end
            elseif intent.means then --how?
                --if knows about the book
                self:intent_say('i know there is a spell that can do this',true)
                dialogue.topic = "bodyswap_spell" 
            end
        elseif intent.answer then
            if intent.action and intent.positive then -- let's do this

            end
        end
    elseif dialogue.topic == "bodyswap_spell" then
        if intent.question then
            if intent.location and intent.thing then -- where i can find it?
                local book = LocalIdentify("strange book")
                if book then -- book in room
                    self:intent_say("there it is",true) 
                    self:act('take',book)
                    self:intent_say("here, read this",true) 
                    self:act('give',book,from)
                else
                    local book_in = LocalIdentify("strange book",self)
                    if book_in then -- book in inventory
                        self:intent_say("i have it with me",true) 
                        self:intent_say("here, read it",true) 
                        self:act('give',book_in,from)
                    elseif self.location == quarters then --we are in book default location
                        if dialogue.book_not_found then
                            self:intent_say("someone must have taken it",true) 
                        else
                            self:intent_say("book should be here somewhere",true) 
                            dialogue.book_not_found = true
                        end
                    else -- other locations
                        self:intent_say("i think you should read a spell book",true) 
                        self:intent_say("it should be in crew quarters",true) 
                    end
                end
            end
        elseif intent.request then
            if intent.read then

            end
        end
    elseif dialogue.topic == "own_name" then
        if intent.statement and intent.identity and intent.own then
            local name = intent.name
            if string.find_anycase(from.name,name) then
                self:intent_say("so what?")
            else
                self:intent_say('but')
                self:intent_say("you are "..from.name)
                self:intent_hook({"answer"},function(S,F,I,D,T)
                    if I.negative then
                        self:intent_say('well ok') 
                        self:remember_name(from, name)
                        self:say(name) 
                        D.topic = false
                    end 
                    return true
                end)
            end 
        end
    elseif dialogue.topic == "your_name" then
        if intent.statement and intent.identity and intent.subject then -- you are x
            local name = intent.name
            local bodyname = self.name 
            local mindname = self.memory.name 
            if bodyname~=mindname then 
                if self.memory.swap_lie then
                    if string.find_anycase(name,bodyname) then
                        self:intent_say('yes')
                    elseif string.find_anycase(name,mindname) then --told real name
                        self:intent_say('what?')
                        if math.random()>0.9 then--resisting
                            self:intent_say('fine')
                            self:intent_say('you won')
                            self.memory.swap_lie = false --stop resisting
                                      
                            local real_id = LocalIdentify(mindname) 
                            from.memory['mind_'..self.id] = real_id
                            --if real_id then
                            --    t.memory['mind_'..real_id.id] = s
                            --end

                            self:intent_say({
                                statement = true,
                                identity = true,
                                own = true,
                                name = mindname,
                            })  
                            

                        else
                            self:intent_say('no')
                            --self:intent_hook({"answer"},function(S,F,I,D,T)
                            --    if I.positive then
                            --        self:intent_say('well ok') 
                            --        self:remember_name(from, name)
                            --        self:say(name) 
                            --        D.topic = false
                            --    end 
                            --    return true
                            --end)
                        end
                    else
                        self:intent_say('no')
                    end
                else
                    if string.find_anycase(name,mindname) then
                        local real_id = LocalIdentify(mindname) 
                        from.memory['mind_'..self.id] = real_id
                        self:intent_say('yes')
                    elseif string.find_anycase(name,bodyname) then
                        self:intent_say('uhh')
                        self:intent_say('do you want me to be '..bodyname..'?')
                        self:intent_hook({"answer"},function(S,F,I,D,T)
                            if I.positive then
                                from.memory['mind_'..self.id] = nil
                                self:intent_say('well ok')  
                                D.topic = false
                            end 
                            return true
                        end)
                    else
                        self:intent_say('no')
                    end
                end
            else
                if self.name:find(name) then
                    self:intent_say("yes")
                elseif self.memory.name:find(name) then
                    if self.memory.swap_lie then
                        self:intent_say('what?')
                        self:intent_say('no')
                        self:intent_hook({"answer"},function(S,F,I,D,T)
                            if I.positive then
                                self:intent_say('well ok') 
                                self:remember_name(from, name)
                                self:say(name) 
                                D.topic = false
                            end 
                            return true
                        end)
                    else
                        self:intent_say("yes")
                    end
                else
                    self:intent_say('no')
                end 
            end

        end
    else
        if intent.greet then 
            self:intent_say('hi')
        elseif intent.parting then
            self:intent_say('bye') 
        elseif intent.question then
            if intent.bodyswap then  -- ...
                local X = self.mind.swap_request
                if X and X(self,from,intent,dialogue,text)  then  
                else 
                    if math.random()>0.5 then
                        dialogue.agreed = true
                        self:intent_say('yes',true) 
                        dialogue.topic = "bodyswap" 
                    else
                        dialogue.agreed = false
                        self:intent_say('no',true)  
                    end
                end
            elseif intent.identity then -- who are
                if intent.subject then--you
                    if self.memory.swap_lie then
                        from.memory['mind_'..self.id] = nil
                        self:intent_say({
                            statement = true,
                            identity = true,
                            own = true,
                            name = self.name
                        })  
                    else 
                        local real_id = LocalIdentify(self.memory.name) 
                        from.memory['mind_'..self.id] = real_id
                        self:intent_say({
                            statement = true,
                            identity = true,
                            own = true,
                            name = self.memory.name,
                        }) 
                    end
                    self:intent_hook({"answer"},function(S,F,I,D,T)
                        if I.negative then
                            self:intent_say('what?') 
                            D.topic = "your_name"
                        end 
                        return true
                    end)  
                elseif intent.own then -- i 
                    self:intent_say({
                        statement = true,
                        identity = true,
                        subject = true,
                        name = self:recall_name(from),
                    }) 
                    self:intent_hook({"answer"},function(S,F,I,D,T)
                        if I.negative then
                            self:intent_say('why?') 
                            D.topic = "own_name"
                        end 
                        return true
                    end) 
                end
            elseif intent.check_condition and intent.subject then -- how are 
                s:say(table.random({ 
                    "i feel alive", 
                    "i love being organic",
                    "i am female",
                    "it is strange to stand on two legs",
                    "i feel strange",
                    "this is surreal",
                })) 
                self:intent_say('i feel '..(self.mood or 'ok'),true) 
            elseif intent.check_location then -- where are
                self:intent_say("i don't know",true) 
            elseif intent.check_activity then -- what are doing?
                self:intent_say('i am standing right here',true) 
            elseif intent.check_possession and intent.target then -- do you have x
                local x = LocalIdentify(intent.target,self)
                if x then
                    self:intent_say('yes i have it',true) 
                    self:intent_say('do you need it?',true) 
                    self:intent_hook({"answer"},function(S,F,I,D,T)
                        if I.positive then
                            self:intent_say('here you go') 
                            self:act('give',intent.target,F.id)
                            --x.location = F 
                        end 
                        return true
                    end)
                else
                    self:intent_say('no',true) 
                end
            elseif intent.desire then  
                if intent.being then -- do you like being x
                    local x = LocalIdentify(intent.target)
                    if x == self then
                        self:intent_say('yes') 
                    end

                end
            else

            end
        else
            
            if self.memory.swap_lie  then
                if string.find_anycase(self.name,text) then 
                    self:intent_say('what?',true) 
                end
            else
                if string.find_anycase(self.name,text) or string.find_anycase(self.memory.name,text)  then --LocalIdentify(text)==self then
                    self:intent_say('what?',true) 
                end
            end

        end 
        if intent.misspelling then
            if self.memory.hates_misspelling then
                self:say("fix your language")
            end
        end
    end
 

end)



]]





person.intent_tree = {
    greet = "hi",
    parting = "bye",
    own_name = "what do you need?",
    question = {
        bodyswap = function(self,F,I,D,T)
            local X = self.mind.swap_request
            if X and X(self,F,I,D,T)  then  
            else 
                if math.random()>0.5 then
                    D.agreed = true
                    self:intent_say('yes') 
                    D.topic = "bodyswap" 
                else
                    D.agreed = false
                    self:intent_say('no')  
                end
            end
        end,

        identity = {-- who are
            subject = function(self,F,I,D,T) --you
                if self.memory.swap_lie then
                    F.memory['mind_'..self.id] = nil
                    self:intent_say({
                        statement = true,
                        identity = true,
                        own = true,
                        name = self.name
                    })  
                else 
                    local real_id = LocalIdentify(self.memory.name) 
                    F.memory['mind_'..self.id] = real_id
                    self:intent_say({
                        statement = true,
                        identity = true,
                        own = true,
                        name = self.memory.name,
                    }) 
                end
                self:intent_hook({"answer"},function(S,F,I,D,T)
                    if I.negative then
                        self:intent_say('what?') 
                        D.topic = "your_name"
                    end 
                    return true
                end)
            end,
            
            own = function(self,F,I,D,T) -- who am i?
                self:intent_say({
                    statement = true,
                    identity = true,
                    subject = true,
                    name = self:recall_name(F),
                }) 
                self:intent_hook({"answer"},function(S,F,I,D,T)
                    if I.negative then
                        self:intent_say('why?') 
                        D.topic = "own_name"
                    end 
                    return true
                end) 
            end,
        },

        check_condition = { --how are  
            subject = function(self,F,I,D,T) --you?
                --self:say(table.random({ 
                --    "i feel alive", 
                --    "i love being organic",
                --    "i am female",
                --    "it is strange to stand on two legs",
                --    "i feel strange",
                --    "this is surreal",
                --})) 
                self:intent_say('i feel '..(self.mood or 'ok'),true) 
            end,
        },

        check_location = "i don't know", --where are x?
        check_activity = 'i am standing right here', -- what are x doing?

        check_possession = {
            target = function(self,F,I,D,T)-- do you have x
                local x = LocalIdentify(I.target,self)
                if x then
                    self:intent_say('yes i have it',true) 
                    self:intent_say('do you need it?',true) 
                    self:intent_hook({"answer"},function(S,F,I,D,T)
                        if I.positive then
                            self:intent_say('here you go') 
                            self:act('give',x,F) 
                        end 
                        return true
                    end)
                else
                    self:intent_say('no',true) 
                end
            end,
        },

        desire = {
            being = function(self,F,I,D,T) -- do you like being x
                local x = LocalIdentify(I.target)
                if x == self then
                    self:intent_say('yes') 
                end
            end,
        }
    },
    request = {
        _ = DefineIntents("[i] command [you] [to] {action} {target} {target2}",{"request","command"}),
        command = function(self,F,I,D,T)
            
            local something = LocalIdentify(I.target) or LocalIdentify(I.target,self)
            if something then
                if something:interact(self,I.action,I.target2) then
                    return true 
                end 
            end
        
            self:act(I.action,I.target,I.target2)
            return true 
        end,
        forget = function(self,F,I,D,T)
            if D.topic then
                self:intent_say('ok',true) 
                D.topic = nil
                return true
            else
                self:intent_say('forget what?',true) 
            end
        end,

        follow = {
            start = function(self,F,I,D,T)
                local target = LocalIdentify(I.target)
                if I.target=='me' then target = F end 
                if target and target:is(person) then
                    self:intent_say('ok',true) 
                    self.task = Task('follow',target)
                else
                    self:intent_say('follow who?',true) 
                end
            end,

            stop = function(self,F,I,D,T)
                if self.task and self.task:is('follow') then
                    self:intent_say('ok',true) 
                    self.task = false
                else
                    self:intent_say('i am not following anyone',true) 
                end
            end,
        },

        _ = DefineIntents("drop {target}",{"request","drop"}),
        drop = function(self,F,I,D,T)
            local target = I.target
            if target then
                local v = LocalIdentify(target,self)
                if v then 
                    self:intent_say('ok',true) 
                    self:act('drop',v)
                else 
                    self:intent_say("i don't have "..target,true) 
                end
            end
        end,
        give = {
            _ = DefineIntents("give me {target}",{"request","give","me"}),
            me = function(self,F,I,D,T) 
                if I.target then
                    local v = LocalIdentify(I.target,self)
                    if v then 
                        self:intent_say('ok',true) 
                        self:act('give',v,F)
                    else 
                        self:intent_say("i don't have "..v,true) 
                    end
                end
            end,
            _ = DefineIntents("give {target} to {someone}",{"request","give","subject"}),
            subject = function(self,F,I,D,T) 
                if I.target and I.someone then
                    local v = LocalIdentify(I.target,self)
                    local u = LocalIdentify(I.someone)
                    if v then 
                        if u then
                            self:intent_say('ok',true) 
                            self:act('give',v,u)
                        else
                            self:intent_say("who is "..u..'?',true) 
                        end
                    else 
                        self:intent_say("i don't have "..v,true) 
                    end
                end
            end,
        },
        take = {

        },
        exchange = {
            _ = DefineIntents("let's exchange|swap clothes",{"request","exchange","clothes"}),
            _ = DefineIntents("let's exchange|swap clothes",{"request","exchange","clothes"}),
            clothes = function(self,F,I,D,T)
                local my_gear = self.clothes
                local from_gear = F.clothes

                self:intent_say('ok',true) 

                for k,v in pairs(my_gear) do 
                    self:act('give',v,F)
                end
                for k,v in pairs(from_gear) do 
                    F:act('give',v,self)
                end
            end,
        },
        _ = DefineIntents("[can] [you] swap {source} with {target}",{"request","swapwith"}),
        swapwith = function(self,F,I,D,T)
            if self:is("rogue_class") then
                local v = LocalIdentify(I.target)
                if v then
                    if I.source=='me' then                
                        Scene(function()
                            self:intent_say("sure") 
                            self:act("soulrip",v) 
                            self:act("soulrip",F)
                            self:intent_say("there you go")
                        end) 
                    else
                        local v2 = LocalIdentify(I.source)
                        if v2 then                     
                            Scene(function()
                                self:intent_say("sure") 
                                self:act("soulrip",v) 
                                self:act("soulrip",v2)
                                self:intent_say("there you go")
                            end)
                        else
                            self:intent_say(L"bring me to [I.source] first")
                        end
                    end
                else
                    self:intent_say(L"bring me to [I.target] first")
                end
            else
                self:intent_say("i can't")
            end
        end,
    },
    
    topic_bodyswap = {
        question = {
            check_possession = function(self,from,intent,dialogue,text)
                if intent.target:find("book") then
                    self:intent_say('oh',true) 
                    self:intent_say('yes i have it',true) 
                end
            end,
            reason = function(self,from,intent,dialogue,text)
                if dialogue.agreed then
                    self:intent_say("i want to be you",true) 
                else
                    self:intent_say("i don't want to",true) 
                    if self.personality.empathic then
                        self:intent_say('sorry') 
                    end
                end
            end,
            means = function(self,from,intent,dialogue,text)--how
                --if knows about the book
                self:intent_say('i know there is a spell that can do this',true)
                dialogue.topic = "bodyswap_spell" 
            end,
        },
        answer = {
            action = {
                positive = "yay"-- let's do this
            }
        }
    },
    topic_bodyswap_spell = {
        question = {
            location ={
                thing = function(self,from,intent,dialogue,text)
                    local book = LocalIdentify("strange book")
                    if book then -- book in room
                        self:intent_say("there it is",true) 
                        self:act('take',book)
                        self:intent_say("here, read this",true) 
                        self:act('give',book,from)
                    else
                        local book_in = LocalIdentify("strange book",self)
                        if book_in then -- book in inventory
                            self:intent_say("i have it with me",true) 
                            self:intent_say("here, read it",true) 
                            self:act('give',book_in,from)
                        elseif self.location == quarters then --we are in book default location
                            if dialogue.book_not_found then
                                self:intent_say("someone must have taken it",true) 
                            else
                                self:intent_say("book should be here somewhere",true) 
                                dialogue.book_not_found = true
                            end
                        else -- other locations
                            self:intent_say("i think you should read a spell book",true) 
                            self:intent_say("it should be in crew quarters",true) 
                        end
                    end 
                end,
            },
        },
        request = {
            read = function(self,from,intent,dialogue,text)
            end,
        } 
    },
    topic_own_name = {
        statement = {
            identity = {
                own = function(self,from,intent,dialogue,text)
                    local name = intent.name
                    if string.find_anycase(from.name,name) then
                        self:intent_say("so what?")
                    else
                        self:intent_say('but')
                        self:intent_say("you are "..from.name)
                        self:intent_hook({"answer"},function(S,F,I,D,T)
                            if I.negative then
                                self:intent_say('well ok') 
                                self:remember_name(from, name)
                                self:say(name) 
                                D.topic = false
                            end 
                            return true
                        end)
                    end 
                end,
            }
        }
    },
    topic_your_name = {
        statement = {
            identity = {
                subject = function(self,from,intent,dialogue,text)
                    local name = intent.name
                    local bodyname = self.name 
                    local mindname = self.memory.name 
                    if bodyname~=mindname then 
                        if self.memory.swap_lie then
                            if string.find_anycase(name,bodyname) then
                                self:intent_say('yes')
                            elseif string.find_anycase(name,mindname) then --told real name
                                self:intent_say('what?')
                                if math.random()>0.9 then--resisting
                                    self:intent_say('fine')
                                    self:intent_say('you won')
                                    self.memory.swap_lie = false --stop resisting
                                              
                                    local real_id = LocalIdentify(mindname) 
                                    from.memory['mind_'..self.id] = real_id
                                    --if real_id then
                                    --    t.memory['mind_'..real_id.id] = s
                                    --end
        
                                    self:intent_say({
                                        statement = true,
                                        identity = true,
                                        own = true,
                                        name = mindname,
                                    })  
                                    
        
                                else
                                    self:intent_say('no')
                                    --self:intent_hook({"answer"},function(S,F,I,D,T)
                                    --    if I.positive then
                                    --        self:intent_say('well ok') 
                                    --        self:remember_name(from, name)
                                    --        self:say(name) 
                                    --        D.topic = false
                                    --    end 
                                    --    return true
                                    --end)
                                end
                            else
                                self:intent_say('no')
                            end
                        else
                            if string.find_anycase(name,mindname) then
                                local real_id = LocalIdentify(mindname) 
                                from.memory['mind_'..self.id] = real_id
                                self:intent_say('yes')
                            elseif string.find_anycase(name,bodyname) then
                                self:intent_say('uhh')
                                self:intent_say('do you want me to be '..bodyname..'?')
                                self:intent_hook({"answer"},function(S,F,I,D,T)
                                    if I.positive then
                                        from.memory['mind_'..self.id] = nil
                                        self:intent_say('well ok')  
                                        D.topic = false
                                    end 
                                    return true
                                end)
                            else
                                self:intent_say('no')
                            end
                        end
                    else
                        if self.name:find(name) then
                            self:intent_say("yes")
                        elseif self.memory.name:find(name) then
                            if self.memory.swap_lie then
                                self:intent_say('what?')
                                self:intent_say('no')
                                self:intent_hook({"answer"},function(S,F,I,D,T)
                                    if I.positive then
                                        self:intent_say('well ok') 
                                        self:remember_name(from, name)
                                        self:say(name) 
                                        D.topic = false
                                    end 
                                    return true
                                end)
                            else
                                self:intent_say("yes")
                            end
                        else
                            self:intent_say('no')
                        end 
                    end
                end
            }
        },
    },

}
