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


function proto:pack(data)
    if data == nil or #data <= 0
    then
        return false, 0, nil
    end

    local head_str = self:int32ToBufStr(#data)
    head_str = head_str .. string.char(80)

    return true, #data, head_str .. data
end

function proto:unpack(data)
    if data == nil or #data < NET_HEAD_SIZE
    then
        return false, 0, nil
    end

    local byte1, byte2, byte3 = string.byte(data, 1, NET_HEAD_LEN_SIZE)
    local len = self:bufToInt32(0, byte1, byte2, byte3)
    if #data - NET_HEAD_SIZE <  len
    then
        return false, 0, nil
    end

    local pack_data = string.sub(data, NET_HEAD_SIZE + 1, len)
    return true, len, pack_data
end