

action = Def('action',{
    key='default',
    description = "",
    callback = function(self) printout('you are calling default action! stop!')  end
},'thing')


InheritableSet(thing,'actions')

thing.act = function(self,key,...)
    local v = self.actions[key]
    if v then
        return v.callback(self,...)
    end
end 
thing.act_add = function(self,k) 
    --if type(k)=='table' then
    --    for _,v in pairs(k) do self:act_add(v) end
    --else
        local item = Identify(k)
        if item:is(action) then 
            local t = rawget(self,'actions')
            if not t then
                t = InheritableSet(self,'actions')
            end
            t[item.key] = item
        end
    --end
end
thing.act_rem = function(self,k) 
    --if type(k)=='table' then
    --    for _,v in pairs(k) do self:act_add(v) end
    --else  
        local t = rawget(self,'actions')
        if t then
            if type(k)=='string' then 
                t[k] = false --false to override inherited values
            else 
                t[k.key] = false
            end
        end
    --end
end
thing.act_get = function(self,k)
    if type(k)=='string' then 
        return self.actions[k]  
    else
        local item = Identify(k)
        return self.actions[item.key] 
    end 
end
thing.act_list = function(self,k)
    return self.actions:getall()
end

---

interaction = Def('interaction',{ 
    key='default',
    description = "",
    callback = function(self) printout('you are calling default interaction! stop!')  end
},'thing')

InheritableSet(thing,'interactions')
thing.interact = function(self,user,key,...)
    local v = self.interactions[key]
    if v then
        return v.callback(self,user,...)
    end
end 
thing.interact_list = function(self,k)
    return self.interactions:getall()
end
thing.interact_add = function(self,k)  
    local item = Identify(k)
    if item:is(interaction) then 
        local t = rawget(self,'interactions')
        if not t then
            t = InheritableSet(self,'interactions')
        end
        t[item.key] = item
    end 
end
thing.interact_rem = function(self,k)  
    local t = rawget(self,'interactions')
    if t then
        if type(k)=='string' then 
            t[k] = false --false to override inherited values
        else 
            t[k.key] = false
        end
    end 
end
thing.interact_get = function(self,k)
    if type(k)=='string' then 
        return self.interactions[k]  
    else
        local item = Identify(k)
        return self.interactions[item.key] 
    end 
end


com_aliases = {}
function DefComAlias(alias, result)
    com_aliases[alias] = result
end

function ComAlias(com,...) 
    local r = com_aliases[com] 
    if r then 
        if type(r)=='table' then
            return r[1],r[2],...
        else
            return r,...
        end
    else
        return com,...
    end
end
