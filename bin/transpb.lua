package.path = package.path..';../opt/lua-protobuf/?.lua'
package.cpath = package.cpath..';../lib/?.so'

local pb = require "pb"
local protoc = require "protoc"

protoc.paths[#protoc.paths + 1] = "../proto"
protoc.include_imports = true
pb.option("enum_as_value")

transpb = {}

function transpb:load_file(filename)
    local func1 = function() protoc:loadfile(filename) end
    if not pcall(func1)
    then
        return false
    end

    return true
end

function transpb:find_message(message)
    local dataType = nil
    local type_table = {}

    for name in pb.types() do
        type_table[name] = name
        if name == "."..message then
            dataType = name
        end
    end

    return dataType, type_table
end

function transpb:encode(message, data)
    -- encode lua table data into binary format in lua string and return
    local bytes = assert(pb.encode(message, data))
    print(pb.tohex(bytes))

    -- and decode the binary data back into lua table
    local data2 = assert(pb.decode(message, bytes))
    print(require "serpent".block(data2))

    return bytes
end

function transpb:decode(message, bytes)
    -- and decode the binary data back into lua table
    local data2 = assert(pb.decode(message, bytes))
    print(require "serpent".block(data2))

    return data2
end

function transpb:transpb_by_input()
    print("===============TransPB Start================")
    print("Enter Proto File Name :")

    local filename = io.read()
    if not self:load_file(filename)
    then
        print("Error : Cant Find Input Proto File! Please Input Again")
        return
    end

    print("Enter Message Type Name :")
    local messageName = io.read()
    if not self:find_message(messageName)
    then
        print("Error : Cant Find Input Message! Please Input Again")
        return
    end
    
    local data = {}
    local dataType, type_table = self:find_message(messageName)
    MakeMessageTable(dataType, data, type_table)

    local bytes = self:encode(messageName, data)

    print("===============TransPB End!!================")

    return bytes
end


local randomData = {
    bool     = function(str) return str == "true" end,
    string   = function(str) return tostring(str) end,
    bytes    = function(str) return tostring(str) end,
    other    = function(str) return tonumber(str) end
}

-- 获取重复字段的重复次数
function GetRepeatedFieldNums(MessageType, FieldName, FieldOption)
    local repeat_num = 1
    local is_repeated = false
    if FieldOption == "repeated" or option == "packed" then
        is_repeated = true
        print("Enter Repeated Nums :Message->" .. MessageType .. "    FieldName->" .. FieldName)
        local RepeatedNums = io.read()
        repeat_num = tonumber(RepeatedNums)
    end

    if repeat_num == nil then repeat_num = 0 end

    return repeat_num, is_repeated
end

-- 处理protobuf消息中的基础类型
function HandleMessageBaseType(MessageTable, MessageType, FieldName, FieldIndex, FieldBaseType, FieldOption)
    local num, is_repeated = GetRepeatedFieldNums(MessageType, FieldName, FieldOption)

    if num > 1 or is_repeated then
        MessageTable[FieldName] = {}
        for i=1, num do
            print("Enter Type Value")
            print("Message       :    " .. MessageType)
            print("FieldName     :    " .. FieldName)
            print("FieldIndex    :    " .. tostring(FieldIndex))
            print("FieldBaseType :    " .. FieldBaseType)
            print("FieldOption   :    " .. FieldOption)
            local TypeValue = io.read()
       
            if randomData[FieldBaseType] ~= nil then
                MessageTable[FieldName][i] = randomData[FieldBaseType](TypeValue)
            else
                MessageTable[FieldName][i] = randomData["other"](TypeValue)
            end
        end
    else
        print("Enter Type Value")
        print("Message       :    " .. MessageType)
        print("FieldName     :    " .. FieldName)
        print("FieldIndex    :    " .. tostring(FieldIndex))
        print("FieldBaseType :    " .. FieldBaseType)
        print("FieldOption   :    " .. FieldOption)
        local TypeValue = io.read()

        if randomData[FieldBaseType] ~= nil then
            MessageTable[FieldName] = randomData[FieldBaseType](TypeValue)
        else
            MessageTable[FieldName] = randomData["other"](TypeValue)
        end
    end
end

-- 处理protobuf消息中的枚举类型
function HandleMessageEnumType(MessageTable, FieldName, FieldIndex, FieldBaseType)
    local enum_name = ""
    local i = 0
    local enum_table = {}
    while pb.enum(FieldBaseType, i) ~= nil do
        enum_name = enum_name..pb.enum(FieldBaseType, i).."  "
        enum_table[pb.enum(FieldBaseType, i)] = "Enum"
        i = i + 1
    end

    print("Choose Enum Value :Enum Type->" .. FieldBaseType .. "    Enum Value->" .. enum_name)
    print("Name    :=    " .. FieldName)
    print("Index   :    " .. tostring(FieldIndex))
    local EnumValue = io.read()

    if pb.enum(FieldBaseType, tostring(EnumValue)) ~= nil and enum_table[tostring(EnumValue)] ~= nil then
        MessageTable[FieldName] = tostring(EnumValue)
    end
end

-- 处理protobuf消息中的嵌套消息类型
function HandleMessageNestType(MessageTable, MessageType, FieldName, FieldBaseType, FieldOption, type_table)
    local num = GetRepeatedFieldNums(MessageType, FieldName, FieldOption)

    MessageTable[FieldName] = {}
    for i=1, num do
        MessageTable[FieldName][i] = MakeMessageTable(FieldBaseType, {}, type_table)
    end
end

function MakeMessageTable(field_type, main_table, type_table) 
    for name, number, type, value, option in pb.fields(field_type) do
        if type_table[type] == nil then
            HandleMessageBaseType(main_table, field_type, name, number, type, option)
        else 
            local _, _, subType = pb.type(type)
            if subType == "enum" then
                HandleMessageEnumType(main_table, name, number, type)
            elseif subType == "message" then
                HandleMessageNestType(main_table, field_type, name, type, option, type_table)
            end
        end
    end

    return main_table
end

return transpb