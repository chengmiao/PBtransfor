local data = "0080chengmiao@lindadfdfdfdfdfdfddf"

local head_len = string.byte(data, 1, 3)
print(tonumber(head_len))