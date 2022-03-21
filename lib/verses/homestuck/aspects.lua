
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

heart_aspect:act_add(soul_rip)




 
space_aspect = Def("space_aspect","adjective") 

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

space_aspect:act_add(shrink_action)
space_aspect:act_add(enlarge_action)