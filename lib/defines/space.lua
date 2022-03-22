

--space = Def('space',{name='space'},'thing')

universe = Def('universe',{name='Universe'},'thing')


thing._get_universe = function(self)
    return self:foreach_parent(function(s)
        if s:is(universe) then
            return s
        end
    end,false)
end


subspace = Def('subspace',{name='Subspace'},'thing')
subspace.description = "blue flickering space"--....


starsystem = Def('starsystem','thing')

star = Def('star','thing')
star._get_description = LF'star [self]' 

planet = Def('planet','thing')
planet._get_description = LF'planet [self]' 

asteroid = Def('asteroid','thing')
asteroid._get_description = LF'asteroid [self]' 

asteroid_field = Def('asteroid_field','thing')
asteroid_field._get_description = LF'asteroid field [self]' 







portal_link = Def('portal_link','relation') 

portal = Def('portal','thing') 
portal.image = '/img/items/portal.png'  
portal.description = 'you see purple swirling mass'

step_trough_interaction = Def('step_trough_interaction',{key='trough',callback = function(self,user)  
    return self:call('step_trough',user) 
end},'interaction')
portal:interact_add(step_trough_interaction)

function portal:step_trough(user)
    local is_player = user == player
    local other_side = GetRelationOther(self,portal_link)
    if other_side then
        local next = other_side.location
        user.location = next
        describe_action(user,L'you step trough [self]',L"[user] enters [self] and vanishes")  
        if is_player then
            printout('$display:target;clear')
            printout('$display:line;clear')
            examine(next) 
        end
    else
        describe_action(user,L"you try to push [self]'s surface but nothing happens",L"[user] pushes [self]'s surface.")  
    end
    return true 
end
function portal:other_side()
    return GetRelationOther(self,portal_link)
end