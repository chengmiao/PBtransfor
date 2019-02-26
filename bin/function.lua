local transpb = require "transpb"

func = {}


-- 根据交互 输入proto文件名，message名，字段值，通过PB协议来序列化数据
function func:encode_by_input()
    local bytes = transpb:transpb_by_input()
    return bytes
end


-- 根据函数传参，通过PB协议来序列化数据
function func:encode_by_args(file, message, data)
    if not transpb:load_file(file)
    then
        return
    end

    if not transpb:find_message(message)
    then
        return
    end

    local bytes = transpb:encode(message, data)

    return bytes
end


-- 根据函数传参，反序列化PB协议数据
function func:decode(message, bytes)
    if not transpb:find_message(message)
    then
        return
    end

    local data = transpb:decode(message, bytes)

    return data
end


-- 收到服务器发来的数据

return func



