package.path = ';/root/transClient/opt/lua-protobuf/?.lua'
package.cpath = ';/root/transClient/lib/?.so'


local pb = require "pb"
local protoc = require "protoc"


protoc.paths[#protoc.paths + 1] = "/root/transClient/proto"
protoc.include_imports = true
protoc:loadfile(filename)
pb.option("enum_as_value")

local randomData = {
    bool     = function(str) return str == "true" end,
    string   = function(str) return tostring(str) end,
    bytes    = function(str) return tostring(str) end,
    other    = function(str) return tonumber(str) end
}

local data = {}
local type_table = {}

function MakeMessageTable(field_type, main_table) 
    for name, number, type, value, option in pb.fields(field_type) do
        if type_table[type] == nil then
            local repeat_num = 1
            if option == "repeated" then
                FieldRepeatNumFunc(field_type, name)
                repeat_num = tonumber(RepeatedNums)
            end 

            if repeat_num > 1 then
                main_table[name] = {}
                for i=1, repeat_num do
                    TypeFieldFunc(field_type, name, tostring(number), type, option)

                    local func
                    if randomData[type] ~= nil then
                        func = randomData[type]
                    else
                        func = randomData["other"]
                    end
                    main_table[name][i] = func(TypeValue)
                end
            else
                local func
                if randomData[type] ~= nil then
                    func = randomData[type]
                else
                    func = randomData["other"]
                end

                TypeFieldFunc(field_type, name, tostring(number), type, option)
                main_table[name] = func(TypeValue)
            end
        else 
            local _, _, subType = pb.type(type)
            if subType == "enum" then
                main_table[name] = pb.enum(type, 1)
            elseif subType == "message" then
                local repeat_num = 1
                if option == "repeated" then
                    FieldRepeatNumFunc(field_type, name)
                    repeat_num = tonumber(RepeatedNums)
                end 

                main_table[name] = {}
                for i=1, repeat_num do
                    main_table[name][i] = MakeMessageTable(type, {})
                end
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

MakeMessageTable(dataType, data)

-- encode lua table data into binary format in lua string and return
local bytes = assert(pb.encode(messageName, data))
print(pb.tohex(bytes))

-- and decode the binary data back into lua table
local data2 = assert(pb.decode(messageName, bytes))
print(require "serpent".block(data2))