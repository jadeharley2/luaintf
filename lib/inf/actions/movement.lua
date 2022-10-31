
disappear_visual_procedure = function(self)
    if self then
        others_action(self,function(ply)
            printout('$display:line;'..self.id..';')
            printout('$display:target;'..self.id..';')
        end) 
    end
end
appear_visual_procedure = function(self) 
    if self then
        others_action(self,function(ply) 
            printout('$display:line;'..self.id..';'..(self.image or ''))
        end)
    
        printto(self,'$display:target;clear')
        printto(self,'$display:line;clear')
        examine(self.location,self) 
    end
end

move_action = Def('move_action',{key='move',restrictions = {"can_move"},callback = function(self,direction)  
    local is_player = self == player
    local loc = self.location
    if loc:is(room) then
        local next = loc:dir(direction)
        if next then  

            local is_passable = next.is_passable 
            if is_passable then
                if is_passable(next,self)==false then
                    return false
                end
            end

            if self:is('bound') then
                self:act('standup') -- try to stand up
            end

            if not self:is('bound') then

                describe_action(self,nil,tostring(self)..' leaves to '..tostring(next))  
               
                disappear_visual_procedure(self)
 
                loc:call('on_exit',self) 

                self.location = next
                self:event_call('on_move',loc,next) 

                next:call('on_enter',self) 

                describe_action(self,nil,tostring(self)..' arrives from '..tostring(loc))

                appear_visual_procedure(self)



                return true
            else
                if is_player then printout("you can't move") end
            end
        else
            if is_player then printout("you can't go that way") end
        end
    else
        if is_player then printout("you can't move") end
    end
end,description='shorthand: n, s, w, e, etc.'},'action')

for k,v in pairs(direction_map) do
    DefComAlias(k,{'move',k})
end

person:act_add(move_action) 


function thing:step_in(user)
    local is_player = user == player 

    if self:is('opened') then
        local next = self
        user.location = next

        
        others_action(user,function(ply)
            printout('$display:line;'..user.id..';')
            printout('$display:target;'..user.id..';')
        end)

        describe_action(user,L'you step in [self]',L"[user] enters [self]")  

        if is_player then
            printout('$display:background;clear')
        end

        
        others_action(user,function(ply) 
            printout('$display:line;'..self.id..';'..(self.image or ''))
        end)


        if is_player then
            printout('$display:target;clear')
            printout('$display:line;clear')
            examine(next) 


            local things = {}
            self:foreach('contains',function(k,v)
                if k~=player then
                    things[k.id] = tostring(k)
                end
            end)

            printout('$directions_clear') 
            printout('$things_clear')
            for k,v in pairs(things) do 
                printout('$thing:'..'x '..k..";"..v)
            end 
        end 
    else 
        describe_action(user,L"you can't get inside [self], it's closed!")  
    end
    return true 
end

function thing:step_out(user)
    local is_player = user == player 

    if self:is('opened') then
        local next = self.location
        user.location = next
    
        others_action(user,function(ply)
            printout('$display:line;'..user.id..';')
            printout('$display:target;'..user.id..';')
        end)
    
    
        if is_player then
            printout('$display:background;clear')
        end

        describe_action(user,L'you step out of [self]',L"[user] exits [self]")  
    
        
        others_action(user,function(ply) 
            printout('$display:line;'..self.id..';'..(self.image or ''))
        end)
    
    
        if is_player then
            printout('$display:target;clear')
            printout('$display:line;clear')
            examine(next) 
        end 
    else 
        describe_action(user,L"you can't get out of [self], it's closed!")  
    end
    return true 
end
step_in_interaction = Def('step_in_interaction',{key='step_in',
    restrictions = {"opened"},
    user_restrictions = {"!asleep",'!bound'},
    callback = function(self,user)  
        return self:call('step_in',user) 
end},'interaction')
step_out_interaction = Def('step_out_interaction',{key='step_out',
    restrictions = {"opened"},
    user_restrictions = {"!asleep",'!bound'},
    callback = function(self,user)  
        return self:call('step_out',user) 
end},'interaction')

--[[



]]
 