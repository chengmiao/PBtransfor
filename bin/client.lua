local endcode_data = dofile("transpb.lua")

if endcode_data == "ProtoFileError"
then
    print("Error : Cant Find Input Proto File! Please Input Again")
    return
end

if endcode_data == "MessageNameError"
then
    print("Error : Cant Find Input Message! Please Input Again")
    return
end

return endcode_data