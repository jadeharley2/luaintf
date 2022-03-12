



be_action = Def('be_action',{key='be',callback = function(self,target) 
    local is_player = self == player 
    if is_player then
        local v = Identify(target)
        if v and v:is(person) then
            if players[v] then 
                printout('this character is occupied')
            else
                players[player] = nil
                player = v 
                personality = player.personality or player
                players[v] = client
                printout('you are now',v)

                send_actions() 
                examine(player.location)
                
                return true
            end
        end
    end
end},'action')