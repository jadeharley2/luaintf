

organization = Def('organization','thing')
soverign_state = Def('soverign_state',{name="Soverign state"},'organization')


city = Def('city','thing')

building = Def('building','thing')



mirror = Def('mirror','thing') 
mirror.examine = function(s) 
    printout('you look into mirror and see..')
    examine(player)
end



--personal things


personal_room = Def('personal_room','room')
personal_room._get_name = LF[[ [self.prefix] [IF(player==self.owner,"My",self.owner.name.."'s")] [self.postfix] ]]
personal_room.postfix = 'room'
personal_room.owner = no_one
