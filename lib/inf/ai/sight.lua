


sense_sight = {}


function sense_sight.perceive(npc,mind)
    local loc = npc.location
    
    mind:make_known(loc)

    loc:foreach_contains(function(x)
        local memory = mind:make_known(x)
        local data = sense_sight.collect_data(x)
        local changed
        for k,v in pairs(data) do
            local oldvalue = memory[k]
            if oldvalue~=v then
                changed = changed or {}
                changed[k] = {oldvalue,v}
                memory[k] = v
            end
        end
        if changed then
            mind:visuals_changed(x,changed)
        end
    end)
end

--visual parameters
function sense_sight.collect_data(target)
    local d = {} 
    d.image = target.image
    local worn = target.clothes
    if worn then
        local hash = hash.sum(table.select(target.clothes,'id')) 
        d.worn = hash
    end
    return d
end

--thing._get_visual_hash = function(self)
--
--end