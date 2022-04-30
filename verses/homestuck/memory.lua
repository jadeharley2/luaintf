
jade.mind:make_fully_known(tower)
jade.mind:knows({jade,rose,dave,john,aradia,nepeta,terezi,jadebot},{"name","age"})

rose.mind:make_fully_known(rose_house)
rose.mind:knows({jade,rose,roxy,dave,john,aradia,nepeta,terezi},"name")


roxy.mind:knows({jade,rose,dave,john},"name")
roxy.mind:make_fully_known(rose_house)


dave.mind:knows({jade,rose,dave,john,aradia,nepeta,terezi},"name")
dave.mind:make_fully_known(dave_house)

john.mind:knows({jade,rose,dave,john,aradia,nepeta,terezi},"name")
john.mind:make_fully_known(john_house)

aradia.mind:knows({jade,rose,dave,john,aradia,nepeta,terezi},"name")
nepeta.mind:knows({jade,rose,dave,john,aradia,nepeta,terezi},"name")
terezi.mind:knows({jade,rose,dave,john,aradia,nepeta,terezi},"name")


nepeta.task = Task('doschedule', {

    goto_sleep = {
        schedule = {
            { task = Task('moveto',aradia_room),
                oncomplete = {
                    { delay = 2, task = Task('act','lay','bed'),
                        oncomplete = {
                            { delay = 2, task = Task('act','sleep')},
                        },
                        onfailed = {
                            { task = Task('act','say','damn')},
                            { delay = 1, task = Task('act','say','that')},
                            { delay = 2, task = Task('act','say','f')},
                        }
                    },
                }
            },
        }
    },

    normal_day = {
        days = 'monday-friday',
        schedule = {
            { at = "9:00", task = Task('act','wakeup')},
            { at = "9:10", task = Task('moveto',jade_room)},
            { at = "9:30", task = Task('moveto',garden)},
            { at = "10:00", task = Task('moveto',aradia_room)},
            { at = "10:10", task = Task('moveto',jade_room)},
            { at = "11:32", task = Task('moveto',aradia_room)},
            { at = "20:00", schedule = 'goto_sleep'},
        }
    },
    weekend = {
        days = 'saturday,sunday',
        schedule = {
            { at = "9:00", task = Task('act','wakeup')},
            
            { at = "20:00", schedule = 'goto_sleep'},
        }
    }
})








jade.task = Task('doschedule', {

    goto_sleep = {
        schedule = {
            { task = Task('moveto',jade_room),
                oncomplete = {
                    { delay = 2, task = Task('act','lay','bed')},
                    { delay = 4, task = Task('act','sleep')},
                }
            },
        }
    },

    normal_day = {
        days = 'monday-sunday',
        schedule = {
            { at = "9:00", task = Task('act','wakeup')}, 
            { at = "9:30", task = Task('moveto',garden)},
            { at = "10:00", task = Task('moveto',aradia_room)},
            { at = "10:10", task = Task('moveto',jade_room)},
            { at = "11:32", task = Task('moveto',local_corner)},
            { at = "12:10", task = Task('moveto',jade_room)},
            { at = "14:30", task = Task('moveto',garden)},
            { at = "17:30", task = Task('moveto',rose_forest)},
            { at = "19:00", task = Task('moveto',jade_room)},
            { at = "20:00", schedule = 'goto_sleep'},
        }
    }
})

rose.task = Task('doschedule', {

    goto_sleep = {
        schedule = {
            { task = Task('moveto',rose_room),
                oncomplete = {
                    { delay = 2, task = Task('act','lay','bed')},
                    { delay = 4, task = Task('act','sleep')},
                }
            },
        }
    },

    normal_day = {
        days = 'monday-sunday',
        schedule = {
            { at = "9:00", task = Task('act','wakeup')}, 
            { at = "9:30", task = Task('moveto',rose_livingroom)},
            { at = "10:00", task = Task('moveto',rose_forest)},
            { at = "11:00", task = Task('moveto',rose_laundry)},
            { at = "12:30", task = Task('moveto',rose_livingroom)},
            { at = "14:10", task = Task('moveto',rose_room)}, 
            { at = "17:30", task = Task('moveto',rose_forest)},
            { at = "19:40", task = Task('moveto',rose_room)},
            { at = "21:00", schedule = 'goto_sleep'},
        }
    }
})

