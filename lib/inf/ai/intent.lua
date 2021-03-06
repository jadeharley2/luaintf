
--conditions
-- is_swapped with X
--      was Y
--      wants to stay swapped | or not
--      wants to hide its identity
--
-- wants to swap with X
--      is X is player
--


--conditional responces: intent based

--get intents from text
intents = {}
intents.identity = function(text)
    return text:find_anycase("who are you") 
        or text:find_anycase("who you are")
        or text:find_anycase("what is your name")
end
intents.greet = function(text)
    return text:find_anycase("hello") 
        or text:find_anycase("hi")
        or text:find_anycase("hey")
        or text:find_anycase("welcome")
        or text:find_anycase("greetings")
        or text:find_anycase("nice to see you")
end


function GetCIntents(text)

    local r = {}
    for k,v in pairs(intents) do 
        if v(text) then r[k] = true end
    end
    return r
end

text_intents = {}
text_replacements = {}
intent_defaults = { }
function DefineIntents(text,intents)
    local words = text:getwords()
    local vars = {}
    for k,v in pairs(words) do
        if v:sub(1,1)=='{' then
            vars[v:sub(2,-2)] = true
        end
    end
    text_intents[#text_intents+1] = {
        text = text,
        words = words,
        vars = vars,
        intents = intents,
        intent_set = table.set(intents),
    }  
end
--todo add intent replacement on text generation
--example: replace 'want to' with 'wanna' when intent misspelling == true
function DefineReplacement(text,newtext,intents)
    text_replacements[#text_replacements+1] = {
        text = text,
        replacement = newtext,
        intents = intents,
    }  
end
function DefineDefaultIntent(intent,value)
    intent_defaults[intent] = value
end


--functions


local function SubMatch(tword,pword)
    if tword == pword then
        return true
    else
        local parts = pword:split('|')
        if #parts>1 then 
            for kk,vv in ipairs(parts) do
                if vv==tword then 
                    return true
                end
            end
        end  
    end
    return false
end
local function Match(words,pattern,off)
    local variables = {}
 
    for k=1,#pattern do
        local tword = words[off+k]
        local pword = pattern[k]
        
        
        if pword:sub(1,1)=="{" then
            local var = pword:sub(2,-2)
            variables[var] = tword
        elseif pword:sub(1,1)=="[" then --optional words
            local w = pword:sub(2,-2)
            if not SubMatch(tword,w) then
                off = off - 1
            end
        elseif not SubMatch(tword,pword) then
            return false
        end
    end
    return variables
end
local function RandomSubstring(text)
    local parts = text:split('|')
    if #parts>1 then
        return table.random(parts)
    else
        return text
    end
