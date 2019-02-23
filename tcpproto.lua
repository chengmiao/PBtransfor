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
    local tmp = string.byte(self:int32ToBufStr(self:leftShift(number, shiftNum)))
    return self:rightShift(tmp, rightShifNum)
end

function proto:flagToBUfStr(headTable)
    local num = 0
    local locate = 0;
    for i, value in ipairs(self.MsgHeadBit) do
        headTable[self.MsgHeadName[i]] = headTable[self.MsgHeadName[i]] == nil and 0 or headTable[self.MsgHeadName[i]]
        if self.MsgHeadName[i] ~= "length"
        then
            num = num + self:operationAnd(headTable[self.MsgHeadName[i]], 8 - value, locate)
            locate = locate + value
        end
    end

    --local tmp = string.byte(self:int32ToBufStr(self:leftShift(headTable["type_flag"], 7)))
    --num = num + tmp

    --tmp = string.byte(self:int32ToBufStr(self:leftShift(headTable["reflect_flag"], 7)))
    --num = num + self:rightShift(tmp, 1)

    --tmp = string.byte(self:int32ToBufStr(self:leftShift(headTable["reserve_flag"], 3)))
    --num = num + self:rightShift(tmp, 2)

    --tmp = string.byte(self:int32ToBufStr(self:leftShift(headTable["extend_flag"], 7)))
    --num = num + self:rightShift(tmp, 7)

    return num
end

function proto:bufStrToFlag(flagValue, flagTable)
    local locate = 0;
    for i, value in ipairs(self.MsgHeadBit) do
        if self.MsgHeadName[i] ~= "length"
        then
            flagTable[self.MsgHeadName[i]] = self:operationAnd(flagValue, locate, 8 - value)
            locate = locate + value
        end
    end


    --flagTable["type_flag"] = self:rightShift(flagValue, 7)

    --local num = string.byte(self:int32ToBufStr(self:leftShift(flagValue, 1)))
    --flagTable["reflect_flag"] = self:rightShift(num, 7)

    --num = string.byte(self:int32ToBufStr(self:leftShift(flagValue, 2)))
    --flagTable["reserve_flag"] = self:rightShift(num, 3)

    --num = string.byte(self:int32ToBufStr(self:leftShift(flagValue, 7)))
    --flagTable["extend_flag"] = self:rightShift(num, 7)

    return flagTable
end

function proto:pack(MsgHead)
    local head_len_str = self:int32ToBufStr(MsgHead["length"])
    local head_flag_str = self:int32ToBufStr(self:flagToBUfStr(MsgHead))

    local head = string.sub(head_len_str, 1, 3) .. string.sub(head_flag_str, 1, 1)
    return head
end

function proto:unpack(headStr)
    local MsgHead = {}
    local byte1, byte2, byte3, byte4 = string.byte(headStr, 1, 4)
    local len = self:bufToInt32(0, byte3, byte2, byte1)
    MsgHead["length"] = len

    local flag = self:bufToInt32(0, 0, 0, byte4)

    return self:bufStrToFlag(flag, MsgHead)
end

return proto
