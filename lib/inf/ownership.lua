
plain_owner = false
owner = Def('owner','relation')
owned = Def('owned',{},'adjective') 
owned._get_nounname = function(s)
    local o = GetRelationOther(s,owner) or no_one 
    if player and player.identity:is(o) then
        return L"Your "..s.base.name
    elseif plain_owner then
        if plain_owner==true then
            return s.base.name
        else
            return plain_owner.their.." "..s.base.name
        end
    else
        return L"[o]'s "..s.base.name
    end
end


thing._get_owner = function(s)
    return GetRelationOther(s,owner)
end
thing._set_owner = function(s,v)
    DestroyRelations(s,owner)
    if v then 
        MakeRelation(s,v,owner)
    end
end