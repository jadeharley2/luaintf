

sits_on = Def('sits_on',{},"relation")
sit_action = Def('sit_action',{key='sit',restrictions = {"!asleep"},callback = function(self,target)  
    local is_player = self == player 
    if target then
        local something = LocalIdentify(target)
        if something then
            
            MakeRelation(self,something,sits_on)
            --if something:adj_isset('')
            describe_action(self,L'you sit on [something]',tostring(self)..' sits on '..tostring(something))  
            
            
            return true
        else
            if is_player then printout('there is no '..target) end
        end 
    else
        if is_player then printout('sit on what?') end
    end
end},'action')

standup_action = Def('standup_action',{key='stand',restrictions = {"!asleep"},callback = function(self)  
    local is_player = self == player 
    local chair = GetRelations(self,sits_on)[1]
    if chair then

        DestroyRelations(self,sits_on)
        describe_action(self,L'you stand up',tostring(self)..' stands up')  
             
        return true
    else
        if is_player then printout('you are not sitting') end
    end 
end},'action')

person:act_add(sit_action) 
person:act_add(standup_action) 
