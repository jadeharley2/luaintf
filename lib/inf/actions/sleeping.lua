
DefConditional('can_sleep','!dead !in_combat !asleep')
DefConditional('can_wakeup','!dead !in_combat asleep')

sleep_action = Def('sleep_action',{key='sleep',restrictions = {"can_sleep"},callback = function(self)  
    local is_player = self == player 
    
    describe_action(self,'you fall asleep',L'[self] falls asleep')  
    self:adj_set('asleep')
    printout('$display:background;clear')
    printout('$display:line;clear')
    printout('$display:target;clear')
    printout('$display:clothes;clear')
    send_actions(self)
end},'action')
wakeup_action = Def('wakeup_action',{key='wakeup',restrictions = {"can_wakeup"},callback = function(self)  
    local is_player = self == player 
   
    self:adj_unset('asleep')
    describe_action(self,'you wake up',L'[self] wakes up')  
    send_actions(self)
    
    if is_player then examine(player.location) end
end},'action')
person:act_add(sleep_action) 
person:act_add(wakeup_action) 