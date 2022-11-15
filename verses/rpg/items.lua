


drink_interaction = Def('drink_interaction',{key='drink',user_restrictions = {"!asleep"},callback = function(self,user,arg1,...) 
    
    
    describe_action(self,L'you drink from [self]',L'[user] drinks from [self]')  
    self:call("on_consume",user)

    return true;
end},'interaction') 




item_mushroom = Def('mushroom',{name='mushroom'},'thing')

item_mushroom_red = Def('mushroom_red',{name='red mushroom'},'mushroom')
item_mushroom_red.image = '/img/rpg/items/mushroom_red.png'

item_mushroom_white = Def('mushroom_white',{name='white mushroom'},'mushroom')
item_mushroom_white.image = '/img/rpg/items/mushroom_white.png'

item_mushroom_brown = Def('mushroom_brown',{name='brown mushroom'},'mushroom')
item_mushroom_brown.image = '/img/rpg/items/mushroom.png'


item_potion = Def('potion',{name='potion'},'thing')
item_potion.image = '/img/rpg/items/potion_y.png'
item_potion:interact_add("drink_interaction")

item_feral_potion = Def('feral_potion',{name='red potion'},'potion')
item_feral_potion.image = '/img/rpg/items/potion_r.png'
function item_feral_potion:on_consume(by)
    local animal_form = by.animal_form
    if animal_form then
        Rebase(by,animal_form,true)
    end
end

item_antiferal_potion = Def('antiferal_potion',{name='brown potion'},'potion')
item_antiferal_potion.image = '/img/rpg/items/potion_br.png'
function item_antiferal_potion:on_consume(by)
    local sentient_form = by.sentient_form
    if sentient_form then
        Rebase(by,sentient_form,true)
    end
end


item_masc_potion = Def('masc_potion',{name='blue potion'},'potion')
item_masc_potion.image = '/img/rpg/items/potion_b.png'
function item_masc_potion:on_consume(by)
    by:adj_unset('female')
    by:adj_set('male')
end

item_fem_potion = Def('fem_potion',{name='pink potion'},'potion')
item_fem_potion.image = '/img/rpg/items/potion_p.png'
function item_fem_potion:on_consume(by)
    by:adj_unset('male')
    by:adj_set('female')
end


item_debug_bag = Def('debug_bag',{name='debug bag'},'cabinet')
item_debug_bag.image = '/img/rpg/items/bag.png'
item_debug_bag.items = {"fem_potion",'masc_potion',"feral_potion","antiferal_potion"}
item_debug_bag:interact_add("open_interaction")
item_debug_bag:interact_add("close_interaction")
function item_debug_bag:on_init()
    for k,v in pairs(self.items) do
        Inst(v).location = self  
    end
end


item_gemstone = Def('gemstone',{name='emerald'},'thing')

item_emerald = Def('emerald',{name='emerald'},'gemstone')
item_emerald.image = '/img/rpg/items/emerald2.png'

item_ruby = Def('ruby',{name='ruby'},'gemstone')
item_ruby.image = '/img/rpg/items/ruby.png'

item_sapphire = Def('sapphire',{name='sapphire'},'gemstone')
item_sapphire.image = '/img/rpg/items/sapphire.png'

item_topaz = Def('topaz',{name='topaz'},'gemstone')
item_topaz.image = '/img/rpg/items/topaz.png'

item_diamond = Def('diamond',{name='diamond'},'gemstone')
item_diamond.image = '/img/rpg/items/diamond.png'



throw_at_interaction = Def('throw_at_interaction',{key='throw_at',user_restrictions = {"!asleep"},callback = function(self,user,arg1,...) 
    
    local target = LocalIdentify(arg1)
    if target then
        self.location = target.location
        --calculate strike chance .... idk
        if math.random()>0.8 then
            -- hit!
            describe_action(self,L'you throw [self] at [target]!',L'[user] throws [self] at [target]!')  
            self:call("on_hit",target,user)
        else
            -- just drop 
            describe_action(self,L'you try to throw [self] but miss your target!',L'[user] tries to throw [self] at [target] but misses!')  

        end

    else
        printout(L"there is no [arg1]")
    end

    return true;
end},'interaction') 



ec_flask = Def('ec_flask',{name='essence flask'},'thing')

ec_flask:interact_add(throw_at_interaction)
ec_flask:interact_add(drink_interaction)

function ec_flask:on_hit(target)
    if self.essence then
        --printout("but nothing happens")
    else 
        self.essence = target:adj_concat()..' '..target.base.id  
        printto(self.location, "*ding*")
    end
end
function ec_flask:on_consume(by)
    if self.essence then
        printout(by:adj_concat()..' '..by.base.id  )
        printout('to')
        printout(self.essence  )
        Rebase(by,self.essence)
        self.essence = nil 

        send_style(by) 
        send_actions(by) 
        if player then 
            examine(player.location)   
        end
    else
        printout('there is nothing inside')
    end 
end

function ec_flask:_get_description()
    if self.essence then
        return L"It is filled with [self.essence] essence."
    else
        return L"It is empty."
    end
end
ec_flask.examine= nil

item_ec_flask_woods = Def('ec_flask_woods',{name='woodland flask'},'ec_flask')
item_ec_flask_woods.image = '/img/rpg/items/potion_g.png'


craft.DefCombineRecipe('flask_woods',item_emerald,item_ruby,item_ec_flask_woods)
