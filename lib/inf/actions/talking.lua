
--is this needed?
--talk to


talkto_action = Def('talkto_action',{key='talk',callback = function(self,target) 
    local is_player = self == player 
    
    local something = LocalIdentify(target)
    if something and something~=self then
        if something:is(person) then
            self.talk_target = something 
            if is_player then printout('you are now talking to ',something) end
            return true
        end
    end 

end},'action')

--say

say_action = Def('say_action',{key='say',callback = function(self,text) 
    local is_player = self == player 
  
    --local tlk = self.talk_target
    --if tlk then
        self:say(text)
        if tlk and tlk.location == self.location then
            tlk:respond(self,text)
            return true
        end
    --else
       --local something = LocalIdentify(com)
       --if something and something~=player then
       --    if something:is(person) then
       --        player.talk_target = something 
       --        printout('you are now talking to ',something)
       --        return true
       --    end
       --end 
    --end
    
end},'action')





--person:act_add(talkto_action)
person:act_add(say_action) 