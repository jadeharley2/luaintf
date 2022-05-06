
status_adjective = Def('status_adjective','adjective')
location_adjective = Def('location_adjective','adjective')
surface_adjective = Def('surface_adjective','adjective')
surface_type_adjective = Def('surface_type_adjective','adjective')
type_adjective = Def('type_adjective','adjective')

broken = Def('broken','status_adjective')
missing = Def('missing','status_adjective')
changing = Def('changing','status_adjective')


front = Def('front','location_adjective')
back = Def('back','location_adjective')
left = Def('left','location_adjective')
right = Def('right','location_adjective')

short = Def('short','surface_adjective')
long = Def('long','surface_adjective')

furred = Def('furred',{name='fur'},'surface_type_adjective')
leathery = Def('leathery',{name='skin'},'surface_type_adjective')
scaly = Def('scaly',{name='scales'},'surface_type_adjective')

plantigrade = Def('plantigrade','type_adjective')
digitigrade = Def('digitigrade','type_adjective')
ungulate = Def('ungulate','type_adjective')

connected = Def('connected','relation')
welded = Def('welded','connected')
bolted = Def('bolted','connected')
flesh_connected = Def('flesh_connected','connected')

body_part = Def('body_part',{name="body part"},'thing')

body_part._get_description = function(self)

    local loc = self:adj_describe('location_adjective')
    local name = self.name
    local bp1

    if self:is('missing') then
        bp1 = L"[loc] [name] is missing"
    else

        local type = self:adj_describe('type_adjective')
        local surface = self:adj_describe('surface_adjective')
        local surface_type = self:adj_describe('surface_type_adjective')
        local status = self:adj_describe('status_adjective')

        bp1 = L"[loc] [name]: [type]"
        if #surface_type>0 then
            bp1 = bp1..L" with [surface] [surface_type]"
        end
        if #status>0 then
            bp1 = bp1..L" is [status]"
        end
        bp1 = bp1:gsub("  ", " ")
    end
    
    --local n = self.name
    --local aj = table.keys_to_values(self:adj_getall())
    --aj[#aj+1] = n
    return bp1 --table.concat(aj,' ')  
end
body_part.should_display = function(self, player)
    return self:is('described')  
end
body_part._get_is_moveable = function(self)
    return false
end

body_part._get_connected = function(self)
    return GetRelationOther(self,connected)
end
body_part.connect = function(self,target,connection_kind)
    connection_kind = connection_kind or connected
    target.location = self.location
    MakeRelation(self,target,connection_kind)
    return self
end

thing.get_bodypart = function(self, key)
    return self:first('contains',function(x)
        if x:is(key) then return x end
    end)
end
thing.attach_bodypart = function(self, key, bpart,connection_kind)
    local t = self:first('contains',function(x)
        if x:is(key) then return x end
    end)
    t:connect(bpart,connection_kind)
    return self
end

limb = Def('limb',{name="limb"},'body_part')
leg = Def('leg',{name="leg"},'limb')
arm = Def('arm',{name="arm"},'limb')
tail = Def('tail',{name="tail"},'limb')

head = Def('head',{name="head"},'body_part')
neck = Def('neck',{name="neck"},'body_part')
chest = Def('chest',{name="chest"},'body_part')
abdomen = Def('abdomen',{name="abdomen"},'body_part')
hand = Def('hand',{name="hand"},'body_part')
foot = Def('foot',{name="foot"},'body_part')
 
hoof = Def('hoof',{name="hoof"},'foot')

ear = Def('ear',{name="ear"},'body_part')

hair = Def('hair',{name="hair"},'body_part')
