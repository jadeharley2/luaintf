
dofile('lib/script.lua')
Include("lib/string.lua") 
Include("lib/net.lua")

winapi = require 'winapi'

Include("lib/win.lua")


function main() 
    local r,err =net.client_connect('localhost',9999)
    --while true do
    --    print(io.read("*line"))
    --    local input = io.read():trim()
    --    if #input>0 then 
    --        net.client_send(input)
    --        net.client_receive()
    --    end 
    --end

    local msgs ={}
    function prtn()
        os.execute("cls")
        for k,v in ipairs(msgs) do 
            print_c_msg(v) 
        end
    end
    
    
    f = winapi.get_console()


    f:read_async(function(line)
    --f:write(line) 
    --print(line..".A.")
        net.client_send(line)
        prtn()
    end)

    while true do
        net.client_receive(function(msg)
            msgs[#msgs+1] = msg
            prtn()
        end)
        winapi.sleep(1)
    end
end

main()