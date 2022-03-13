

read_interaction = Def('read_interaction',{key='read',callback = function(self,user,act,arg1,...)  
    describe_action(user,'you read a '..tostring(self),tostring(user)..' reads a '..tostring(self)) 
    self:call('on_read',user)  
end},'interaction') 


transfer_soul_action = Def('transfer_soul_action',{key='soultransfer',callback = function(self,arg1,...) 
    local is_player = self == player  
    if arg1 then
        local v = LocalIdentify(arg1)
        if v and v:is(person) then

            if players[v] then 
                printout('this character is occupied')
            else
                describe_action(self,L'you focus on [v]. And then blackout',tostring(self)..' stares at '..tostring(v))  
                sleep(0.1)
                describe_action(self,'you blackout',tostring(self)..' falls on the floor')  
                local srcperson = self
                local trgperson = v 
                
                if not v:act_get(transfer_soul_action) then
                    self:act_rem(transfer_soul_action)
                    v:act_add(transfer_soul_action)
                end

                local srct = rawget(srcperson,'topics')
                local trgt = rawget(trgperson,'topics')

                rawset(trgperson,'topics',srct)
                rawset(srcperson,'topics',trgt)


                local srcmind = rawget(srcperson,'mind')
                local trgmind = rawget(trgperson,'mind')

                local temp1 = srcmind.memory['mind_'..srcperson.id]
                srcmind.memory['mind_'..srcperson.id] = srcmind.memory['mind_'..trgperson.id] or trgperson
                srcmind.memory['mind_'..trgperson.id] = temp1 or srcperson

                local temp1 = trgmind.memory['mind_'..srcperson.id]
                trgmind.memory['mind_'..srcperson.id] = trgmind.memory['mind_'..trgperson.id] or trgperson
                trgmind.memory['mind_'..trgperson.id] = temp1 or srcperson

                rawset(srcperson,'mind',trgmind)
                rawset(trgperson,'mind',srcmind) 

                local pcli = players[self] 
                players[self] = nil

                if is_player then
                    player = v 
                end

                if pcli then
                    players[v] = pcli
                end
 
                srcmind.memory.swap_lie = math.random()>0.5
                trgmind.memory.swap_lie = math.random()>0.5

                sleep(1)
                send_character_images(self.location)
                if is_player then
                    printout('you are now',v)
                    examine(srcperson) 
                    send_actions() 
                end
                return true
            end 
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

                    v.original_image = v.image 
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
        printout('you learn something')
    end
    user:act_add(transfer_soul_action)
    user:act_add(matchclothes_action)
    send_actions() 
end
