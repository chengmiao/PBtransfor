proto = {}


proto.MsgHead = { -- number is present bits
    length       = 24,
    type_flag    = 1,
    control_flag = 2,
    magic_flag   = 1,
    reflect_flag = 1,
    reserve_flag = 2,
    extend_flag  = 1,
}

function proto:pack(MsgHeadTable)
    for key, _ in pairs(self.MsgHead) do
        MsgHeadTable[key] = MsgHeadTable[key] == nil and 0 or MsgHeadTable[key]
    end

    local head_str = string.pack("<I3", MsgHeadTable["length"])

    local value = (MsgHeadTable["type_flag"] << 7)
    value = value | (MsgHeadTable["control_flag"] << 6 >> 1)
    value = value | (MsgHeadTable["magic_flag"] << 7 >> 3)
    value = value | (MsgHeadTable["reflect_flag"] << 7 >> 4)
    value = value | (MsgHeadTable["reserve_flag"] << 6 >> 5)
    value = value | (MsgHeadTable["extend_flag"] << 7 >> 7)

    head_str = head_str .. string.pack("<I1", value)

    return head_str
end

function proto:unpack(MsgHead)
    local MsgHeadTable = {}

    MsgHeadTable["length"]       = (string.unpack("<I3", MsgHead, 1))
    MsgHeadTable["type_flag"]    = (string.unpack("B", MsgHead, 4)) >> 7
    MsgHeadTable["control_flag"] = ((string.unpack("B", MsgHead, 4)) >> 5) & 3  
    MsgHeadTable["magic_flag"]   = ((string.unpack("B", MsgHead, 4)) >> 4) & 1
    MsgHeadTable["reflect_flag"] = ((string.unpack("B", MsgHead, 4)) >> 3) & 1
    MsgHeadTable["reserve_flag"] = ((string.unpack("B", MsgHead, 4)) >> 1) & 3 
    MsgHeadTable["extend_flag"]  = (string.unpack("B", MsgHead, 4)) & 1

    return MsgHeadTable
end

return proto