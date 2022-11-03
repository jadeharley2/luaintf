
person.maxfood = 200
person.maxwater = 200
person:event_add("on_init","needs",function(self)
    self.food = self.maxfood
    self.water = self.maxwater
end)

EventAdd('on_move','needs',function(self,from,to) 
    local p = to.location 
    if p and p.needs_food_mul then
        local dep = to.needs_costs_food * p.needs_food_mul
        if to.has_road then
            dep = dep *0.5
        end
        local f = self.food - dep
        if f<=0 then
            self:Damage(self.maxhealth*0.05)
            self.food = 0
        else
            self.food = f
        end 
    end
    if p and p.needs_water_mul then
        local dep = to.needs_costs_water * p.needs_water_mul
        if to.has_road then
            dep = dep *0.5
        end
        local f = self.water - dep
        if f<=0 then
            self:Damage(self.maxhealth*0.05)
            self.water = 0
        else
            self.water = f
        end 
    end
end)

EventAdd('on_turn_end','needs',function(self)  
    local loc = self.location

    local food = self.food 
    if food then
        local up = loc.needs_gains_food or 2 
        local maxfood = self.maxfood
        if food<maxfood then
            self.food = math.min(maxfood,food+up)
        end  
    end
    local water = self.water 
    if water then
        local up = loc.needs_gains_water or 2 
        local maxwater = self.maxwater 
        if water<maxwater then
            self.water = math.min(maxwater,water+up)
        end 
    end
    send_health(self,self)
end)