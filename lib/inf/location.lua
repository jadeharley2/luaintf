
direction = Def('direction',{},"relation")

direction_west = Def('direction_west',{key ='w'},"direction")
direction_east = Def('direction_east',{key ='e'},"direction")
direction_north = Def('direction_north',{key ='n'},"direction")
direction_south = Def('direction_south',{key ='s'},"direction")

direction_southwest = Def('direction_southwest',{key='sw'},"direction")
direction_southeast = Def('direction_southeast',{key='se'},"direction")

direction_northwest = Def('direction_northwest',{key='nw'},"direction")
direction_northeast = Def('direction_northeast',{key='ne'},"direction")

direction_up = Def('direction_up',{key='u'},"direction")
direction_down = Def('direction_down',{key='d'},"direction")

direction_in = Def('direction_in',{key='in'},"direction")
direction_out = Def('direction_out',{key='out'},"direction")

direction_n1 = Def('direction_n1',{key='n1'},"direction")
direction_n2 = Def('direction_n2',{key='n2'},"direction")
direction_n3 = Def('direction_n3',{key='n3'},"direction")
direction_n4 = Def('direction_n4',{key='n4'},"direction")
direction_n5 = Def('direction_n5',{key='n5'},"direction")
direction_n6 = Def('direction_n6',{key='n6'},"direction")
direction_n7 = Def('direction_n7',{key='n7'},"direction")
direction_n8 = Def('direction_n8',{key='n8'},"direction")
direction_n9 = Def('direction_n9',{key='n9'},"direction")

direction_s1 = Def('direction_s1',{key='s1'},"direction")
direction_s2 = Def('direction_s2',{key='s2'},"direction")
direction_s3 = Def('direction_s3',{key='s3'},"direction")
direction_s4 = Def('direction_s4',{key='s4'},"direction")
direction_s5 = Def('direction_s5',{key='s5'},"direction")
direction_s6 = Def('direction_s6',{key='s6'},"direction")
direction_s7 = Def('direction_s7',{key='s7'},"direction")
direction_s8 = Def('direction_s8',{key='s8'},"direction")
direction_s9 = Def('direction_s9',{key='s9'},"direction")



direction_map = {
    w = direction_west,
    s = direction_south,
    e = direction_east,
    n = direction_north,
    sw = direction_southwest,
    se = direction_southeast,
    nw = direction_northwest,
    ne = direction_northeast,
    ['in'] = direction_in,
    out = direction_out,
    u = direction_up,
    d = direction_down,

    n1 = direction_n1,
    n2 = direction_n2,
    n3 = direction_n3,
    n4 = direction_n4,
    n5 = direction_n5,
    n6 = direction_n6,
    n7 = direction_n7,
    n8 = direction_n8,
    n9 = direction_n9,

    s1 = direction_s1,
    s2 = direction_s2,
    s3 = direction_s3,
    s4 = direction_s4,
    s5 = direction_s5,
    s6 = direction_s6,
    s7 = direction_s7,
    s8 = direction_s8,
    s9 = direction_s9,
}
local direction_reverse = {
    [direction_west] = direction_east,
    [direction_east] = direction_west,
    [direction_north] = direction_south,
    [direction_south] = direction_north,
    [direction_up] = direction_down,
    [direction_down] = direction_up,
    [direction_in] = direction_out,
    [direction_out] = direction_in,
    
    [direction_southwest] = direction_northeast,
    [direction_northeast] = direction_southwest,
    [direction_southeast] = direction_northwest,
    [direction_northwest] = direction_southeast,
    
    [direction_n1] = direction_s1,
    [direction_n2] = direction_s2,
    [direction_n3] = direction_s3,
    [direction_n4] = direction_s4,
    [direction_n5] = direction_s5,
    [direction_n6] = direction_s6,
    [direction_n7] = direction_s7,
    [direction_n8] = direction_s8,
    [direction_n9] = direction_s9,

    [direction_s1] = direction_n1,
    [direction_s2] = direction_n2,
    [direction_s3] = direction_n3,
    [direction_s4] = direction_n4,
    [direction_s5] = direction_n5,
    [direction_s6] = direction_n6,
    [direction_s7] = direction_n7,
    [direction_s8] = direction_n8,
    [direction_s9] = direction_n9,
}

