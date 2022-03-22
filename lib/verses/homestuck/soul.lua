
soul = Def('soul','owned invisible thing')
soul.image = '/img/characters/soul.png'  
soul:act_add(look_action)
soul:act_add(examine_action)
soul:act_add(move_action) 
soul._get_memory = function(self)
    return rawget(self,'mind').memory or {}
end 
soul._get_task = function(self)
    return rawget(self,'mind').task
end
soul._set_task = function(self,value)
    rawget(self,'mind').task = value
end


posess_action = Def('posess_action',{key='posess',callback = function(self,arg1,...) 
    local is_player = self == player  
    if arg1 then
        local v = LocalIdentify(arg1)
        if v and v:is(person) then
            if v.mind == nil then
                describe_action(self,L"you merge with [v]'s body.")  
                sleep(0.1) 
                
                mind_transfer(self,v)

                self.location = nil

                v:adj_unset('asleep') 
                describe_action(self,'you awake',L'[v] awakes')  
    
                return true
            else
                describe_action(self,L"you try to enter [v]'s body but feel resistance, something is blocking your way in!") 
            end
        else
            if is_player then printout('there is no '..arg1) end
        end 
    else
        if is_player then printout('specify target') end
    end 
end},'action') 

soul:act_add(posess_action) 



AddTaskType('find_body', {
    OnInit = function(self,old_body)
        self.old_body = old_body
        self.timer = 0
    end,
    OnStart = function(self,npc,mind,memory)
        
    end,
    OnUpdate = function(self,npc,mind,memory)
        self.timer = self.timer + 1
        local loc = npc.location
        if math.random()>0.8 then
            local body = loc:first('contains',function(v)
                if v:is(person) and v.mind==nil then
                    if v==self.old_body and self.timer<4 then return end -- skip own body early (4 turns)
                    return v
                end
            end)
            if body then
                npc:act('posess',body)   
                self:Complete()
            end
        end 
    end, 
})


soul.on_init = function(self)
    self:set_updating(true)
end
soul:event_add('on_turn_end','mind',function(self)
    local mind = rawget(self,'mind')
    if mind then 
        local t = mind.task 
        if t then 
            if not t.is_started then
                t:Start(self,mind,mind.memory)
            end
            if not t.is_ended then
                t:Update(self,mind,mind.memory)
            else
                mind.task = false
            end
        end
    end
end)
