
AddTaskType('act', {
    OnInit = function(self,action,...)
        self.action = action
        self.arguments  = {...}
    end,
    OnStart = function(self,npc,mind,memory) 

        local args = self.arguments

        if #args>0 then
            local target = self.arguments[1]
            local something = LocalIdentify(target,npc.location) or LocalIdentify(target,npc)
            if something then
                local result = something:interact(npc,self.action,args[2],args[3],args[4])
                if result~=nil then
                    if result then
                        self:Complete()
                    else
                        self:Fail()
                    end
                    return
                end 
            end
        end 

        if npc:act(self.action,unpack(args)) then
            self:Complete()
        else
            self:Fail()
        end
    end,
    OnUpdate = function(self,npc,mind,memory)
    end, 
})
