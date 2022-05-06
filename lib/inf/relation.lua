
relation_kind = Def("relation",{

},'thing')

local relation_meta = {
    other = function(self,key)
        if self.from == key then
            return self.to 
        elseif self.to == key then
            return self.from
        end
    end,
    xor_to = function(self,key)
        if self.to == key then return nil end
        return self.to
    end,
    xor_from = function(self,key)
        if self.from == key then return nil end
        return self.from
    end,
}
relation_meta.__index = relation_meta

function MakeRelation(a,b,kind)
    local kind_id = Identify(kind)
    if kind_id then
        if kind_id:is("relation") then
            if not HasRelationWith(a,b,kind) then
                local rel = setmetatable({
                    from = a,
                    to = b,
                    kind = kind_id
                },relation_meta)
                local ar = a:ensure('relations',{})
                local br = b:ensure('relations',{})
                ar[#ar+1] = rel
                br[#br+1] = rel
                a:call('on_new_'..kind_id.id,b)
                b:call('on_new_'..kind_id.id,a)
            end
        else
            print(kind..' is not a relation kind')
        end
    else
        print('unknown relation kind '..kind_id)
    end
end
function DestroyRelation(a,b,kind)
    local kind_id = Identify(kind)
    if kind_id then
        if kind_id:is("relation") then
            local ar = a:ensure('relations',{})
            local br = b:ensure('relations',{})
            for k,v in pairs(ar) do
                if v.from == a and v.to == b and v.kind == kind_id then
                    ar[k] = nil
                    a:call('on_rem_'..kind_id.id,b)
                end
            end
            for k,v in pairs(br) do
                if v.from == a and v.to == b and v.kind == kind_id then
                    br[k] = nil
                    b:call('on_rem_'..kind_id.id,a)
                end
            end
        else
            print(kind..' is not a relation kind')
        end
    else
        print('unknown relation kind '..kind)
    end
end
function DestroyRelations(self,kind) 
    self:foreach('relations',function(k,v)
        if v.kind:is(kind) then
            local a = v.from 
            local b = v.to 
            local kind_id = v.kind

            local ar = a:ensure('relations',{})
            local br = b:ensure('relations',{})
            for k,v in pairs(ar) do
                if v.from == a and v.to == b and v.kind == kind_id then
                    ar[k] = nil
                end
            end
            for k,v in pairs(br) do
                if v.from == a and v.to == b and v.kind == kind_id then
                    br[k] = nil
                end
            end
        end
    end)
end
function GetRelations(self,kind)
    if kind then
        local kind = Identify(kind)
        if kind then
            local r = {}
            self:foreach('relations',function(k,v)
                if v.kind:is(kind) then
                    r[#r+1] = v
                end
            end)
            return r
        else
            print('unknown relation kind '..kind)
        end
        return {}
    else
        local r = {}
        self:foreach('relations',function(k,v)
            r[#r+1] = v
        end)
        return r
    end
end 
function GetRelationOther(self,kind) 
    local kind = Identify(kind)
    if kind then
        local r = {}
        return self:first('relations',function(k,v)
            if v.kind:is(kind) then
                if v.from == self then
                    return v.to
                else
                    return v.from
                end
            end
        end) 
    else
        print('unknown relation kind '..kind)
    end
end 
function HasRelation(self,kind)
    local kind = Identify(kind)
    if kind then
        local r = {}
        return self:first('relations',function(k,v)
            if v.kind:is(kind) then
                return true
            end
        end) 
    else
        print('unknown relation kind '..kind)
    end
    return false
end
function HasRelationWith(self,target,kind)
    local kind = Identify(kind)
    if kind then
        local r = {}
        return self:first('relations',function(k,v)
            if v.kind:is(kind) and v.to==target then
                return true
            end
        end) 
    else
        print('unknown relation kind '..kind)
    end
    return false
end