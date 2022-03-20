

local punctuation = {
   -- ['…'] = "[mpoint]",
   -- ["..."] = "[mpoint]",
   -- [".."] = "[mpoint]",
    ["."] = "[point]",
    [","] = "[comma]",
    ["!"] = '[exclamation]',
    ["?"] = '[question]',
    ["("] = '[lbr]',
    [")"] = '[rbr]',
    [";"] = '[semicolon]',
    [":"] = '[colon]',
    ["/"] = '[div]',
    ["\\"] = '[div]',
    ["|"] = '[div]',
} 

local test = [[
    Well! Um...My parents and I grew up outside the big city. 
    They were both bakers, even my uncle, who owned an old-fashioned one downtown, in central Kan Rein. 
    That's where Nytro lives and works too! When my uncle passed, around when I turned 18, I asked to move in and take it over so it wouldn't get closed...it's tough stuff. 
    But Nyt and some others help me out with it...But! Anyway! 
    I just really like baking. Sorry it's so simple..whuff.
]]
local test2 = [[
    Oh I can try...I do wish Ayn was here to answer though. 
    The Queen of Siania rules over the matriarchal society of the Queendom of Siania. 
    I know perhaps that word sounds strange to you on Terra, but Siania has always been ruled by female figures before the male lines. 
    Ayn's mother Kesis rules all systems in Siania, roughly 2,000. 
    Periodic disputes make that number change, and most systems have only one habitable or colonized planet, but the population of the Queendom in total is roughly 28 billion.
]]
function lines_from(file) 
    local lines = {}
    for line in io.lines(file) do 
      lines[#lines + 1] = line
    end
    return lines
  end

local test_z = lines_from('data/sentences.txt')
local z_parts = {}
local cpart = {}
for k,v in ipairs(test_z) do
    if v=="" then
        if #cpart>0 then z_parts[#z_parts+1] = table.concat(cpart,'   ') end
        cpart = {}
    else
        cpart[#cpart+1] = v
    end
end
if #cpart>0 then z_parts[#z_parts+1] = table.concat(cpart,'   ') end
 
--local test_z  = io.ope

local meta_knn = {
    
    learn = function(self,tokens, len)
        local tlen = #tokens
        for k=1,tlen-1 do
            local node = self.root
            node.count = node.count + 1
            local mlen = math.min(len,tlen-k)

            for j=0,mlen-1 do
                local token = tokens[k+j]

                local nxnode = node.next[token]
                if not nxnode then
                    nxnode = {
                        count = 1,
                        next = {},
                    }
                    node.next[token] = nxnode
                else
                    nxnode.count = nxnode.count + 1
                end
                node = nxnode
            end
        end
    end,
    predict = function(self,tokens)
        local node = self.root
        for k,v in ipairs(tokens) do
            if node then  
                node = node.next[v]
            else
                return nil
            end
        end
        local nxt = (node or {}).next
        
        return nxt
    end,
    trace = function(self,node,max)
        max = max or 8
        if node and max>0 then
            local token, nx = table.randomkv(node)
            if token then 
                return token.." ".. self:trace(nx.next,max-1)
            else
                return ""
            end
        else
            return ""
        end
    end,
}
meta_knn.__index = meta_knn

function Knn()
    return setmetatable({root = {next={},count=0}},meta_knn)
end

--subj(i) do(wish,now) subj(ayn) do(was here,now) do(to answer)
--[[
 Ayn's mother Kesis rules all systems in Siania, roughly 2,000. 

 link(type,from,to)
 link('mother','ayn','kesis')
 link('ruler','siania','kesis')

 "all systems in siania"
 link('count','siania systems','roughly 2000')

]]
local wdb = { }
function Word(data)
    
    if data.singular then wdb[data.singular] = data end 
    if data.plural then wdb[data.plural] = {plural_of = data} end
end
function Noun(data)
    data.type = 'noun'
    if data.plural==nil then
        local sing = data.singular
        if sing:ends_with_any('s', 'sh', 'ch', 'x', 'z') then
            data.plural = (sing..'es')
            
        elseif sing:ends_with('y') then
            data.plural = (sing:sub(1,#sing-1)..'ies')
        
        else
            data.plural = (sing..'s')
        end
    end
    Word(data)
end
function Verb(data)
    data.type = 'verb'
    Word(data)
end
function Adjective(data)
    data.type = 'adjective'
    Word(data)
end
function Adverb(data)
    data.type = 'adverb'
    Word(data)
end

Noun({singular = 'parent'})
Noun({singular = 'baker'})
Noun({singular = 'life', plural='lives'})
Noun({singular = 'work'})
Noun({singular = 'uncle'})
Noun({singular = 'downtown'})
Noun({singular = 'stuff'})
Noun({singular = 'city'})
Noun({singular = 'outside'})

Noun({singular = 'word'})
Noun({singular = 'queen'})
Noun({singular = 'king'})
Noun({singular = 'rule'})
Noun({singular = 'society'})
Noun({singular = 'sound'})
Noun({singular = 'male'})
Noun({singular = 'female'})
Noun({singular = 'line'})
Noun({singular = 'mother'})
Noun({singular = 'father'})
Noun({singular = 'son'})
Noun({singular = 'daugter'})
Noun({singular = 'sister'})
Noun({singular = 'brother'})
Noun({singular = 'friend'})
Noun({singular = 'relative'})
Noun({singular = 'system'})
Noun({singular = 'dispute'})
Noun({singular = 'number'})
Noun({singular = 'colony'})
Noun({singular = 'planet'})
Noun({singular = 'population'})
Noun({singular = 'total'})

Noun({singular = 'child', plural = 'children'})
Noun({singular = 'goose', plural = 'geese'})
Noun({singular = 'man', plural = 'men'})
Noun({singular = 'woman', plural = 'women'})
Noun({singular = 'tooth', plural = 'teeth'}) 
Noun({singular = 'foot', plural = 'feet'}) 
Noun({singular = 'mouse', plural = 'mice'}) 
Noun({singular = 'person', plural = 'people'})  

Verb({singular = 'wait'})
Verb({singular = 'grow', past_simple = 'grew',  continuous='growing'})
Verb({singular = 'move', past_simple = 'moved', continuous='moving'})

Adjective({singular='sorry'})
Adjective({singular='big'})
Adjective({singular='old'})
Adjective({singular='fashioned'})
Adjective({singular='old-fashioned'}) 
Adjective({singular='tough'})
Adjective({singular='simple'})
Adjective({singular='strange'})
Adjective({singular='habitable'})
Adjective({singular='colonized'})

Adverb({singular='roughly'})

function Tokenize(text)
    
    local tokens = {}
    local last_id=0
    local textlen = #text
    for k=1,textlen do
        local char = text:sub(k,k)
        local pnc = punctuation[char]
        if pnc then
            if last_id<k-1 then
                tokens[#tokens+1] = text:sub(last_id,k-1) 
            end
            --last_id = k

            tokens[#tokens+1] = pnc
            last_id = k+1
            --for k2,punc in pairs(punctuation) do
            --    local plen = #k2
            --    local subt =text:sub(k,k+plen-1)
            --    if k2 == subt then
            --        tokens[#tokens+1] = punc
            --        last_id = k+plen
            --        break
            --    end 
            --end
        elseif char==' ' then
            if last_id<k-1 then
                tokens[#tokens+1] = text:sub(last_id,k-1) 
            end
            last_id = k+1
        end
    end
    if last_id<textlen then
        tokens[#tokens+1] = text:sub(last_id,textlen) 
    end
    return tokens
end

local pronouns = {
    they = {
        plural = true,
    },
    he = {
        gender = 'male', 
    },
    she = {
        gender = 'female', 
    },
    it = {
        gender = 'neuter', 
    },
    I = {
        speaker = true,
    },
    my = {
        speaker = true,
    },
    mine = {
        
    },

}

local texd = Tokenize(test2)




local testkk = Knn()
for k,v in pairs(z_parts) do
    testkk:learn(Tokenize(v:lower()),8)
end
--testkk:learn(Tokenize(test),4)
--testkk:learn(Tokenize(test2),4)

function stupid(inp,len,times) 
    local intokens = Tokenize(inp)
    local test_333 = testkk:predict(intokens,len+3)
    local rre = testkk:trace(test_333)
    local outtk = {}
    for k=1,times do 
        local cs = Tokenize(rre)
        intokens = {cs[#cs-2],cs[#cs-1],cs[#cs]}
        test_333 = testkk:predict(intokens,len+3)
        rre = testkk:trace(test_333)
        for uu=1,len do
            outtk[#outtk+1] = cs[uu]
        end 
    end


    
    return inp.." "..table.concat(outtk,' ')
end
 
while true do
    local input = io.read():trim()
    
    local result = stupid(input,4,10)
    print(result) 


    ---for k=1,20 do 
    ---    local result = stupid(input,4,10)
    ---    local nt = Tokenize(result)
---
    ---    --local last4 = {}
    ---    --for kk,vv in ipairs(nt) do
    ---    --    if kk>#nt-4 then
    ---    --        last4[#last4+1] = vv
    ---    --    end
    ---    --end 
    ---    if #nt<3 then 
    ---        break 
    ---    end 
---
    ---    input =  nt[#nt-2]..' '..nt[#nt-1]..' '..nt[#nt]--table.concat(last4)
    ---    
    ---    if input:trim()==result:trim() then 
    ---        break
    ---    end
    ---    print(result) 
---
    ---end
end

local nouns = {}
for k,v in ipairs(texd) do
    local lform = v:lower()
    local pronoun = pronouns[lform] 
    if pronoun then
        local u  =0
        texd[k] = {word = lform,type='pronoun',data = pronoun}
    else
        local data = wdb[lform] 
        if data then
            texd[k] = {word = lform,type=data.type,data = data}

        end
        --if v:sub(1,1):isupper() then
        --    texd[k] = {word = lform,type='noun',capitalize = true,data = {}}
        --end
    end

end
local u = 0