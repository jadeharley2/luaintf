
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
    --_get_name = function(s) return s.id end,
    --_get_description = LF'You see nothing special about [self.name].',
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
                    local rem = topic.f(self,from,about)
                    if topic.delete then
                        self.topics[about] = nil 
                    end
                    if rem then
                        self.topics[about] = nil 
                    end
                    return true
                end
            end) 
        end
    end,
    hear = function(self,source,text,mode)
        --if self~=source then
            if client then
                local cli = players[self]
                if cli then
                    if mode == 'ambient' then
                        cli.socket:send('    '..text..'\n')
                    else -- speech
                        local xnm = source.name 
                        local src = self.memory['mind_'..source.id]
                        if src then xnm = xnm..'('..src.name..')' end
                        cli.socket:send('    $gk'..xnm..'$wk: %2'..text..'\n')
                    end
                end
                --printout('    '..source.name..': '..text)
            else
                if player == self then
                    if mode == 'ambient' then
                        printout('    '..text)
                    else -- speech
                        local xnm = source.name 
                        local src = self.memory['mind_'..source.id]
                        if src then xnm = xnm..'('..src.name..')' end
                        printout('    $gk'..xnm..'$wk: %2'..text)
                    end
                end 
            end
        --end
    end,
    process_speech = function(self,text)
        return text
    end,
    say = function(self,text)  
        if text then
            local ts = s
            s = self 
            text = self:process_speech(L(text))
            s = ts

            print(self,text)
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








person.examine = function(target, ex)
    if target == player then
            if target.identity~= player then
                printout(L"You are inhabiting the body of [target]. You think you are still [target.personality], at least mentally.")
            else
                printout(L"that's you, [target]")
            end


            local worn = {}
            local things = {}
            local body_parts = {}

            target:foreach('contains',function(k,v)
                if k~=player then
                    if k.is_worn then
                        worn[#worn+1] = tostring(k)
                    elseif k:is('body_part') then 
                        if k:call('should_display',target)~=false then
                            body_parts[#body_parts+1] = k.description
                        end
                    else
                        things[#things+1] = tostring(k)
                    end 
                end
            end)
 
            if #worn>0 then
                printout('you are wearing: '..table.concat(worn,', ')) 
            end
            if #things>0 then
                printout('you have: '..table.concat(things,', ')) 
            end
            if #body_parts>0 then
                for k,v in pairs(body_parts) do
                    printout('your '..v) 
                end
            end
    else
        local sw = ex.memory['mind_'..target.id]
        if ex.identity==target then --sw then
            printout(L'This was your body untill you switched. [sw] should be in control.')
        elseif sw then
            local tsw = tostring(sw)
            local tnm = tostring(target)
            if tsw~=tnm then
                printout(L"Seems like [tsw] is inhabiting [tnm]'s body.")
            end
        end
        printout(target.description)

        local worn = target.clothes
        if #worn>0 then
            printout(L'[target.they] [target.are] wearing: '..table.concat(worn,', ')) 
        else
            printout(L'[target.they] [target.are] wearing nothing ') 
        end
        local body_parts = target:collect('contains',function(k,v)
            if k:is('body_part') and k:call('should_display',target)~=false then
                return k.description
            end
        end)
        if #body_parts>0 then
            for k,v in pairs(body_parts) do
                printout(target.their..' '..v) 
            end
        end
    end
end


