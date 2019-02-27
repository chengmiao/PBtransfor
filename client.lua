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

function pack_flag(flag_table)
    return ""
end

function unpack_flag(bytes)
end

-- client收到服务器返回的数据后的回调，自行定义打印数据
function on_lua_recv(data, len)
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

-- 根据用户输入，来发送pb序列化数据
while true do
    print("===============TransPB Start================")
    -- 根据输入，获得序列化的pb数据
    local bytes = func:transpb_by_input()

    -- 生成包头
    local head_str = head:pack({length = #bytes})

    -- 生成flag扩展字段
    local flag = pack_flag({type_flag = 1})

    local data = head_str .. flag .. bytes
    func:toHex(data)
    if client_lua:isConnected()
    then
        client_lua:send(data, #data)
    end
    print("===============TransPB End!!================")
    io.read()
end