end
local function IntentVariantToText(intents,variant)
    local r = {}
    for k,v in ipairs(variant.words) do
        local c = v:sub(1,1) 
        if c=='{' then
            local key = v:sub(2,-2)
            local value = intents[key]
            r[#r+1] = value
        elseif c=='[' then
            r[#r+1] = RandomSubstring(v:sub(2,-2))
        else 
            r[#r+1] = RandomSubstring(v)
        end
    end
    return table.concat(r,' ')
end
function GetIntentTexts(intents,def,mod)
    local matches = GetIntentVariants(intents,def,mod)
    local results = {}
    for k,v in pairs(matches) do  
        results[k] = IntentVariantToText(intents,v)  
    end
    return results
end
function GetIntentText(intents,def,mod,use_fallback)
    if type(intents)=='string' then
        local r = GetIntents(intents)
        if not next(r) then
            return intents
        end
        intents = r
    end

    local matches = GetIntentVariants(intents,def,mod)
    if #matches>0 then 
        return IntentVariantToText(intents,table.random(matches))  
    elseif use_fallback then
        local matches = GetIntentVariants(intents)
        if #matches>0 then 
            return IntentVariantToText(intents,table.random(matches))  
        end
    end
end

function ModIntents(intents,def,mod)
    if def==nil then def = intent_defaults end
    local n = {}
    for k,v in pairs(intents) do 
        n[k] = v
    end
    if mod then 
        for k,v in pairs(mod) do
            if n[k]==nil then
                n[k] = v
            end
        end
    end
    if def then 
        for k,v in pairs(def) do
            if n[k]==nil then
                n[k] = v
            end
        end
    end
    return n
end

 

function GetIntentVariants(intents, def,mod)
    --fix intent table
    if type(intents)=='string' then
        local nt = {}
        for k,v in ipairs(intents:split(' ')) do
            if v:sub(1,1)=='-' then
                nt[v:sub(2)] = false
            else
                nt[v] = true
            end
        end
        intents = nt
    elseif #intents>0 then
        local nt = {}
        for k,v in pairs(intents) do
            nt[v] = true
        end
        intents = nt
    end

    intents = ModIntents(intents,def,mod)

    local matches = {}
    for k,v in pairs(text_intents) do
        local match = true
        for kk,vv in pairs(intents) do
            if vv==true then--must contain
                if not v.intent_set[kk] then 
                    match = false
                end
            elseif vv==false then--must not contain
                if v.intent_set[kk] then 
                    match = false
                end
            else--intent is variable
               -- if not v.vars[kk] then
               --     match = false
               -- end
            end
        end
        for kk,vv in pairs(v.vars) do
            if intents[kk]==nil then -- intent does not have needed variable!
                match = false
            end
        end
        if match then
            matches[#matches+1] = v
        end
    end 
    return matches
end


function GetIntents(text)
    local r = {}

    text = string.lower(text)
    for k,v in pairs(text_replacements) do
        local newtext =string.gsub(text, v.text,v.replacement) 
        if newtext~=text then
            for k,v in pairs(v.intents) do
                r[k] = true
            end
            text = newtext
        end
    end

    local words =text:getwords()
    local textwordlen = #words

    local variables = {}

    for k,v in ipairs(text_intents) do 
        local pattern = v.words  

        for u=0,textwordlen-1 do
            local result = Match(words,pattern,u)
            if result then
                for kk,vv in pairs(v.intents) do 
                    r[vv] = true 
                    --local parts = vv:split(':')
                    --if #parts==2 then
                    --    r[parts[1]] = result[parts[2]]
                    --else
                    --    r[vv] = true 
                    --end
                end 
                for kk,vv in pairs(result) do
                    r[kk] = vv
                end
                return r
            end
        end

       --if text:find_anycase(v.text) then
       --    for kk,vv in pairs(v.intents) do r[vv] = true end
       --end
    end
    return r
end


person.intent_responses = {}
person.intent_response = function(self,callback)
    self.intent_responses = rawget(self,'intent_responses') or {} 
    self.intent_responses[#self.topics] = callback
end
person.intent_respond = function(self,from,about)
    if not players[self] then
        local intents = GetIntents(about)
        local dialogue = self.dialogue or {}
        self.dialogue = dialogue

        local mind = self.mind

        dialogue.c3 = dialogue.c2
        dialogue.c2 = dialogue.c1
        dialogue.c1 = dialogue.c0
        dialogue.c0 = intents

        local H = self.this.intent_hooks
        if H then
            --find matching hook and call it
            for k,v in pairs(H) do
                local match = true
                for kk,vv in pairs(v.intent) do
                    if vv==true then--must contain
                        if not intents[kk] then 
                            match = false
                        end
                    elseif vv==false then--must not contain
                        if intents[kk] then 
                            match = false
                        end
                    else--intent is variable 
                    end
                end
                if match then
                    local r = v.callback(self,from,intents,dialogue,about,mind)
                    if r~=nil then
                        if r==true then
                            --H[k] = nil
                            self.this.intent_hooks = {} -- clear all
                        end
                        return r
                    end
                end
            end
        end


        if dialogue.topic then
            intents['topic_'..dialogue.topic] = true
        end
        if #about>=3 then 
            if string.find_anycase(self.name,about) then
                intents['own_name'] = true
            end
            if string.find_anycase(self.memory.name,about) then
                intents['memory_name'] = true
            end
        end

        local function treerun(node)
            for k,v in pairs(node) do 
                if intents[k] then
                    local t= type(v)
                    if t=='table' then
                        local r = treerun(v)
                        if r then return r end 
                    elseif t=='string' then
                        self:intent_say(v)
                        return true
                    elseif t=='function' then
                        local result = v(self,from,intents,dialogue,about,mind)
                        return result
                    end
                end
            end
            local v = node._else 
            if v then 
                local t= type(v)
                if t=='table' then
                    local r = treerun(v)
                    if r then return r end 
                elseif t=='string' then
                    self:intent_say(v)
                    return true
                elseif t=='function' then
                    local result = v(self,from,intents,dialogue,about,mind)
                    return result
                end
            end
        end
        

        local r = self:foreach_type(function(x)
            local tree = rawget(x,'intent_tree')
            if tree then
                local r = treerun(tree)
                if r then return r end 
            end
        end,true)
        if r then return r end 

        --local node = self.intent_tree
        --if node then 
        --    local r = treerun(node)
        --    if r then return r end 
        --end

        --self:foreach('intent_responses',function(k,v) 
        --    local result = v(self,from,intents,dialogue,about)
        --    if result~=nil then
        --        if result=='remove' then
        --            self.intent_responses[k] = nil 
        --            return true
        --        end
        --        return result
        --    end 
        --end) 
    end
end
person.intent_say = function(self,intent,use_fallback)
    if use_fallback==nil then use_fallback = true end
    self:say(GetIntentText(intent,nil,self.intent_defaults,use_fallback))
end

person.intent_hook = function(self,intent,callback)
    local H = self.this.intent_hooks or {}
    self.this.intent_hooks = H
    local id = #H+1
    H[id] = {
        id = id,
        intent = intent,
        callback = callback,
    }
end
--defines

DefineReplacement("wanna","want to",{misspelling=true}) 
DefineReplacement("heya","hey",{misspelling=true}) 
DefineReplacement("hai","hi",{misspelling=true}) 
DefineReplacement("howdy","how have you been",{misspelling=true}) 
DefineReplacement("lets","let's",{}) 

DefineDefaultIntent('past',false)
DefineDefaultIntent('future',false)
DefineDefaultIntent('robotic',false)
DefineDefaultIntent('misspelling',false)
DefineDefaultIntent('formal',false)
DefineDefaultIntent('too',false)

DefineIntents("who i am",{"question","identity","own"})
DefineIntents("who am i",{"question","identity","own"})
DefineIntents("who are you",{"question","identity","subject"})
DefineIntents("who you are",{"question","identity","subject"})
DefineIntents("what is your name",{"question","identity","subject","get_name"})
DefineIntents("what is my name",{"question","identity","own","get_name"})
DefineIntents("what are you",{"question","identity","subject","unknown"})
DefineIntents("what {target}?",{"question","surprise","identity","unknown"})

DefineIntents("how?",{"question","simple","means"}) 
DefineIntents("how we [gonna|will] do this?",{"question","means","action"}) 
DefineIntents("where i can find it?",{"question","own","location","thing"}) 
DefineIntents("where is it?",{"question","location","thing"})  
DefineIntents("where?",{"question","location"}) 

DefineIntents("i am {name}",{"statement","identity","own"})
DefineIntents("i am {name} too",{"statement","identity","own","too"})
DefineIntents("i was {name}",{"statement","identity","own","past"})
DefineIntents("you are {name}",{"statement","identity","subject"})
DefineIntents("my name is {name}",{"statement","identity","own"})
DefineIntents("my name is {name} too",{"statement","identity","own","too"})
DefineIntents("this unit|copy designation is {name}",{"statement","identity","own","robotic"})
DefineIntents("statement. this unit|copy designation is {name}",{"statement","identity","own","robotic"})

DefineIntents("i am {name}?",{"question","identity","own"})
DefineIntents("who i am?",{"question","identity","own"})

DefineIntents("i am.. or was {name}",{"statement","identity","own","past"})

DefineIntents("i am naked",{"statement","naked"})
DefineIntents("this unit chassis is exposed",{"statement","naked",'robotic'})

DefineIntents("i feel {mood}",{"statement","mood"})
DefineIntents("this unit does not simulate emotions",{"statement","mood","robotic"})
DefineIntents("this unit does not have sentiment programming",{"statement","mood","robotic"})
DefineIntents("sentiment module is not installed on this frame",{"statement","mood","robotic"})

DefineIntents("fine",{"fine"}) 
DefineIntents("...",{"fine",'robotic'}) 
DefineIntents("you won",{"capitulation"}) 
DefineIntents("internal error",{"capitulation",'robotic'}) 

DefineIntents("hello",{"greet"}) 
DefineIntents("hi",{"greet"}) 
DefineIntents("hey",{"greet","informal"}) 
--DefineIntents("heya",{"greet","informal","misspelling"}) 
--DefineIntents("hai",{"greet","informal","misspelling"}) 
DefineIntents("hey, {target}",{"greet","informal"}) 
DefineIntents("hi, {target}",{"greet","informal"}) 
DefineIntents("hello, {target}",{"greet","informal"}) 

DefineIntents("welcome",{"greet","location"}) 
DefineIntents("greetings",{"greet","formal"}) 
DefineIntents("good morning",{"greet","formal","time","morning"}) 
DefineIntents("good evening",{"greet","formal","time","evening"}) 
DefineIntents("good day",{"greet","formal","time","day"}) 

DefineIntents("good night",{"parting","formal","time","night"}) 
DefineIntents("goodnight",{"parting","formal","time","night"}) 
DefineIntents("goodnight, {target}",{"parting","formal","time","night"}) 
DefineIntents("bye",{"parting"}) 
DefineIntents("bye, {target}",{"parting"}) 
DefineIntents("goodbye",{"parting",'formal'}) 
DefineIntents("goodbye, {target}",{"parting",'formal'}) 
DefineIntents("see you soon",{"parting","wish"}) 
DefineIntents("see you soon, {target}",{"parting","wish"}) 

DefineIntents("nice to see you",{"greet","wish"}) 
DefineIntents("nice to meet you",{"greet","wish"}) 

--DefineIntents("howdy",{"question","check_condition","subject","misspelling"}) 
DefineIntents("how are you",{"question","check_condition","subject"}) 
DefineIntents("how have you been",{"question","check_condition","subject","past"}) 
DefineIntents("what are you doing",{"question","check_activity","subject"})  
DefineIntents("what was you doing",{"question","check_activity","subject","past"})  

DefineIntents("what are you eating",{"question","check_activity","subject","eat"})  
DefineIntents("what are you reading",{"question","check_activity","subject","read"})  
DefineIntents("what are you thinking",{"question","check_activity","subject","think"})  


--DefineIntents("maybe",{"unknown"}) 
DefineIntents("uhh no",{"answer","negative",'uncertain'}) 

DefineIntents("no",{"answer","negative"}) 
DefineIntents("never",{"answer","negative","always"}) 
DefineIntents("not now",{"answer","negative","temporary"}) 
DefineIntents("maybe later",{"answer","negative","temporary"}) 

DefineIntents("request denied",{"answer","negative","robotic"}) 
DefineIntents("incorrect",{"answer","negative","robotic"}) 

DefineIntents("this data is false",{"answer","negative","data","robotic"}) 
DefineIntents("corrupt data",{"answer","negative","data","robotic"}) 
DefineIntents("{param} incorrect",{"answer","negative","data","robotic"}) 
--DefineIntents("unavailable",{"answer","negative","robotic"}) 

DefineIntents("uhh yes",{"answer","simple","positive",'uncertain'}) 
DefineIntents("yes",{"answer","simple","positive"}) 
DefineIntents("ok",{"answer","simple","positive"}) 
DefineIntents("sure",{"answer","simple","positive","confident"}) 

DefineIntents("affirmative",{"answer","simple","positive","robotic"}) 

DefineIntents("correct",{"answer","simple","positive","data","robotic"}) 
DefineIntents("correct {param}",{"answer","simple","positive","data","robotic"})  

DefineIntents("let's do this",{"answer","positive","confident","action"}) 



DefineIntents("forget it|this",{"request","forget"}) 
DefineIntents("follow {target}",{"request","follow","start"}) 
DefineIntents("stop following",{"request","follow","stop"}) 
DefineIntents("read it",{"request","read","thing"}) 
DefineIntents("read this",{"request","read","thing"}) 
DefineIntents("let's exchange|swap clothes",{"request","exchange","clothes"})





DefineIntents("why?",{"question","reason"}) 
DefineIntents("really?",{"surprise","question","confirmation"})
DefineIntents("are you sure?",{"question","confirmation"})
DefineIntents("i am sure",{"answer","confirmation","positive"})

DefineIntents("uh",{"sound","confusion",'exclamation'}) 
DefineIntents("um",{"sound","confusion",'exclamation'}) 
DefineIntents("oh",{"sound","surprise",'exclamation'}) 
DefineIntents("oh!",{"sound","surprise",'exclamation'}) 

--DefineIntents("you are the best",{"statement","adoration"}) 
--DefineIntents("you are best",{"statement","adoration"}) 
DefineIntents("i am [the] best",{"statement","adoration","own"}) 
DefineIntents("you are [the] best",{"statement","adoration","subject"}) 
DefineIntents("{target} is [the] best",{"statement","adoration"}) 
--if intents[target]==self then
--    --ok
--end
--DefineIntents("?",{"question","simple"}) 
DefineIntents("what?",{"question","simple","need"}) 
DefineIntents("what do you need|want ?",{"question","simple","need"})  
DefineIntents("what do you need|want from me?",{"question","simple","need"}) 
DefineIntents("unit awaiting orders",{"question","simple","need",'robotic'}) 
DefineIntents("please state your request",{"question","simple","need",'robotic'}) 

DefineIntents("i am sorry",{"apologize"}) 
DefineIntents("sorry",{"apologize"}) 

DefineIntents("are you ok?",{"question","concern","condition"}) 
DefineIntents("are you good?",{"question","concern","condition"}) 

DefineIntents("where are we",{"question","check_location","group"}) 
DefineIntents("where are you",{"question","check_location","subject"}) 
DefineIntents("where are am",{"question","check_location","own"}) 

DefineIntents("want to swap with {target}",{"question","desire","bodyswap"}) 
DefineIntents("do you want to swap",{"question","desire","subject","bodyswap"}) 
DefineIntents("do you want to be {target}",{"question","desire","bodyswap"}) 
DefineIntents("designation change to {target} requested, confirm?",{"question","desire","bodyswap",'robotic'}) 
--DefineIntents("i want to be you",{"statement","desire","being"})
 
DefineIntents("i want to be {target}",{"statement","desire","being"})
DefineIntents("i want to be you",{"statement","desire","being","subject"})
DefineIntents("i want to become you",{"statement","desire","being","subject"})
DefineIntents("you like being {target}",{"question","desire","being"})

DefineIntents("i don't want to",{"statement","desire","negative"})
DefineIntents("[do] you have [a|an|the] {target}",{"question","check_possession"})




DefineIntents("yes i have it",{"statement","possession","positive"})
DefineIntents("i have it with me",{"statement","possession","positive"})
DefineIntents("i don't have it with me",{"statement","possession","negative"})
--tests

--sort by word count descending to match properly
table.sort(text_intents, function(a,b) return #a.words>#b.words end)

local function IsIncluded(a,b)--a in b
    for k,v in pairs(a) do
        if not b[k] then return false end
    end
    return true
end

local function MakeIntentTree()
    local root = {}
    --find all groups
    local groups = {}
    for k,v in pairs(text_intents) do
        for _,I in pairs(v.intents) do
            local g = groups[I] or {}
            groups[I] = g 
            g[v] = v.text
        end 
    end

    
    --find inclusions between groups
    local newgroups = table.copy(groups)
    for k,A in pairs(groups) do
        for _,B in pairs(groups) do
            if A~=B then
                if IsIncluded(A,B) then
                    newgroups[k] = nil 
                    B[k] = A
                    for kk,vv in pairs(A) do
                        B[vv] = nil
                    end
                end
            end
        end
    end

    local xca = 0
end

--MakeIntentTree()
local intents01 = GetIntents("anneke is best") 
local intents02 = GetIntents("i want to be jade") 
local intents03 = GetIntents("do you want to be jade?") 
local intents04 = GetIntents("how have you been?")
local intents05 = GetIntents("you are the best") 
local intents06 = GetIntents("i am the best") 
local intents07 = GetIntents("wanna swap with me?") 
local intents08 = GetIntents("do you have a book?") 
local intents09 = GetIntents("what pumpkin?") 
local intents10 = GetIntents("what are you doing?") 
local intents11 = GetIntents("what are you eating?") 


local rez01 = GetIntentTexts({greet=true})
local rez02 = GetIntentTexts({greet=true,formal=true}) 
local rez03 = GetIntentTexts({bodyswap=true,target='ara'})
local rez04 = GetIntentTexts({parting=true,formal=false}) 
local rez05 = GetIntentTexts({parting=true}) 
local rez06 = GetIntentTexts({greet=true,robotic=true})
local rez07 = GetIntentTexts({statement=true,identity=true,own=true,name='luna'})
local rez08 = GetIntentTexts({statement=true,identity=true,own=true,name='luna',robotic=true})
local rez09 = GetIntentTexts({statement=true,adoration=true,own=false,subject=false,target='luna'})

local rez10 = GetIntentTexts({greet=true,target='vikna'})

local a = 0

function person:remember_name(target,name) 
    self.memory['nameof_'..target.id] = name 
end
function person:recall_name(target) 
    return self.memory['nameof_'..target.id] 
        or (self.memory['mind_'..target.id] or {}).name 
        or target.name
end