roxy.task = Task('doschedule', {

    goto_sleep = {
        schedule = {
            { task = Task('moveto',roxy_room),
                oncomplete = {
                    { delay = 2, task = Task('act','lay','bed')},
                    { delay = 4, task = Task('act','sleep')},
                }
            },
        }
    },

    normal_day = {
        days = 'monday-sunday',
        schedule = {
            { at = "10:00", task = Task('act','wakeup')}, 
            { at = "11:30", task = Task('moveto',rose_livingroom)}, 
            { at = "12:00", task = Task('moveto',rose_laundry)},
            { at = "12:30", task = Task('moveto',rose_livingroom)}, 
            { at = "14:40", task = Task('moveto',roxy_room)},
            { at = "21:00", schedule = 'goto_sleep'},
        }
    }
})


dave.task = Task('doschedule', {

    goto_sleep = {
        schedule = {
            { task = Task('moveto',dave_room),
                oncomplete = {
                    { delay = 2, task = Task('act','lay','bed')},
                    { delay = 4, task = Task('act','sleep')},
                }
            },
        }
    },

    normal_day = {
        days = 'monday-sunday',
        schedule = {
            { at = "8:00", task = Task('act','wakeup')}, 
            { at = "11:10", task = Task('moveto',dave_livingroom)}, 
            { at = "14:00", task = Task('moveto',dave_roof)},
            { at = "17:30", task = Task('moveto',dave_livingroom)}, 
            { at = "18:40", task = Task('moveto',dave_room)},
            { at = "21:00", schedule = 'goto_sleep'},
        }
    }
})

john.task = Task('doschedule', {

    goto_sleep = {
        schedule = {
            { task = Task('moveto',john_room),
                oncomplete = {
                    { delay = 2, task = Task('act','lay','bed')},
                    { delay = 4, task = Task('act','sleep')},
                }
            },
        }
    },

    normal_day = {
        days = 'monday-sunday',
        schedule = {
            { at = "9:20", task = Task('act','wakeup')}, 
            { at = "9:50", task = Task('moveto',john_bathroom)}, 
            { at = "10:00", task = Task('moveto',john_kitchen)},
            { at = "11:30", task = Task('moveto',john_study)}, 
            { at = "12:40", task = Task('moveto',john_backyard)},
            { at = "14:10", task = Task('moveto',john_frontyard)},
            { at = "16:00", task = Task('moveto',john_room)},
            { at = "18:00", task = Task('moveto',john_livingroom)},
            { at = "19:40", task = Task('moveto',john_kitchen)},
            { at = "20:00", task = Task('moveto',john_room)},
            { at = "21:00", schedule = 'goto_sleep'},
        }
    }
})




aradia.task = Task('doschedule', {

    goto_sleep = {
        schedule = {
            { task = Task('moveto',aradia_room),
                oncomplete = {
                    { delay = 2, task = Task('act','lay','bed')},
                    { delay = 4, task = Task('act','sleep')},
                }
            },
        }
    },

    normal_day = {
        days = 'monday-sunday',
        schedule = {
            { at = "8:00", task = Task('act','wakeup')}, 
            { at = "11:20", task = Task('moveto',local_corner)}, 
            { at = "14:10", task = Task('moveto',garden)},
            { at = "17:20", task = Task('moveto',local_corner)}, 
            { at = "18:10", task = Task('moveto',aradia_room)},
            { at = "21:00", schedule = 'goto_sleep'},
        }
    }
})
--hour = 19
--minute = 50
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