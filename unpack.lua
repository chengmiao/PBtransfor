local data = "0080chengmiao@lindadfdfdfdfdfdfddf"

local head1, head2, head3 = string.byte(data, 1, 3)
print(string.byte(data, 1, 3))
return tonumber(head1..head2..head3)