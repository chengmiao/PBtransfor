package.path = package.path..';../opt/lua-protobuf/?.lua'
package.cpath = package.cpath..';../lib/?.so'


local pb = require "pb"
local protoc = require "protoc"
local pack = require "tcpproto"


protoc.paths[#protoc.paths + 1] = "../proto"
protoc.include_imports = true
pb.option("enum_as_value")



local func1 = function() protoc:loadfile(filename) end
if not pcall(func1)
then 
    return "ProtoFileError"
end


local randomData = {
    bool     = function(str) return str == "true" end,
    string   = function(str) return tostring(str) end,
    bytes    = function(str) return tostring(str) end,
    other    = function(str) return tonumber(str) end
}

local data = {}
local type_table = {}

-- 获取重复字段的重复次数
function GetRepeatedFieldNums(MessageType, FieldName, FieldOption)
    local repeat_num = 1
    local is_repeated = false
    if FieldOption == "repeated" or option == "packed" then
        is_repeated = true
        FieldRepeatNumFunc(MessageType, FieldName)
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
            TypeFieldFunc(MessageType, FieldName, tostring(FieldIndex), FieldBaseType, FieldOption)
            if randomData[FieldBaseType] ~= nil then
                MessageTable[FieldName][i] = randomData[FieldBaseType](TypeValue)
            else
                MessageTable[FieldName][i] = randomData["other"](TypeValue)
            end
        end
    else
        TypeFieldFunc(MessageType, FieldName, tostring(FieldIndex), FieldBaseType, FieldOption)
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

    ChooseEnumFunc(enum_name, FieldBaseType, tostring(FieldIndex), FieldName)

    if pb.enum(FieldBaseType, tostring(EnumValue)) ~= nil and enum_table[tostring(EnumValue)] ~= nil then
        MessageTable[FieldName] = tostring(EnumValue)
    end
end

-- 处理protobuf消息中的嵌套消息类型
function HandleMessageNestType(MessageTable, MessageType, FieldName, FieldBaseType, FieldOption)
    local num = GetRepeatedFieldNums(MessageType, FieldName, FieldOption)

    MessageTable[FieldName] = {}
    for i=1, num do
        MessageTable[FieldName][i] = MakeMessageTable(FieldBaseType, {})
    end
end

function MakeMessageTable(field_type, main_table) 
    for name, number, type, value, option in pb.fields(field_type) do
        if type_table[type] == nil then
            HandleMessageBaseType(main_table, field_type, name, number, type, option)
        else 
            local _, _, subType = pb.type(type)
            if subType == "enum" then
                HandleMessageEnumType(main_table, name, number, type)
            elseif subType == "message" then
                HandleMessageNestType(main_table, field_type, name, type, option)
            end
        end
    end

    return main_table
end 

local dataType
for name in pb.types() do
    type_table[name] = name
    if name == "."..messageName then
        dataType = name
    end
end

if dataType == nil 
then
    return "MessageNameError"
end

MakeMessageTable(dataType, data)

-- encode lua table data into binary format in lua string and return
local bytes = assert(pb.encode(messageName, data))
print(pb.tohex(bytes))

-- and decode the binary data back into lua table
local data2 = assert(pb.decode(messageName, bytes))
print(require "serpent".block(data2))

local tmp = pack:pack({length = 20, type_flag = 1, reflect_flag = 0, reserve_flag = 0, extend_flag = 2})
print(pb.tohex(tmp))

local tmp_table = pack:unpack(tmp)
print(require "serpent".block(tmp_table))


return bytes