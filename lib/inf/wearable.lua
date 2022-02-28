

worn_by = Def('worn_by',{},"relation")



wear_action = Def('wear_action',{key='wear',callback = function(self,target) 
    local is_player = self == player 
    if target then
        local something = LocalIdentify(target) or LocalIdentify(target,self)
        if something then
            if something:is("wearable") and something:call("can_wear",self)~=false then
                if not HasRelationWith(something,self,worn_by) then

                    something.location = self
                    MakeRelation(something,self,worn_by)

                    describe_action(self,L'you wear [something]',tostring(self)..' wears '..tostring(something))  
                    
                    
                    return true
                else
                    if is_player then printout('you already wearing '..target) end
                end 
            else
                if is_player then printout('you cannot wear '..target) end
            end
        else
            if is_player then printout('there is no '..target) end
        end 
    else
        if is_player then printout('wear what?') end
    end
end},'action')


takeoff_action = Def('takeoff_action',{key='takeoff',callback = function(self,target) 
    local is_player = self == player 
    if target then
        local something = LocalIdentify(target) or LocalIdentify(target,self)
        if something then
            
            if HasRelationWith(something,self,worn_by) then

                DestroyRelation(something,self,worn_by)

                describe_action(self,L'you take off [something]',tostring(self)..' takes off '..tostring(something))  
                
                
                return true
            else
                if is_player then printout('you are not wearing '..target) end
            end 
        else
            if is_player then printout('there is no '..target) end
        end 
    else
        if is_player then printout('take off what?') end
    end
end},'action')


person:act_add(wear_action) 
person:act_add(takeoff_action) 

person.wear = function(self,...)
    for k,v in pairs({...}) do
        if type(v)=='string' then
            local c = Inst(v) 
            c.location = self
            MakeRelation(c,self,worn_by) 
        else
            v.location = self
            MakeRelation(v,self,worn_by) 
        end
    end
end
person.takeoff = function(self,...)
    for k,v in pairs({...}) do
        if type(v)=='string' then
            --local c = Inst(v) 
            --MakeRelation(c,self,worn_by) 
        else
            DestroyRelation(v,self,worn_by) 
        end
    end
end

thing._get_is_worn = function(self)
    return HasRelation(self,worn_by)
end


clothing = Def("clothing","thing")
clothing:adj_set('wearable')

shirt = Def("shirt","clothing")
skirt = Def("skirt","clothing")
pants = Def("pants","clothing")
hat = Def("hat","clothing")
boots = Def("boots","clothing")
gloves = Def("gloves","clothing") 
underwear = Def("underwear","clothing")

necklace = Def("necklace","clothing")
ring = Def("ring","clothing")
bracelet = Def("bracelet","clothing")