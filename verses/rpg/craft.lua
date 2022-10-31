
combine_recipes = combine_recipes or {}
shortcuts = shortcuts or {}

craft = craft or {}


function craft.DefCombineRecipe(id,a,b,result)

    combine_recipes[id] = {
        components = {a,b},
        result = {result},
    }
    shortcuts[a.id..'_'..b.id] = id
    shortcuts[b.id..'_'..a.id] = id
end

function craft.DoCombine(user,a,b)
    local rec = shortcuts[a.base.id..'_'..b.base.id]
    if rec then
        local R = combine_recipes[rec]
        if R then 
            local x = Inst(R.result[1].id)
            if x then
                x.location = user 
                a.location = nil
                b.location = nil
                return x
            end
        end
    end
    return false
end

combine_action = Def('combine_action',{key='combine',restrictions = {"can_move"},callback = function(self,a,b)    
    
    local A = LocalIdentify(a,self)
    local B = LocalIdentify(b,self)
    if A then
        if B then
            local rez = craft.DoCombine(self,A,B)
            if rez then 
                describe_action(self,L"you combine [A] and [B] into [rez]",
                L"[self] makes something")

            end
        else 
            if is_player then printout(L"there is no [b]") end
        end
    else 
        if is_player then printout(L"there is no [a]") end
    end
    

    return false -- no enturn
end},'action')
person:act_add(combine_action)