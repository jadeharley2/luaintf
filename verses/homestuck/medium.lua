session_meta = session_meta or {}

function session_meta:AddPlayer(person)

end

function session_meta:MakeDreamself(id,person,moon)
    local ds = Def(id,'person')

    return ds
end

session_meta.__index = session_meta