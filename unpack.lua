proto = {}

proto.NET_HEAD_SIZE = 4
proto.NET_HEAD_LEN_SIZE = 3
proto.NET_HEAD_FLAG_SIZE = 1

-- 二进制=ascii

-- 左移
function proto:leftShift(num, shift)
    return math.floor(num * (2 ^ shift));
end
 
-- 右移
function proto:rightShift(num, shift)
    return math.floor(num / (2 ^ shift));
end

-- 转成Ascii
function proto:numToAscii(num)
    num = num % 256;
    return string.char(num);
end

-- 二进制转int
function proto:bufToInt32(num1, num2, num3, num4)
    local num = 0;
    num = num + self:leftShift(num1, 24);
    num = num + self:leftShift(num2, 16);
    num = num + self:leftShift(num3, 8);
    num = num + num4;
    return num;
end
 
-- int转二进制
function proto:int32ToBufStr(num)
    local str = "";
    str = str .. self:numToAscii(self:rightShift(num, 24));
    str = str .. self:numToAscii(self:rightShift(num, 16));
    str = str .. self:numToAscii(self:rightShift(num, 8));
    str = str .. self:numToAscii(num);
    return str;
end

function proto:NilString(str)
    if str == nil
    then
        str = '\0'
    end

    return str
end

0101 0000
function proto:pack(data)
    if data == nil or #data <= 0
    then
        return false, 0, nil
    end

    local str = self:int32ToBufStr(#data)
    local _, head1, head2, head3 = string.byte(str, 1, self.NET_HEAD_SIZE)
    local head_str = string.char(head3) .. string.char(head2) .. string.char(head1) .. string.char(80)

    return true, #data, head_str .. data
end

function proto:unpack(data)
    if data == nil or #data < self.NET_HEAD_SIZE
    then
        return false, 0, nil
    end

    local byte1, byte2, byte3 = string.byte(data, 1, self.NET_HEAD_LEN_SIZE)
    local len = self:bufToInt32(0, byte3, byte2, byte1)
    if #data - self.NET_HEAD_SIZE <  len
    then
        return false, 0, nil
    end

    local pack_data = string.sub(data, self.NET_HEAD_SIZE + 1, len)
    return true, len, pack_data
end

return proto