room = Def('room',{
    name = 'A room',
    description = "An empty room",
    dir = function(self,dir)
        if type(dir)=='string' then
            dir = direction_map[dir]
        end

        for k,v in pairs(GetRelations(self,dir)) do 
            local r = v:xor_to(self) 
            if r then return r end 
        end 
        local reverse_dir = direction_reverse[dir]
        for k,v in pairs(GetRelations(self,reverse_dir)) do 
            local r = v:xor_from(self) 
            if r then return r end 
        end 

        --[[
        if dir==direction_down then
            local r = GetRelations(self,direction_down)[1] 
            if r then 
                local r = r:xor_to(self) 
                if r then return r end 
            end
            local r = GetRelations(self,direction_up)[1]
            if r then return r:xor_from(self) end
        elseif dir==direction_up then
            local r = GetRelations(self,direction_up)[1] 
            if r then 
                local r = r:xor_to(self) 
                if r then return r end 
            end
            local r = GetRelations(self,direction_down)[1]
            if r then return r:xor_from(self) end
        elseif dir==direction_west then
            for k,v in pairs(GetRelations(self,direction_west)) do 
                local r = r:xor_to(self) 
                if r then return r end 
            end 
            local r = GetRelations(self,direction_east)[1]
            if r then return r:xor_from(self) end
        elseif dir==direction_east then
            local r = GetRelations(self,direction_east)[1] 
            if r then 
                local r = r:xor_to(self) 
                if r then return r end 
            end
            local r = GetRelations(self,direction_west)[1]
            if r then return r:xor_from(self) end
        elseif dir==direction_south then
            local r = GetRelations(self,direction_south)[1] 
            if r then 
                local r = r:xor_to(self) 
                if r then return r end 
            end
            local r = GetRelations(self,direction_north)[1]
            if r then return r:xor_from(self) end
        elseif dir==direction_north then
            local r = GetRelations(self,direction_north)[1] 
            if r then 
                local r = r:xor_to(self) 
                if r then return r end 
            end
            local r = GetRelations(self,direction_south)[1]
            if r then return r:xor_from(self) end
        elseif dir==direction_in then
            local r = GetRelations(self,direction_in)[1] 
            if r then 
                local r = r:xor_to(self) 
                if r then return r end 
            end
            local r = GetRelations(self,direction_out)[1]
            if r then return r:xor_from(self) end
        elseif dir==direction_out then
            local r = GetRelations(self,direction_out)[1] 
            if r then 
                local r = r:xor_to(self) 
                if r then return r end 
            end
            local r = GetRelations(self,direction_in)[1]
            if r then return r:xor_from(self) end
        end]]
    end,
    adjascent = function(self,as_string)
        local directions = GetRelations(self,direction)
        local r = {}
        for k,v in pairs(directions) do
            if v.from==self then 
                if as_string then
                    r[v.kind.key] = v.to
                else
                    r[v.kind] = v.to
                end
            else
                if as_string then
                    r[direction_reverse[v.kind].key] = v.from
                else
                    r[direction_reverse[v.kind]] = v.from
                end
            end 
        end
        return r
    end,
},'thing')
InheritableSet(room,'contains')


nowhere = Def('nowhere',{name = 'Nowhere', description = '???'},'room')
thing._get_location = function(self)
    return rawget(self,'_loc') or nowhere
end
thing._set_location = function(self,v)
    --if v:is(room) then 
    --end
    if v:call("on_enter",self)==false then
        return 
    end  

    local old = rawget(self,'_loc')
    if old then
        local t = rawget(old,'contains')
        if t then
            t[self] = nil
        end
    end

    rawset(self,'_loc',v) 
    
    local t = rawget(v,'contains')
    if not t then
        t = InheritableSet(v,'contains')
    end
    t[self] = true
end
thing.foreach_parent = function(self,callback,include_self)
    local c 
    if include_self then 
        c = self
    else
        c = self.location
    end
    while c and c~=nowhere do
        local r = callback(c)
        if r then return r end
        c = c.location
    end
end
thing.parent_oftype = function(self,type,include_self)
    return self:foreach_parent(function(s)
        if s:is(type) then
            return s
        end
    end,include_self)
end
