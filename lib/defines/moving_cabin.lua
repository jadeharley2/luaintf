


moving_cabin = Def('moving_cabin',{ },'room')
moving_cabin.close_doors = function(self)
    DestroyRelations(self,direction)
end
moving_cabin.open_doors = function(self,floor)
    self.stop = floor.room
    MakeRelation(self,floor.room,floor.dir)
end
moving_cabin.add_stop = function(self,key, room,dir)
    if type(dir)=='string' then
        dir = direction_map[dir]
    end
    self.stops = self.stops or {}
    self.stops[key] = {room = room, dir = dir} 
end
moving_cabin.move_to = function(self,key,callback) 
    local v = self.stops[key] 
    if v then
        self:make_sound_inside('*be-ep*')
        self:close_doors()
        Delay(2,function()
            self:make_sound_inside('*beep*')
            self:open_doors(v)
            if callback then callback(self,key) end 
        end)
        return true
    end
    return false
end

moving_cabin.set_path = function(self,key_array,looped,wait_time)
    local index = 1
    local current = key_array[index]
    local direction = 1

    self:open_doors(self.stops[current])
    local function process() 
        index = index + direction
        if index>#key_array then
            if looped then
                index = 1
            else
                direction = -direction
                index = #key_array-1
            end
        elseif index<1 then
            if looped then
                index = #key_array
            else
                direction = -direction
                index = 2
            end 
        end
        if index==0 then

            local dfa = 0
        end
        current = key_array[index]

        Delay(wait_time or 2, function() 
            if self:move_to(current,function() 
                process()
            end) then

            else
                print('error!')
            end
        end)
    end

    process()
end


--todo: buttons and interaction

elevator = Def('elevator',{ },'moving_cabin')

elevator.select_floor = function(self,key)
    return self:move_to(key,function()
        self:make_sound_inside('Floor '..tostring(key))
    end) 
end 

--end todo