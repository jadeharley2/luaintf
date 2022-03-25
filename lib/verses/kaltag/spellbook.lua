

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

    if srcmind and trgmind then
        srcmind:swap_memory('mind_'..srcperson.id,'mind_'..trgperson.id)
        trgmind:swap_memory('mind_'..srcperson.id,'mind_'..trgperson.id)
        srcmind:swap_memory('nameof_'..srcperson.id,'name_'..trgperson.id)
        trgmind:swap_memory('nameof_'..srcperson.id,'name_'..trgperson.id)
    end

    rawset(srcperson,'mind',trgmind)
    rawset(trgperson,'mind',srcmind) 

    local psrcp = players[srcperson] 
    local ptrgp = players[trgperson] 

    if player==trgperson then
        player = srcperson 
    elseif player==srcperson then
        player = trgperson 
    end

    players[trgperson] = psrcp
    players[srcperson] = ptrgp

    send_character_images(srcperson.location)
    if trgperson==player then 
        examine(srcperson) 
        send_actions() 
    end
end

transfer_soul_action = Def('transfer_soul_action',{key='soultransfer',callback = function(self,arg1,...) 
    local is_player = self == player  
    if arg1 then
        local v = LocalIdentify(arg1)
        if v and v:is(person) then

            --if players[v] then 
            --    printout('this character is occupied')
            --else
                describe_action(self,L'you focus on [v]',tostring(self)..' stares at '..tostring(v))  
                sleep(0.1)
                describe_action(self,'you blackout',tostring(self)..' falls on the floor')  
                local srcperson = self
                local trgperson = v 
                
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
            --end 
            return true
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
    send_actions() 
end
