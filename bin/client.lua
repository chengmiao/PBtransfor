--package.cpath = package.cpath..';../lib/?.so'

--local pb = require "pb"
local bit = require "tcpproto"
local msgHead = require "newProto"


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

-- string length and flag type to build GMsgHead
local headStr = msgHead:pack({length = #endcode_data, type_flag = 1})

-- flag type to build unint32 msg id, example is 12
local type_msg_id = bit:int32ToBufStr(12)

-- the total msg
local msg_str = headStr .. type_msg_id .. endcode_data

--print(pb.tohex(msg_str))

return msg_str