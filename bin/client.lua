local msgHead = require "tcpproto"
local pb = require "pb"

local endcode_data = dofile("transpb.lua")

if endcode_data == "ProtoFileError"
then
    print("Error : Cant Find Input Proto File! Please Input Again")
    return
end

if endcode_data == "MessageNameError"
then
    print("Error : Cant Find Input Message! Please Input Again")
    return
end

local headStr = msgHead:pack({length = 20, type_flag = 1})

local type_msg_id = string.char(12)

local msg_str = headStr .. type_msg_id .. endcode_data

print(pb.tohex(msg_str))

return msg_str