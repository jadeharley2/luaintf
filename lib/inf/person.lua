
local function cleanup_topics(self)
    local rt = rawget(self,'topics') or {}
    for k,v in pairs(rt) do
        if v.delete then
            rt[k] = nil
        end
    end
end

local function display_speech(self,source,text,cli)
    --local xnm = source.name 
    --local src = self.memory['mind_'..source.id]
    --if src and src~=source then xnm = xnm..'('..src.name..')' end

    local name = self.mind:get_known(source,'name') -- self.memory['mind_'..source.id]
    --if src and src~=source then xnm = xnm..'('..src.name..')' end
    local xnm = name or "???"

    return '    $gk'..xnm..'$wk: %2'..text..'\n'
end

person = Def('person',{
    name = "Someone",
    --_get_name = function(s) return s.id end,
    --_get_description = LF'You see nothing special about [self.name].',
    _get_perceived_name = function(self)
        if player then
            return player.mind:get_known(self,'name') or "unknown"
        else
            return self.name
        end
    end, 
    __tostring = function(self)
        if player then
            return player.mind:get_known(self,'name') or self.unknown_name or "unkn:"..tostring(self.numid) --self.unknown_name or "unknown"
        else
            return self.name
        end
    end,
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
        if not self:adj_isset('asleep') then
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
        end
    end,
    hear = function(self,source,text,mode)
        if not self:adj_isset('asleep') then 
            if client then
                local cli = players[self]
                if cli then
                    if mode == 'ambient' then
                        cli:send('    '..text..'\n')
                    else -- speech
                         
                        cli:send(display_speech(self,source,text))
                    end
                end
                --printout('    '..source.name..': '..text)
            else
                if player == self then
                    if mode == 'ambient' then
                        printout('    '..text)
                    else -- speech 
                        printout(display_speech(self,source,text))
                    end
                else
                    local p = self.player
                    if p then 
                        p:send(display_speech(self,source,text))
                    end
                    
                end 
            end 
        end
    end,
    process_speech = function(self,text)
        return text
    end,
    say = function(self,text)  
        if text then
            if not self:adj_isset('asleep') and not self:adj_isset('mute') then
                local ts = s
                s = self 
                text = self:process_speech(L(text))
                s = ts

                --print(self,text)
                self.location:foreach('contains',function(k,v)
                    local hear = k.hear 
                    if hear then
                        hear(k,self,text)
                    end
                end)  
            end
        end
    end,
    on_spawn = function(self)
        print('spawned!',self,'at', self.location)
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
person.mood = "ok"
--person:adj_set("male")

likes = Def('likes',{},"relation")


person.should_wear_clothes = true



 
person.examine = function(target, ex)
    printout('$display:target;clear') 
    printout('$name:'..tostring(target))
    send_health(player,target)
    send_character_visuals(player,target)
    
    if target == player then
        
        if target.identity~= player then
            if target.costume then
                printout(L"You are wearing [target] costume. You are still [target.identity] inside.")
            else
                if player.robotic then
                    printout(L"Your frame designation is [target]. Warning: Detected mismatched personality core: [target.identity].")
                else
                    printout(L"You are inhabiting the body of [target]. You think you are still [target.identity], at least mentally.")
                end
            end
        else
            if player.robotic then
                printout(L"Your designation is [target]")
            else
                printout(L"that's you, [target]")
            end
        end


        local worn = {}
        local things = {}
        local body_parts = {}

        target:foreach('contains',function(k,v)
            if k~=player then
                if k:is('person') then 
               --     things[#things+1] = k
                elseif k.is_worn then
                    worn[#worn+1] = k
                elseif k:is('body_part') then 
                    if k:call('should_display',target)~=false then
                        body_parts[#body_parts+1] = k.description
                    end
                else
                    things[#things+1] = k
                end 
            end
        end,true)

        if #worn>0 then
            plain_owner = target
            if player.robotic then
                printout('equipped items: '..table.concat(worn,', ')) 
            else
                printout('you are wearing: '..table.concat(worn,', ')) 
            end
            plain_owner = false
        end
        if #things>0 then
            if player.robotic then
                printout('storage contents: '..table.concat(things,', ')) 
            else
                printout('you have: '..table.concat(things,', ')) 
            end
        end
        if #body_parts>0 then
            for k,v in pairs(body_parts) do
                printout('your '..v) 
            end
        end
        

        printout('$display:clothes;clear')
        for k,v in pairs(worn) do
            if v.image then
                printout('$display:clothes;'..v.id..';'..v.image..';'..v.image_style_css)
            end
        end
        for k,v in pairs(things) do
            if v.image then
                printout('$display:clothes;'..v.id..';'..v.image..';'..v.image_style_css)
            end
        end
        
        local chair = GetRelationOther(target,sits_on) 
        if chair then
            printout(L'you are [target.pose] on [chair]')  
        end

        printout('$display:target;'..target.id..';/null.png') 
    else 
        local sw = ex.memory['mind_'..target.id]
        if ex.identity==target then --sw then
            if player.robotic then
                printout(L'Memory reads [target] as your previous frame.')
            else
                printout('This was your body untill you switched.') 
            end
            if sw then
                printout(L'[sw] should be in control.') 
            end
        elseif sw then
            local tsw = tostring(sw)
            local tnm = tostring(target)
            if tsw~=tnm then
                if player.robotic then
                    printout(L"Memory reads [tnm] contains [tsv]'s personality.")
                else
                    printout(L"Seems like [tsw] is inhabiting [tnm]'s body.")
                end
            end
        end
        printout(target.description)
         
        if target:is('asleep') then
            if target:is('anthroid') then 
                printout(L"[target.they] [target.are] deactivated.")
            else
                printout(L"[target.they] [target.are] asleep.")
            end
        end
        if target:is('dead') then
            printout(L'[target.they] [target.are] dead')
        end

        local size =player:relative_textsize(target)
        if size~='normal' then
            printout(L"[target.they] [target.are] [size].")
        end

        local worn = target.clothes
        if #worn>0 then
            plain_owner = target
            printout(L'[target.they] [target.are] wearing: '..table.concat(worn,', ')) 
            plain_owner = false
        elseif target.should_wear_clothes then
            printout(L'[target.they] [target.are] wearing nothing ') 
        end

        local chair = GetRelationOther(target,sits_on) 
        if chair then
            printout(L'[target.they] [target.are] [target.pose] on [chair]')  
        end


        printout('$display:clothes;clear')
        for k,v in pairs(worn) do
            if v.image then
                printout('$display:clothes;'..v.id..';'..v.image..';'..v.image_style_css)
            end
        end

        local body_parts = target:collect('contains',function(k,v)
            if k:is('body_part') and k:call('should_display',target)~=false then
                return k.description
            end
        end,true)
        if #body_parts>0 then
            for k,v in pairs(body_parts) do
                printout(target.their..' '..v) 
            end
        end


        local image = target.image
        if image then 
            printout('$display:target;'..target.id..';'..image..';'..target.image_style_css) 
        end
    end
end

person.get_reachables = function(self, user, output)  
    output[#output+1] = self
    if self==user then
        self:foreach('contains',function(k,v)
            local r = k.get_reachables 
            output[#output+1] = k
            if r then 
                r(k,user,output)
            end 
        end) 
    end 
end
 
function person:_get_icon()
    local img = self.image
    if img then 
        local ext = img:sub(-4)
        return img:sub(1,-5)..'_av'..ext
    end
end 