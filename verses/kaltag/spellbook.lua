

read_interaction = Def('read_interaction',{key='read',callback = function(self,user,act,arg1,...)  
    if user.robotic then
        describe_action(user,'scanning '..tostring(self)..'...',tostring(user)..' scans '..tostring(self)) 
    else
        describe_action(user,'you read a '..tostring(self),tostring(user)..' reads a '..tostring(self)) 
    end
    self:call('on_read',user)  
end},'interaction') 

function mind_transfer(srcperson,trgperson)

    local srct = rawget(srcperson,'topics')
    local trgt = rawget(trgperson,'topics')

    rawset(trgperson,'topics',srct)
    rawset(srcperson,'topics',trgt)


    local srcmind = rawget(srcperson,'mind')
    local trgmind = rawget(trgperson,'mind')

    if srcmind and trgmind and srcmind ~=no_mind and trgmind~=no_mind then
        srcmind:swap_memory('mind_'..srcperson.id,'mind_'..trgperson.id)
        trgmind:swap_memory('mind_'..srcperson.id,'mind_'..trgperson.id)
        srcmind:swap_memory('nameof_'..srcperson.id,'name_'..trgperson.id)
        trgmind:swap_memory('nameof_'..srcperson.id,'name_'..trgperson.id)
    end

    rawset(srcperson,'mind',trgmind or no_mind)
    rawset(trgperson,'mind',srcmind or no_mind) 

    local psrcp = players[srcperson] 
    local ptrgp = players[trgperson] 

    local srcp = srcperson.player 
    local trgp = trgperson.player 

    --srcperson.player = trgp
    --trgperson.player = srcp

    if player==trgperson then
        player = srcperson 
    elseif player==srcperson then
        player = trgperson 
    end
--
    players[trgperson] = psrcp
    players[srcperson] = ptrgp
    
    send_character_images(srcperson.location)
    send_actions(srcperson) 
    send_actions(trgperson) 
    --send_style(srcperson)
    --send_style(trgperson)
end

transfer_soul_action = Def('transfer_soul_action',{key='soultransfer',callback = function(self,arg1,...) 
    local is_player = self == player  
    if self.block_mind_transfer then
        if is_player then printout('transfer blocked ') end
        return false
    end
    if arg1 then
        local v = LocalIdentify(arg1)
        if v and v:is(person) then
            if v.block_mind_transfer then
                if is_player then printout('transfer blocked ') end
                return false
            else

            --if players[v] then 
            --    printout('this character is occupied')
            --else
                describe_action(self,L'you focus on [v]',tostring(self)..' stares at '..tostring(v))  
                sleep(0.1)
                describe_action(self,'you blackout',tostring(self)..' falls on the floor')  
                local srcperson = self
                local trgperson = v 
                
                local srctask = srcperson.task 
                local trgtask = trgperson.task
                
                if not v:act_get(transfer_soul_action) then
                    self:act_rem(transfer_soul_action)
                    v:act_add(transfer_soul_action)
                end

                mind_transfer(srcperson,trgperson)
 

                local srcmind = rawget(srcperson,'mind')
                local trgmind = rawget(trgperson,'mind')
                
                if srcmind then 
                    srcmind.memory.swap_lie = math.random()>0.5
                end
                if trgmind then
                    trgmind.memory.swap_lie = math.random()>0.5
                end

                sleep(1) 
                if is_player then
                    printout('you are now',v) 
                end 
 
                ScenarioRun("mind_transformation",v.id..'_mtf',{
                    source = srcperson,
                    target = trgperson, 
                    duration = 60,
                    task = trgtask,
                },true) 
                ScenarioRun("mind_transformation",self.id..'_mtf',{
                    source = trgperson,
                    target = srcperson, 
                    duration = 60,
                    task = srctask,
                },true)  
                
            --end 
                return true
            end
        else
            if is_player then printout('there is no '..arg1) end
        end 
    else
        if is_player then printout('specify target') end
    end
    

end},'action') 


matchclothes_action = Def('matchclothes_action',{key='matchclothes',callback = function(self,arg1,...) 
    local is_player = self == player  
    if arg1 then
        local v = LocalIdentify(arg1)
        if v and v:is(person) then
            describe_action(self,L'you focus on [v]',tostring(self)..' stares at '..tostring(v))  
            sleep(0.1)
 
            local top_owner = false
            local top_count = 0
            for k2,v2 in pairs(v.clothes) do
                local owner = v2.owner 
                if not top_owner then
                    top_owner = owner  
                    top_count = 1
                elseif top_owner~=owner then
                    printout('spell breaks, target has clothes from multiple people.')
                    return false
                else
                    top_count = top_count + 1
                end
            end
            if top_owner then
                if top_count>=3 then
                    printout(L'[v] is changing')  
                    sleep(1)

                    if not v.original_image then
                        v.original_image = v.image 
                    end
                    v.image = top_owner.original_image or top_owner.image

                    send_character_images(v.location)
                    printout('$display:target;'..v.id..';'..(v.image or ''))
                    return true
                else
                    printout('spell breaks, target should have at least 3 owned clothing.')
                    return false
                end 
            else
                printout('spell breaks, target does not have any owned clothing.')
                return false
            end

            
        else
            if is_player then printout('there is no '..arg1) end
        end 
    else
        if is_player then printout('specify target') end
    end
    

end},'action') 


 
spell_book = Def('spell_book',{name='Strange book', description = 'strange'},'book')

spell_book.description = 'an ordinary book'
spell_book:interact_add(read_interaction)
spell_book.on_read = function(self,user)
    if user==player then
        if user.robotic then
            printout('deep learning session completed')
        else
            printout('you learn something')
        end
    end
    user:act_add(transfer_soul_action)
    user:act_add(matchclothes_action)
    send_actions(user) 
end

function only_once(cache,value)
    if not cache[value] then
        cache[value] = true
        return value
    end
end

Scenario("mind_transformation",{
    process = function(data)
        local d = data.duration or 30
        local target = data.target
        local memory = target.memory
        local style_prev = memory.view_style or data.source.view_style
        local style_next = target.view_style
 
        local ids_start = target:get_identity_strength(target)
        local switched = target.identity~=target


        target.block_mind_transfer = true

        local ph_c = {}
        for k=0,d do
            local blend = blend_view_styles(style_prev,style_next,k/d) 
            send_style(target,css_view_style(blend)) 
            memory.view_style = blend 
            cor.wait(1)
            if switched then
                if math.random()>0.9 then
                    local phrase = only_once(ph_c,table.random({ 
                        "something feels different",
                        "something is different",
                        "something is changing",
                        "[target]'s personality overwhelms you",
                        "you feel your mind changing",
                        "you feel more like [target]",
                        'you feel less like [target.identity]'}))
                    if phrase then
                        printto(target,L(phrase))
                    end
                end
            else  
                if math.random()>0.9 then
                    local phrase = only_once(ph_c,table.random({ 
                        "something feels different",
                        "something is different",
                        "something is changing",
                        "your personality stabilizes", 
                        "you feel more like yourself",
                        'you feel less like [data.source]'})) 
                    if phrase then
                        printto(target,L(phrase))
                    end
                end
            end
            local nid = ids_start + (1 - ids_start) * (k/d)
           
            target:set_identity_strength( data.source,1-nid)
            target:set_identity_strength(target,nid)
        end
        send_style(target) 
        --if target.identity~=target then
            target.identity = target  
            target.task = data.task  
            printto(target,'you feel different')
            target.block_mind_transfer = nil
        --end
    end
})