
--- 

--input words/wordparts??
--output {phrases+actions}
local node_meta = {}

local function DecisionTree()
    return setmetatable({cases = {}},node_meta)
end

function node_meta:Add(input,output)
    for k,v in pairs(output) do
        for kk,vv in pairs(input) do 
            self.cases[#self.cases+1] = {vv,v}
        end
    end
    
end
function node_meta:AddCase(case)
    self.cases[#self.cases+1] = case
    
end
function node_meta:SelectKey(bannedkeys) 
    local totals = {}
    local count = 0
    local keycount = 0
    for k,v in pairs(self.cases) do
        for kk,vv in pairs(v[1]) do
            if not bannedkeys[kk] then
                local x = totals[kk] 
                if not x then
                    x = 0
                    keycount = keycount + 1
                end
                totals[kk] = x + 1
            end
        end
        count = count + 1
    end
    if keycount==1 then
        return false
    end

    local target = count/2
    local minimal
    local minscore = 9000000000
    for k,v in pairs(totals) do
        --middle count:
         local score = math.abs(v - target)
         if score<minscore then
             minscore = score
             minimal = k
         end

        --meaningful word position: (take most popular key on topmost position which can perform case split)
 
    end
    if totals[minimal]==count then
        return false 
    end
    
    return minimal
end
function node_meta:SelectKeyWordrank(bannedkeys)
    local totals = {}
    local totals_b = {}
    local count = 0
    local keycount = 0
    for k,v in pairs(self.cases) do
        for kk,vv in pairs(v[1]) do
            if not bannedkeys[kk] then
                local y = totals[vv] or {}
                totals[vv] = y
                

                local x = y[kk] 
                if not x then
                    x = 0
                end
                y[kk] = x + 1

                
                local x = totals_b[kk] 
                if not x then
                    x = 0
                    keycount = keycount + 1
                end
                totals_b[kk] = x + 1
            end
        end
        count = count + 1
    end


    if keycount==1 then
        return false
    end

    local target = count/2
    local minimal
    local minscore = 0
    for k,v in pairs(totals) do 
        --meaningful word position: (take most popular key on topmost position which can perform case split)
        for kk,vv in pairs(v) do
            local c = totals_b[kk]
            if vv>minscore and c<count and c>0 then
                minscore = vv 
                minimal = kk
            end 
        end
        if minimal then
            break
        end
    end 
    
    return minimal
end
function node_meta:Split(bannedkeys)
    bannedkeys = bannedkeys or {}
    local key = self:SelectKeyWordrank(bannedkeys)
    if key then 
        self.key = key

        local y = DecisionTree()
        local n = DecisionTree()
        self.y = y 
        self.n = n
        for k,v in pairs(self.cases) do
            if v[1][key] then
                y:AddCase(v)
            else
                n:AddCase(v)
            end
        end

        bannedkeys[key] = true

        y:Split(bannedkeys)
        n:Split(bannedkeys)
    end
end
function node_meta:Run(input)
    if self.key then
        if input[self.key] then
            return self.y:Run(input)
        else
            return self.n:Run(input)
        end
    else
        return self.cases
    end
end
function node_meta:ToTable(t)
    if self.key then
        local sub = {}
        self.y:ToTable(sub)
        t[self.key] = sub

        self.n:ToTable(t)
        
    else
        t._cases = #self.cases
    end
end
node_meta.__index = node_meta

 

local t = DecisionTree()

local function G(x)
    local words = string.getwords(x)
    local ordered_set = {}
    for k,v in ipairs(words) do
        ordered_set[v] = k
    end
    return ordered_set--table.set(string.getwords(x))
end

t:Add({G"how are you?"},                            {G"i am {value}"})
t:Add({G"what are you doing?"},                     {G"i am {value}"})
t:Add({G"what is your name?", G"who are you?"},     {G"i am {value}",G"my name is {value}"})
t:Add({G"who i am?",G"who am i?"},                  {G"you are {value}"}) 
t:Add({G"where are we?"},               {G"we are in {value}"})
t:Add({G"where are am?"},               {G"you are in {value}"})
t:Add({G"where are you?"},              {G"i am in {value}"})
--t:Add({G"i am you? _yes"},              {G"no"})

t:Split()
local af = {}
t:ToTable(af)

local uufa = t:Run(G"what?")

local U = {}