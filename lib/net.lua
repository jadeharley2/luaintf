socket = require "socket"

net = {}
net.clients = {}

function net.start(host,port)
    net.s = socket.tcp()
    net.s:bind(host,port) --'localhost',9999)
    net.s:listen(10)
    net.s:settimeout(0)
end

function net.accept()
    local x,code = net.s:accept()
    if x then 
        local id = #net.clients+1
        x:settimeout(0)
        net.clients[id] = {
            socket = x,
            id = id,
        }
        print('accepted client ',id)
    end
end 

--callback(client, message)
function net.receive(callback) 
    for k,v in pairs(net.clients) do
        local x,code = v.socket:receive('*l')
        if x then
            callback(v,x)
        end
    end
end
function net.broadcast(msg)
    for k,v in pairs(net.clients) do
        v.socket:send(msg..'\n')
    end
end


function net.client_connect(host,port)
    net.s = socket.tcp()
    local r,err = net.s:connect(host,port)  
    net.s:settimeout(0)
    if r then print('connected!') end
    return r,err
end
function net.client_receive(callback) 
    local x,code = net.s:receive('*l')
    if x then
        callback(x)
    end
end
function net.client_send(msg) 
    net.s:send(msg)--..'\n')
end