
AddTaskType('follow', {
    OnInit = function(self,target)
        self.target = target
    end,
    OnStart = function(self,npc,mind,memory)
        if npc.player then
            printto(npc,"You want to follow "..tostring(self.target))
            if not npc.ai_override then return end
        end

        npc:response('stop following',function()
            npc:say('ok!')
            self:Complete()
            return true
        end) 
    end,
    OnUpdate = function(self,npc,mind,memory)
        local loc = npc.location
        local tloc = self.target.location
        if loc~=tloc then
           -- if npc.ai_override then 
                local d = loc:direction_to(tloc)
                if d then
                    npc:act('move',d)
                else
                    loc:first('contains',function(v)
                        if v:is(portal) then
                            local o = v:other_side()
                            if o and o.location == tloc then
                                v:interact(npc,'trough')
                            end
                        end
                    end)
                    
                    --idk where to go!
                end
           -- end
        end
    end, 
})


