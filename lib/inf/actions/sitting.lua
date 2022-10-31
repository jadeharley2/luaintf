

person.pose = 'standing'

sits_on = Def('sits_on',{},"relation")
sit_interaction = Def('sit_interaction',{key='sit',user_restrictions = {"can_move"},callback = function(self,user)  
    local is_player = user == player 
   
    local capacity = self.capacity or 1
    local occupied = #GetRelations(self,sits_on)
    if capacity>occupied then
        if not user:is('bound') then
            MakeRelation(user,self,sits_on)
            --if something:adj_isset('')
            user:adj_set('bound')
            describe_action(user,L'you sit on [self]',tostring(user)..' sits on '..tostring(self)) 

            user.pose = 'sitting'
            user:act_add(standup_action) 
            send_actions(user)
            
            return true
        end
    else
        if is_player then printout(L'[self] is occupied') end
    end
   
    return false

end},'interaction')


lay_interaction = Def('lay_interaction',{key='lay',user_restrictions = {"can_move"},callback = function(self,user)  
    local is_player = user == player 
   
    local capacity = self.capacity or 1
    local occupied = #GetRelations(self,sits_on)
    if capacity>occupied then
        if not user:is('bound') then
            MakeRelation(user,self,sits_on)
            --if something:adj_isset('')
            user:adj_set('bound')
            describe_action(user,L'you lay on [self]',tostring(user)..' lays on '..tostring(self)) 

            user.pose = 'laying'
            user:act_add(standup_action) 
            send_actions(user)
            
            return true
        end
    else
        if is_player then printout(L'[self] is occupied') end
    end
   
    return false
    
end},'interaction')


standup_action = Def('standup_action',{key='standup',restrictions = {"can_move"},callback = function(self)  
    local is_player = self == player 
    local chair = GetRelationOther(self,sits_on) 
    DestroyRelations(self,sits_on)
    self:adj_unset('bound')
    if chair then

        describe_action(self,L'you stand up from [chair]',L'[self] stands up from [chair]')  
        self:act_rem(standup_action) 
        self.pose = 'standing'
        send_actions(self)
             
        return true
    else
        if is_player then printout('you are not sitting') end
    end 
    return false

end},'action')

--person:act_add(sit_action) 
--person:act_add(standup_action) 
