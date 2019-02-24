proto = {}


proto.MsgHeadName = { "length", "type_flag", "reflect_flag", "reserve_flag", "extend_flag" }
proto.MsgHeadBit  = { 24, 1, 1, 5, 1 }


-- 左移
function proto:leftShift(num, shift)
    return math.floor(num * (2 ^ shift))
end
 
-- 右移
function proto:rightShift(num, shift)
    return math.floor(num / (2 ^ shift))
end

-- 转成Ascii
function proto:numToAscii(num)
    num = num % 256;
    return string.char(num)
end

-- 二进制转int
function proto:bufToInt32(num1, num2, num3, num4)
    local num = 0
    num = num + self:leftShift(num1, 24)
    num = num + self:leftShift(num2, 16)
    num = num + self:leftShift(num3, 8)
    num = num + num4
    return num
end
 
-- int转二进制 little-endian
function proto:int32ToBufStr(num)
    local str = ""
    str = str .. self:numToAscii(num)
    str = str .. self:numToAscii(self:rightShift(num, 8))
    str = str .. self:numToAscii(self:rightShift(num, 16))
    str = str .. self:numToAscii(self:rightShift(num, 24))
    return str
end

function proto:operationAnd(number, leftShiftNum, rightShifNum)
    local tmp = string.byte(self:int32ToBufStr(self:leftShift(number, leftShiftNum)))
    return self:rightShift(tmp, rightShifNum)
end

function proto:flagToBufStr(MsgHeadTable)
    local num = 0
    local locate = 0;
    for i, value in ipairs(self.MsgHeadBit) do
        MsgHeadTable[self.MsgHeadName[i]] = MsgHeadTable[self.MsgHeadName[i]] == nil and 0 or MsgHeadTable[self.MsgHeadName[i]]
        if self.MsgHeadName[i] ~= "length"
        then
            num = num + self:operationAnd(MsgHeadTable[self.MsgHeadName[i]], 8 - value, locate)
            locate = locate + value
        end
    end

    return num
end

function proto:bufStrToFlag(flagValue, MsgHeadTable)
    local locate = 0;
    for i, value in ipairs(self.MsgHeadBit) do
        if self.MsgHeadName[i] ~= "length"
        then
            MsgHeadTable[self.MsgHeadName[i]] = self:operationAnd(flagValue, locate, 8 - value)
            locate = locate + value
        end
    end

<<<<<<< HEAD:tcpproto.lua
    return MsgHeadTable
=======
    return flagTable
>>>>>>> 9c4e0a3de7119e9985a91288586e85d7a10008fd:bin/tcpproto.lua
end

function proto:pack(MsgHeadTable)
    local head_len_str = self:int32ToBufStr(MsgHeadTable["length"])
    local head_flag_str = self:int32ToBufStr(self:flagToBufStr(MsgHeadTable))

    local MsgHead = string.sub(head_len_str, 1, 3) .. string.sub(head_flag_str, 1, 1)
    return MsgHead
end

function proto:unpack(MsgHead)
    local MsgHeadTable = {}
    local byte1, byte2, byte3, byte4 = string.byte(MsgHead, 1, 4)
    local len = self:bufToInt32(0, byte3, byte2, byte1)
    MsgHeadTable["length"] = len

    local flagValue = self:bufToInt32(0, 0, 0, byte4)

    return self:bufStrToFlag(flagValue, MsgHeadTable)
end

return proto
