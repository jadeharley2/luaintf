

no_one = Def('no_one',{name='No one'},'person')
no_mind = no_mind or {}


female  = Def('female',{gender = 'female',their = 'her', they = 'she', are = 'is'},'adjective')
male    = Def('male',  {gender = 'male',their = 'his', they = 'he', are = 'is'},'adjective')
neuter  = Def('neuter',{gender = 'neuter',their = 'its', they = 'it', are = 'is'},'adjective')
plural  = Def('plural',{gender = 'plural',their = 'their', they = 'they', are = 'are'},'adjective')

thing.gender = 'neuter'
thing.their = 'its'
thing.they = 'it'
thing.are = 'is' 



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
book.image = '/img/items/book.png'


bedroom = Def('bedroom','room')
kitchen = Def('kitchen','room')
bathroom = Def('bathroom','room')
guestroom = Def('guestroom','room')

--personal things -- outdated -- use owned adjective



--personal_room = Def('personal_room','room')
--personal_room._get_name = LF[[ [self.prefix] [IF(player==self.owner,"My",self.owner.name.."'s")] [self.postfix] ]]
--personal_room.postfix = 'room'
--personal_room.owner = no_one

 



robot = Def('robot','adjective')
robot.should_wear_clothes = false


