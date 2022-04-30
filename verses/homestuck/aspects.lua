
heart_aspect = Def("heart_aspect","adjective") 


soul_rip = Def('soul_rip',{key='soulrip',callback = function(self,arg1,...) 
    local is_player = self == player  
    if arg1 then
        local v = LocalIdentify(arg1)
        if v and v:is(person) then
            
            describe_action(self,L'you prepare your abilities.',L'[!self] prepares to use [their] abilities as a Rogue of Heart.')  
            sleep(0.1)
            describe_action(self,L'you cast soul rip on [v]',L'[self] casts soul rip on [v]!')  
            
            v:adj_set('asleep')

            local S = Inst('soul') 
            S.image = v.image 
            S.image_style = {
                opacity = '20%'
            }
            S.owner = v
            S.location = v.location 
            mind_transfer(v,S)
            
            S.task = Task('find_body',v)

            printout(L"[v]'s body collapses on the floor.")
  
            return true
        else
            if is_player then printout('there is no '..arg1) end
        end 
    else
        if is_player then printout('specify target') end
    end 
end},'action') 

soul_adapt = Def('soul_adapt',{key='souladapt',callback = function(self,arg1,...) 
    local is_player = self == player  
    if arg1 then
        local v = LocalIdentify(arg1)
        if v and v:is(person) then
            if v.identity~=v then
                describe_action(self,L'you prepare your abilities.',L'[!self] prepares to use [their] abilities as a Rogue of Heart.')  
                sleep(0.1)
                describe_action(self,L'you cast soul adaptation on [v]',L'[self] casts something on [v]!')  
                
                v:adj_set('asleep')

                local old_identity = v.identity
                describe_action(v,'you feel yourself changing... mentally') 
                v.identity = v  
                describe_action(v,'you feel different') 
                describe_action(v,L'you are no longer consider yourself [old_identity]')  
                
                v:adj_unset('asleep')
    
                return true
            else
                if is_player then printout(arg1..' has already adapted') end
            end
        else
            if is_player then printout('there is no '..arg1) end
        end 
    else
        if is_player then printout('specify target') end
    end 
end},'action') 

heart_aspect:act_add(soul_rip)
heart_aspect:act_add(soul_adapt)




 
space_aspect = Def("space_aspect","adjective") 

--teleport room
--teleport room something
teleport_action = Def('teleport_action',{key='teleport',callback = function(self,arg1,arg2) 
    local is_player = self == player  
    if arg1 then
        local v1 = Identify(arg1) -- room also should be in memory 
        if v1 and v1:is(room) then
            if arg2 then
                local v2 = LocalIdentify(arg2)
                if v2 then
                    disappear_visual_procedure(v2)
                    describe_action(self,L'you teleport [v2] to [v1]',L'[v2] vanishes in bright green flash')   
                    v2.location = v1 
                    appear_visual_procedure(v2) 
                    describe_action(self,nil,L'[v2] appears in bright green flash')   
                    describe_action(v2,L'you are blinded by bright green flash')  

                    return true
                else
                    if is_player then printout('there is no '..arg2) end
                end
            else
                disappear_visual_procedure(self)
                describe_action(self,L'you teleport to [v1]',L'[self] vanishes in bright green flash')  
                self.location = v1
                appear_visual_procedure(self) 
                describe_action(self,nil,L'[self] appears in bright green flash')  

                return true
            end 
        else
            if is_player then printout('there is no '..arg1) end
        end 
    else
        if is_player then printout('specify destination') end
    end 
    return false
end},'action') 

shrink_action = Def('shrink_action',{key='shrink',callback = function(self,arg1,...) 
    local is_player = self == player  
    if arg1 then
        local v = LocalIdentify(arg1) or LocalIdentify(arg1,self)
        if v then
            local ns = v.size / 2 
            if ns>=0.0625 then 
                local ts = sizelist[ns]
                describe_action(self,L'you shrink [v]',L'[v] glows and shrinks!')   
                v.size = ns
                printout(L'[v] is now [ts]')
            else
                describe_action(self,L"you can't shrink [v] any more")  
            end
            return true
        else
            if is_player then printout('there is no '..arg1) end
        end 
    else
        if is_player then printout('specify target') end
    end 
end},'action') 

enlarge_action = Def('enlarge_action',{key='enlarge',callback = function(self,arg1,...) 
    local is_player = self == player  
    if arg1 then
        local v = LocalIdentify(arg1) or LocalIdentify(arg1,self)
        if v then
            local ns = v.size * 2 
            if ns<=16 then 
                local ts = sizelist[ns] 
                describe_action(self,L'you enlarge [v]',L'[v] glows and expands!')   
                v.size = ns
                printout(L'[v] is now [ts]')
            else
                describe_action(self,L"you can't enlarge [v] any more")  
            end
            return true
        else
            if is_player then printout('there is no '..arg1) end
        end 
    else
        if is_player then printout('specify target') end
    end 
end},'action') 

space_aspect:act_add(teleport_action)
space_aspect:act_add(shrink_action)
space_aspect:act_add(enlarge_action)