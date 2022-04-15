nepeta.schedule = {
    { at = "monday 9:00", task = Task('moveto',jade_room)},
    { at = "monday 9:30", task = Task('moveto',garden_e)},
    { at = "monday 10:00", task = Task('moveto',aradia_room)},
}

--[[
--:say('ok!')
for k=1,10 do 
    At(k,12,'test1',function()
        nepeta.task = Task('moveto',jade_room)
    end)
    At(k,22,'test1',function()
        nepeta.task = Task('moveto',garden_e)
    end)
    At(k,32,'test1',function()
        nepeta.task = Task('moveto',aradia_room)
    end)

    
    At(k,42,'test1',function()
        nepeta.task = Task('moveto',jade_room)
    end)
    At(k,50,'test1',function()
        nepeta.task = Task('moveto',garden_e)
    end)
    At(k,58,'test1',function()
        nepeta.task = Task('moveto',aradia_room)
    end)
end
]]