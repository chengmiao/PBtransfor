-- 客户端连接服务器
client_lua = client.new(lua)
if client_lua == nil
then
    return
end

print("Please Enter Server IP : ")
local ip = io.read();
print("Please Enter Server Port : ")
local port = io.read()

client_lua:connect(ip, tonumber(port), true)






