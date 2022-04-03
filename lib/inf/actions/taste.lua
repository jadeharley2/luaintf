
thing.smell = 'nothing in particular'
thing.taste = 'nothing in particular'

sniff_action = Def('sniff_action',{key='sniff',restrictions = {"!asleep"},callback = function(self,item)  
    local is_player = self == player 
    if item then
        local something = LocalIdentify(item) or LocalIdentify(item,self)
        if something then
             
            describe_action(self,L'you sniff [something]... [something.they] smells like [something.smell]',tostring(self)..' sniffs '..tostring(item))  
            return true
        else
            if is_player then printout('there is no '..item) end
        end 
    else
        if is_player then printout('sniff what?') end
    end
end},'action')

lick_action = Def('lick_action',{key='lick',restrictions = {"!asleep"},callback = function(self,item)  
    local is_player = self == player 
    if item then
        local something = LocalIdentify(item) or LocalIdentify(item,self)
        if something then
             
            describe_action(self,L'you lick [something]... [something.they] tastes like [something.taste]',tostring(self)..' licks '..tostring(something))  
            return true
        else
            if is_player then printout('there is no '..item) end
        end 
    else
        if is_player then printout('lick what?') end
    end
end},'action')
eat_action = Def('eat_action',{key='eat',restrictions = {"!asleep"},callback = function(self,item)  
    local is_player = self == player 
    if item then
        local something = LocalIdentify(item) or LocalIdentify(item,self)
        if something then
             
            describe_action(self,L'you eat [something]... tastes like [something.taste]',tostring(self)..' begins to eat '..tostring(something))  
            Delay(3,function()
                if something.location==self.location then
                    something.location = self
                end
            end)
            return true
        else
            if is_player then printout('there is no '..item) end
        end 
    else
        if is_player then printout('eat what?') end
    end
end},'action')

person:act_add(sniff_action) 
person:act_add(lick_action) 
person:act_add(eat_action) 