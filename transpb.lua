package.path = ';/root/dbserver/opt/lua-protobuf/?.lua'
package.cpath = ';/root/dbserver/lib/?.so'


local pb = require "pb"
local protoc = require "protoc"


protoc.paths[#protoc.paths + 1] = "/root/dbserver/proto"
protoc.include_imports = true
protoc:loadfile(filename)
pb.option("enum_as_value")

local randomData = {
    bool     = true,
    double   = 55.55,
    float    = 123.123,
    int32    = -64,
    uint32   = 64,
    int64    = -1245,
    uint64   = 1245,
    sint32   = -88,
    sint64   = -12456,
    fixed32  = 666,
    fixed64  = 6666,
    sfixed32 = 45,
    sfixed64 = 54,
    string   = "ChengMiao",
    bytes    = "X",
}

local data = {}
local type_table = {}

function MakeMessageTable(field_type, main_table) 
    for name, number, type, value, option in pb.fields(field_type) do
        if type_table[type] == nil then
            main_table[name] = randomData[type]
        else 
            local _, _, subType = pb.type(type)
            if subType == "enum" then
                main_table[name] = pb.enum(type, 1)
            elseif subType == "message" then
                main_table[name] = {}
                main_table[name][1] = MakeMessageTable(type, {})
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