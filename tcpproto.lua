proto = {}

--[[

MsgHead = {
    length        = 0,
    type_flag     = 0,
    reflect_flag  = 0,
    reserve_flag  = 0,
    extend_flag   = 0,
}

--]]

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

function proto:pack(MsgHead)
    local head_len_str = self:int32ToBufStr(MsgHead["length"])
    local head_flag_str = self:int32ToBufStr(MsgHead["flag"])

    local head = string.sub(head_len_str, 1, 3) .. string.sub(head_flag_str, 1, 1)
    return head
end

function proto:unpack(headStr)
    local MsgHead = {}
    local byte1, byte2, byte3, byte4 = string.byte(headStr, 1, 4)
    local len = self:bufToInt32(0, byte3, byte2, byte1)
    MsgHead["length"] = len

    local flag = self:bufToInt32(0, 0, 0, byte4)
    MsgHead["flag"] = flag

    return MsgHead
end

return proto