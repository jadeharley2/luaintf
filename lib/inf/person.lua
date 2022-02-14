
local function cleanup_topics(self)
    local rt = rawget(self,'topics') or {}
    for k,v in pairs(rt) do
        if v.delete then
            rt[k] = nil
        end
    end
end

person = Def('person',{
    name = "Someone",
   -- _get_description = LF'You see nothing special about [self.name].',
    topics = {},
    response = function(self,about,event,del)
        self.topics = rawget(self,'topics') or {}
        local t = {
            f = event,
            delete = del or false,
        }
        if del then t.expiration = turn+1 end
        self.topics[about] = t
    end,
    respond = function(self,from,about)
        if not players[self] then
            self:foreach('topics',function(k,topic) 

                if string.wmatch(about,k) then 
                    topic.f(self,from,about)
                    if topic.delete then
                        self.topics[about] = nil 
                    end
                    return true
                end
            end) 
        end
    end,
    hear = function(self,source,text,mode)
        if self~=source then
            if client then
                local cli = players[self]
                if cli then
                    if mode == 'ambient' then
                        cli.socket:send('    '..text..'\n')
                    else -- speech
                        cli.socket:send('    $gk'..source.name..'$wk: %2'..text..'\n')
                    end
                end
                --printout('    '..source.name..': '..text)
            else
                if player == self then
                    if mode == 'ambient' then
                        printout('    '..text)
                    else -- speech
                        printout('    $gk'..source.name..'$wk: %2'..text)
                    end
                end
                --[[
                if player == self then
                    if mode == 'ambient' then
                        for k=1,#text do
                            local char = text:sub(k,k) 
                            io.write(char)
                            sleep(0.1)
                        end
                    else -- speech
                        io.write('    '..source.name..': ')
                        for k=1,#text do
                            local char = text:sub(k,k) 
                            io.write(char)
                            if char==',' then
                                sleep(0.2)
                            elseif char=='.' then
                                sleep(0.4)
                            else
                                sleep(0.1)
                            end
                        end
                    end
                    io.write('\n')
                end
                ]]
            end
        end
    end,
    say = function(self,text)  
        if text then
            self.location:foreach('contains',function(k,v)
                local hear = k.hear 
                if hear then
                    hear(k,self,text)
                end
            end)  
        end
    end,
    on_init = function(self)
        self:set_updating(true)
    end,
    on_turn_end = function(self)
        local rt = rawget(self,'topics') or {}
        for k,v in pairs(rt) do
            if v.expiration and v.expiration < turn then
                rt[k] = nil
            end
        end
    end,
},'thing')

person:adj_set("living")
--person:adj_set("male")

likes = Def('likes',{},"relation")





--look and examine


function examine(target)  
    if target.examine then
        target:examine(player)
    else
        EventActCall("examine",target) 
    end
end

look_action = Def('look_action',{key='look',callback = function(self,direction)  
    local is_player = self == player
    if is_player then examine(self.location) end
    return nil -- no enturn
end,description='shorthand: l'},'action')
DefComAlias('l','look') 

examine_action = Def('examine_action',{key='examine',callback = function(self,target) 
    local is_player = self == player
    if is_player then
        if not target then 
            examine(player)
            return nil -- no enturn
        elseif target=='self' then
            printout('examine self')
            examine(player)
            return nil -- no enturn
        else 
            local v = LocalIdentify(target)
            if v then
                examine(v)
                return nil -- no enturn
            else
                printout('there is no '..target)
            end
        end
    end
end,description='shorthand: x'},'action')
DefComAlias('x','examine') 

--move

move_action = Def('move_action',{key='move',callback = function(self,direction) 
    local is_player = self == player
    local loc = self.location
    if loc:is(room) then
        local next = loc:dir(direction)
        if next then
            self.location = next
            if is_player then examine(next) end
            return true
        else
            if is_player then printout("you can't go that way") end
        end
    else
        if is_player then printout("you can't move") end
    end
end,description='shorthand: n, s, w, e, etc.'},'action')

for k,v in pairs(direction_map) do
    DefComAlias(k,{'move',k})
end

--take and drop items


take_action = Def('take_action',{key='take',callback = function(self,item) 
    local is_player = self == player 
    if item then
        local something = LocalIdentify(item)
        if something then
            something.location = self
            if is_player then 
                printout(item..' taken') 
            else
                --announce in room '[self] takes [item]'
            end
        else
            if is_player then printout('there is no '..item) end
        end 
    else
        if is_player then printout('take what?') end
    end
end},'action')


drop_action = Def('drop_action',{key='drop',callback = function(self,item) 
    local is_player = self == player 
    if item then
        local something = LocalIdentify(item,self)
        if something then
            something.location = self.location
            if is_player then 
                printout(item..' dropped') 
            else
                --announce in room '[self] drops [item]'
            end
        else
            if is_player then printout('there is no '..item) end
        end 
    else
        if is_player then printout('drop what?') end
    end
end},'action')
 



person:act_add(look_action)
person:act_add(examine_action)
person:act_add(move_action) 
person:act_add(take_action)
person:act_add(drop_action) 





--is this needed?
--talk to


talkto_action = Def('talkto_action',{key='talk',callback = function(self,target) 
    local is_player = self == player 
    
    local something = LocalIdentify(target)
    if something and something~=self then
        if something:is(person) then
            self.talk_target = something 
            if is_player then printout('you are now talking to ',something) end
            return true
        end
    end 

end},'action')

--say

say_action = Def('say_action',{key='say',callback = function(self,text) 
    local is_player = self == player 
  
    --local tlk = self.talk_target
    --if tlk then
        self:say(text)
        if tlk and tlk.location == self.location then
            tlk:respond(self,text)
            return true
        end
    --else
       --local something = LocalIdentify(com)
       --if something and something~=player then
       --    if something:is(person) then
       --        player.talk_target = something 
       --        printout('you are now talking to ',something)
       --        return true
       --    end
       --end 
    --end
    
end},'action')





person:act_add(talkto_action)
person:act_add(say_action) 



be_action = Def('be_action',{key='be',callback = function(self,target) 
    local is_player = self == player 
    if is_player then
        local v = Identify(target)
        if v and v:is(person) then
            if players[v] then 
                printout('this character is occupied')
            else
                players[player] = nil
                player = v 
                players[v] = client
                printout('you are now',v)
                return true
            end
        end
    end
end},'action')



EventAdd('examine','default',function(target)
    printout(target.description)
end)

EventAdd('before examine','player',function(target)
    if target == player then
        printout(L"that's you, [player]")
        local things = target:collect('contains',function(k,v)
            if k~=player then
                return tostring(k)
            end
        end)
        if #things>0 then
            printout('you have: '..table.concat(things,', ')) 
        end

        return true
    end
end)
EventAdd('before examine','room',function(target)
    if target:is(room) then
        printout(target.name..', '..target.description)

        local things = target:collect('contains',function(k,v)
            if k~=player then
                return tostring(k)
            end
        end)
        if #things>0 then
            printout('you see: '..table.concat(things,', ')) 
        end

        for k,v in pairs(target:adjascent(true)) do
            printout(' '..k.." -> "..tostring(v))
        end
        return true
    end
end)
