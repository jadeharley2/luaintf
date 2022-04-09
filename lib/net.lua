socket = require "socket"

net = {}
net.clients = {}

local meta_client = {}

function meta_client:send(data)
    local result,err,arg = self.socket:send(data)
    if err then
        local x=0
        print('socket error:',err)
        self.socket:close()
        EventCall('player_disconnected',self)
        net.clients[self.id] = nil
    end
end
meta_client.__index = meta_client

function net.start(host,port)
    net.s = socket.tcp()
    local x,err = net.s:bind(host,port) --'localhost',9999)
    print(x,err)
    net.s:listen(10)
    net.s:settimeout(0)
end

function net.accept()
    local x,code = net.s:accept()
    if x then 
        local id = #net.clients+1
        x:settimeout(0)
        local cli = setmetatable({
            socket = x,
            id = id,
        },meta_client)
        net.clients[id] = cli
        print('accepted client ',id)
        EventCall('player_connected',cli)
    end
end 

function net.check()--check connections
    for k,v in pairs(net.clients) do
        v:send('$\n')
    end
end

--callback(client, message)
function net.receive(callback) 
    for k,v in pairs(net.clients) do
        local x,code = v.socket:receive('*l')
        if x then
            if x=='$Q'then
                v.socket:close()
                EventCall('player_disconnected',v)
                net.clients[v.id] = nil
            else
                pcall(callback,v,x)
            end
        end
    end
end
function net.broadcast(msg,ignore)
    for k,v in pairs(net.clients) do
        if v~=ignore then
            v:send(msg..'\n')
        end
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