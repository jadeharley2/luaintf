
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
