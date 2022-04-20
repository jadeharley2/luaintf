
sleep_action = Def('sleep_action',{key='sleep',restrictions = {"!asleep"},callback = function(self)  
    local is_player = self == player 
    
    describe_action(self,'you fall asleep',L'[self] falls asleep')  
    self:adj_set('asleep')
    printout('$display:background;clear')
    printout('$display:line;clear')
    printout('$display:target;clear')
    printout('$display:clothes;clear')
end},'action')
wakeup_action = Def('wakeup_action',{key='wakeup',restrictions = {"asleep"},callback = function(self)  
    local is_player = self == player 
   
    self:adj_unset('asleep')
    describe_action(self,'you wake up',L'[self] wakes up')  
    
    if is_player then examine(player.location) end
end},'action')
person:act_add(sleep_action) 
person:act_add(wakeup_action) 