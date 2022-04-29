
AddTaskType('follow', {
    OnInit = function(self,target)
        self.target = target
    end,
    OnStart = function(self,npc,mind,memory)
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
        end
    end, 
})


