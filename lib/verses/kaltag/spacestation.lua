
spacestation = Def('spacestation','thing')
spacestation._get_description = LF"[self]"
spacestation.dock_slot_count = 9
spacestation.dock = function(self,target) 
    local docked = self.docked or {}
    self.docked = docked
    if #docked<self.dock_slot_count then 
        local slot = #docked+1
        docked[slot] = target

        local a1 = self.airlock
        local a2 = target.airlock

        MakeRelation(a1,a2,Identify('direction_n'..slot))
        
        
        return true
    end
end
spacestation.undock = function(self,target) 
    local docked = self.docked 
    if docked then 
        for slot,v in pairs(docked) do
            if v == target then 
                local a1 = self.airlock
                local a2 = target.airlock
        
                DestroyRelation(a1,a2,Identify('direction_n'..slot))

                docked[slot] = nil
                return true
            end
        end  
    end
end