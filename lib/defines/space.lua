

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