
local function astar(srcroom,trgroom)
    local open = {{c=srcroom,l={}}}
    local closed = {}

    for u=1,100 do
        local newopen = {}
        for k,seq in pairs(open) do
            local last = seq.c
            for k2,v2 in pairs(last:adjascent(true)) do 
                if v2==trgroom then
                    seq.l[#seq.l+1] = k2
                    return seq.l
                elseif not closed[v2] then
                    local l2 = table.copy(seq.l)
                    l2[#l2+1] = k2

                    newopen[#newopen+1] = {c=v2,l=l2}
                end
            end
            closed[last] = true
        end
        if #newopen==0 then 
            return 
        end
        open = newopen
    end
end

AddTaskType('moveto', {
    OnInit = function(self,target,fail_tolerance)
        self.target = target
        self.fail_tolerance = fail_tolerance or 999999
    end,
    OnStart = function(self,npc,mind,memory) 
    end,
    OnUpdate = function(self,npc,mind,memory)
        local loc = npc.location
        local tloc = self.target 
        if loc~=tloc then
            local path = astar(loc,tloc)
            if path then
                local d = path[1]
                if d then
                    npc:act('move',d)
                else 
                    self.fail_tolerance = self.fail_tolerance - 1
                    if self.fail_tolerance<0 then
                        self:Fail()
                    end
                end
            end
        else
            self:Complete()
        end
    end, 
})