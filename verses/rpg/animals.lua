
species_animal = Def('animal',{},'feral person')

species_animal.should_wear_clothes = false
function species_animal:_get_image()
    return adj_choice_tree(self,self.species_images)
end
function species_animal:_get_icon()
    return self.image:sub(1,-5)..'_av.png'
end  
function species_animal:_get_unknown_name()
    return adj_choice_tree(self,self.species_names)
end


Include("animals/deer.lua")
Include("animals/sheep.lua")
Include("animals/wolf.lua")
Include("animals/fox.lua")

Include("animals/aardwolf.lua")
Include("animals/coyote.lua")
Include("animals/fennec.lua")
Include("animals/ferret.lua")
Include("animals/hyena.lua")
Include("animals/jackal.lua")
Include("animals/otter.lua")
Include("animals/raccoon.lua") 
Include("animals/skunk.lua")
Include("animals/squirrel.lua")
