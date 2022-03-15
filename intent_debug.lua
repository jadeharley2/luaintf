dofile('base_inform.lua')



function main() 
    while true do
        local input = io.read():trim()
        if #input>0 then 
            local args = input:split(' ')
            print('intents:')
            local intent = GetIntents(input)
            PrintTable(intent) 
            print('others:')
            if next(intent) then
                PrintTable(GetIntentTexts(intent))
            end
            
        end 
    end
end

main()