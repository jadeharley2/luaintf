
--test!
AddTaskType('shout', {
    OnInit = function(self,shout)
        self.shout = shout or 'some shout!'
    end,
    OnStart = function(self,npc,mind,memory)
        if npc.player then
            printto(npc,"You want to shout "..self.shout)
            if not npc.ai_override then return false end
        end
        
        npc:response('stop it',function()
            npc:say('ok! ok!')
            self:Complete()
            return true
        end)
        npc:say('im started! '..self.shout)
    end,
    OnUpdate = function(self,npc,mind,memory)
        npc:say('im updated! '..self.shout)
    end,
    OnEnd = function(self,npc,mind,memory)
        npc:say('im done! '..self.shout)
    end,
})
