

no_one = Def('no_one',{name='No one'},'person')


organization = Def('organization','thing')
soverign_state = Def('soverign_state',{name="Soverign state"},'organization')


city = Def('city','thing')

building = Def('building','thing')
thing._get_is_inside_building = function(self)
    return self:foreach_parent(function(s)
        if s:is(building) then
            return true
        end
    end,false)
end


book = Def('book','thing') 
book.description = 'an ordinary book'

mirror = Def('mirror','thing') 
mirror.examine = function(s) 
    printout('you look into mirror and see..')
    examine(player)
end


bedroom = Def('bedroom','room')
kitchen = Def('kitchen','room')
bathroom = Def('bathroom','room')
guestroom = Def('guestroom','room')

--personal things -- outdated -- use owned adjective



personal_room = Def('personal_room','room')
personal_room._get_name = LF[[ [self.prefix] [IF(player==self.owner,"My",self.owner.name.."'s")] [self.postfix] ]]
personal_room.postfix = 'room'
personal_room.owner = no_one


person:response('give me your cloth',function(s,t,str)
    s:say("ok")
    for k,v in pairs(s.clothes) do
        s:act('drop',v.id)
    end
end)