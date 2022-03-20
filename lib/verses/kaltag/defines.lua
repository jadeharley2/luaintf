

year = 16510
era = 'SST'


siania = Def('siania',{name="Queendom of Siania"},'soverign_state')

katric = Def('katric',{name="Katric"},'soverign_state') -- founded: 3120 SE from siania
kaltag = Def('kaltag','organization')









anthroid_visor = Def("anthroid_visor",{name="anthroid visor"},"visor")
anthroid_collar = Def("anthroid_collar",{name="anthroid collar"},"necklace")
anthroid_uniform = Def("anthroid_uniform",{name="anthroid uniform"},"uniform")
anthroid_long_gloves = Def("anthroid_long_gloves",{name="anthroid long gloves"},"gloves")
anthroid_gloves = Def("anthroid_gloves",{name="anthroid gloves"},"gloves")

anthroid_stocking = Def("anthroid_stocking",{name="anthroid stocking"},"stocking")
katrician_uniform = Def("katrician_uniform",{name="katrician uniform"},"uniform")




local function prnth(node,level)
    for k,v in pairs(node) do
        printout(string.rep(" ", level*2)..L' > [v.val] is a [v.val.base.name]') 
        prnth(v.subs,level+1)
    end
end






press_interaction = Def('press_interaction',{key='press',callback = function(self,user,key) 
    local is_player = user == player 

    if key then
        local btns = self.buttons
        if btns then
            local x = btns[key]
            if x then
                if is_player then  printout('you press '..key..' on '..self.name) end
                x(self,user,key)
            else
                if is_player then  printout('there is no button '..key) end
            end
        else
            printout('there is no buttons on '..self.name)
        end
    else
        if is_player then
            local lst = {}
            self:foreach('buttons',function(k,v) lst[#lst+1] = k end)
            printout('button list: '..table.concat(lst,', '))
        end
    end
    self:say(text)

end},'interaction')

command_interaction = Def('command_interaction',{key='command',callback = function(self,user,act,arg1,...) 
    local is_player = user == player 

    local something = LocalIdentify(arg1)
    if something then
        if something:interact(self,act,arg2,arg3,...) then
            return true 
        end 
    end
    --todo: check permissons or resist
    self:act(act,arg1,...)

end},'interaction') 