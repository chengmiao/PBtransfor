local data = "\0\0\a0chengmiao@lindadfdfdfdfdfdfddf"

local num1, num2, num3 = string.byte(data, 1, 3)

-- 二进制=ascii
-- 二进制转int
function bufToInt32(tonumber(num1), tonumber(num2), tonumber(num3), tonumber(num4)
    local num = 0;
    num = num + leftShift(num1, 24);
    num = num + leftShift(num2, 16);
    num = num + leftShift(num3, 8);
    num = num + num4;
    return num;
end
 
-- int转二进制
function int32ToBufStr(num)
    local str = "";
    str = str .. numToAscii(rightShift(num, 24));
    str = str .. numToAscii(rightShift(num, 16));
    str = str .. numToAscii(rightShift(num, 8));
    str = str .. numToAscii(num);
    return str;
end
 
-- 左移
function leftShift(num, shift)
    return math.floor(num * (2 ^ shift));
end
 
-- 右移
function rightShift(num, shift)
    return math.floor(num / (2 ^ shift));
end

-- 转成Ascii
function numToAscii(num)
    num = num % 256;
    return string.char(num);
end

local len = bufToInt32("\0", num1, num2, num3)

return len