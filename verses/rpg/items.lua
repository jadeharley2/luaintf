
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


drink_interaction = Def('drink_interaction',{key='drink',user_restrictions = {"!asleep"},callback = function(self,user,arg1,...) 
    
    
    describe_action(self,L'you drink from [self]',L'[user] drinks from [self]')  
    self:call("on_consume",user)

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
