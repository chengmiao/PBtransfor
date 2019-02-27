package.path = package.path..';/bin/?.lua'

local func = require "transpb"
local head = require "GMsgHead"

--[[
    transpb:load_file(file)        -- 加载proto
    transpb:load(str)              -- 加载文本消息
    transpb:find_message(message)  -- 是否有该消息定义
    transpb:encode(message, data)  -- 根据消息定义，序列化table
    transpb:decode(message, bytes) -- 根据消息定义，反序列话bytes
    head:pack({ length = 0 , type_flag = 0, control_flag = 0, magic_flag   = 0, reflect_flag = 0, reserve_flag = 0, extend_flag  = 0 }) --根据包头结构生成GMsgHead
    head:unpack(headStr)           --根据包头str,返回包头的table结构
--]]


-- client收到服务器返回的数据后的回调，自行定义打印数据或循环发送数据
function on_lua_recv(data, len)
    print(#data)
    local head_table = head:unpack(string.sub(data, 1, 4))
    local data2 = func:decode("SUB.Person", string.sub(data, 5, #data))
    func:showTable(head_table)
end


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
while true do
    if client_lua:isConnected()
    then
        local bytes = func:transpb_by_input()
        local head_str = head:pack({length = #bytes})
        local data = head_str .. bytes

        client_lua:send(data, #data)
    end
end


-- 自定义proto文本，来序列化数据
assert(func.protoc:load [[
   message Phone {
      optional string name        = 1;
      optional int64  phonenumber = 2;
   }
   message Person {
      optional string name     = 1;
      optional int32  age      = 2;
      optional string address  = 3;
      repeated Phone  contacts = 4;
   } ]] )
 

local data = {
   name = "ilse",
   age  = 18,
   contacts = {
      { name = "alice", phonenumber = 12312341234 },
      { name = "bob",   phonenumber = 45645674567 }
   }
}

local bytes = assert(func:encode("Person", data))
func:toHex(bytes)

local data2 = assert(func:decode("Person", bytes))
func:showTable(data2)




