proto = {}

proto.NET_HEAD_SIZE = 4
proto.NET_HEAD_LEN_SIZE = 3
proto.NET_HEAD_FLAG_SIZE = 1

proto.extend_size_table = { 1, 1, 0, 1, 0, 0, 0, 0 }

-- 二进制=ascii

function proto:tableToExtendBinary(extend_value_table)
    local num = 0
    local str = ""
    for i=1, #extend_value_table do
        if extend_value_table[i] ~= ""
        then
            num = num + self:leftShift(1, #self.extend_size_table - i)
            str = str .. string.sub(extend_value_table[i], 1, self.extend_size_table[i])
        end
    end

    return self:numToAscii(num), str
end

function proto:binaryToExtendTable(data)
    local extend_value_table = {}
    local num = string.byte(data, 1, 1)
    local count = 0;
    for i=1, #self.extend_size_table do
        local tmp = proto:rightShift(num, #self.extend_size_table - i)
        if tmp == 1
        then
            local str_value = string.sub(data, 2 + count, 2 + count + self.extend_size_table[i])
            table.insert(extend_value_table, str_value)
            num = num - proto:leftShift(tmp, #self.extend_size_table - i)
            count = count + #str_value
        else
            table.insert(extend_value_table, "")
        end
    end

    return extend_value_table, string.sub(data, 1 + count, #data)
end

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
 
-- int转二进制
function proto:int32ToBufStr(num)
    local str = ""
    str = str .. self:numToAscii(self:rightShift(num, 24))
    str = str .. self:numToAscii(self:rightShift(num, 16))
    str = str .. self:numToAscii(self:rightShift(num, 8))
    str = str .. self:numToAscii(num)
    return str
end

function proto:pack(data, extend_value_table)
    if data == nil or #data <= 0
    then
        return false, 0, nil
    end

    local str = self:int32ToBufStr(#data)
    local _, head1, head2, head3 = string.byte(str, 1, self.NET_HEAD_SIZE)
    local head_str = string.char(head3) .. string.char(head2) .. string.char(head1)

    local head_extend, data_extend = self:tableToExtendBinary(extend_value_table)

    return true, #data, head_str .. head_extend .. data_extend .. data
end

function proto:unpack(data)
    if data == nil or #data < self.NET_HEAD_SIZE
    then
        return false
    end

    local byte1, byte2, byte3 = string.byte(data, 1, self.NET_HEAD_LEN_SIZE)
    local len = self:bufToInt32(0, byte3, byte2, byte1)
    if #data - self.NET_HEAD_SIZE <  len
    then
        return false
    end

    local extend_pack_data = string.sub(data, self.NET_HEAD_LEN_SIZE + 1, #data)

    local tmp_table, pack_data = self:binaryToExtendTable(extend_pack_data)

    return true, len, pack_data, tmp_table
end

return proto