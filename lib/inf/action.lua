

action = Def('action',{
    key='default',
    description = "",
    callback = function(self) printout('you are calling default action! stop!')  end
},'thing')
function action:is_restricted(actor)
    local restrictions = self.restrictions
    if restrictions then
        for k,v in pairs(restrictions) do
            if v:sub(1,1)=='!' then
                if actor:is(v:sub(2)) then return true end
            else
                if not actor:is(v) then return true end
            end
        end
    end
    return false
end


InheritableSet(thing,'actions')

thing.act = function(self,key,a,b,c,d,...)
    
    local v = self:first('actions',function(k,v) 
        if v then 
            if v:is_restricted(self) then return end
            if key==k then return v end
        end
    end)
    --local v = self.actions[key]
    if v then
        local r1,r2,r3 = v.callback(self,a,b,c,d,...)

        cor.wait(1)
        return r1,r2,r3
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
        return self:first('actions',function(key,v) 
            if v and v:is_restricted(self) then return end
            if key==k then return v end
        end)
        --self.actions[k]  
    else
        local item = Identify(k)
        return self:first('actions',function(key,v) 
            if v and v:is_restricted(self) then return end
            if item.key==k then return v end
        end)
        --self.actions[item.key] 
    end 
end
thing.act_list = function(self,k)
    local r = {}
    self:collect('actions',function(k,v) 
        if v then 
            if v:is_restricted(self) then return end
            r[k] = v
        end
    end)
    return r --self.actions:getall()
end

---------------------------------------
---------------------------------------
---------------------------------------
---------------------------------------
---------------------------------------
---------------------------------------
---------------------------------------

interaction = Def('interaction',{ 
    key='default',
    description = "",
    callback = function(self) printout('you are calling default interaction! stop!')  end
},'thing')
function interaction:is_restricted(actor,user)
    local restrictions = self.restrictions
    if restrictions then
        for k,v in pairs(restrictions) do
            if v:sub(1,1)=='!' then
                if actor:is(v:sub(2)) then return true end
            else
                if not actor:is(v) then return true end
            end
        end
    end

    if user then
        local user_restrictions = self.user_restrictions
        if user_restrictions then
            for k,v in pairs(user_restrictions) do
                if v:sub(1,1)=='!' then
                    if user:is(v:sub(2)) then return true end
                else
                    if not user:is(v) then return true end
                end
            end
        end
    end
    return false
end

InheritableSet(thing,'interactions')
thing.interact = function(self,user,key,a,b,c,d,e,f)
    --local v = self.interactions[key]
    --if v then
    --    if v:is_restricted(self,user) then return end
    --    return v.callback(self,user,...)
    --end

    return self:first('interactions',function(k,v) 
        if k==key and not v:is_restricted(self) then 
            return v.callback(self,user,a,b,c,d,e,f)
        end 
    end) 
end 
thing.interact_list = function(self,k)
    local r = {}
    self:collect('interactions',function(k,v) 
        if v:is_restricted(self) then return end
        r[k] = v
    end)
    return r --self.actions:getall()

    --return self.interactions:getall()
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
        return self:first('interactions',function(key,v) 
            if v and v:is_restricted(self) then return end
            if key==k then return v end
        end) 
    else
        local item = Identify(k)
        return self:first('interactions',function(key,v) 
            if v and v:is_restricted(self) then return end
            if item.key==k then return v end
        end) 
    end 

    --if type(k)=='string' then 
    --    return self.interactions[k]  
    --else
    --    local item = Identify(k)
    --    return self.interactions[item.key] 
    --end 
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



function send_actions(target) 
    local actions = {"x self"}
    target:foreach('actions',function(k,v) if v then actions[#actions+1]=k end end)
    printto(target,'$actions:',table.concat(actions, ';'))
end
