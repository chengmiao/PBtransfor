local func = require "function"
local head = require "GMsgHead"

function on_lua_recv(data)
    print("OnRecv Server Message")
end

local client_lua = client.new(lua)
if client_lua == nil
then
    return
end

print("Please Enter Server IP : ")
local ip = io.read();
print("Please Enter Server Port : ")
local port = io.read()

client_lua:connect(ip, tonumber(port), true)

while true do
    if client_lua:isConnected()
    then
        local bytes = func:encode_by_input()

        if bytes ~= nil 
        then
            local head_str = head:pack({length = #bytes})
            local data = head_str .. bytes

            client_lua:send(data, #data)
        end
    end
end



