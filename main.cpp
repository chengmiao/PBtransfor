#include <iostream>
#include <cstring>
#include "sol.hpp"

#include "TransPBClient.h"

int main(int argc, char* argv[])
{
    try
    {
        if (argc != 3)
        {
            std::cerr << "Usage: " << argv[0] << " <ip>" << "<port>" << std::endl;
            return 1;
        }

        TransPBClient client;
        client.connect(argv[1], static_cast<uint16_t>(std::atoi(argv[2])));

        //std::cout << "============== Use Lua Start =================" << std::endl;
        sol::state lua;
        lua.open_libraries();

        while (true)
        {
            std::cout << "===============TransPB Start================" << std::endl;
            std::cout << "Enter Proto File Name :" << std::endl;
            char proto_file_name[1024];
            std::cin.getline(proto_file_name, 1024);
            uint32_t file_length = std::strlen(proto_file_name);
            
            std::cout << "Enter Message Type Name :" << std::endl;
            char message_type_name[1024];
            std::cin.getline(message_type_name, 1024);
            uint32_t type_length = std::strlen(message_type_name);

            lua["filename"] = proto_file_name;
            lua["messageName"] = message_type_name;

            lua["TypeFieldFunc"] = [&lua](std::string message, std::string name, std::string number, std::string type, std::string option ){
                std::cout << "Enter Type Value" << std::endl;

                std::cout << "Message       :" << "    " << message << std::endl;
                std::cout << "FieldName     :" << "    " << name << std::endl;
                std::cout << "FieldIndex    :" << "    " << number << std::endl;
                std::cout << "FieldBaseType :" << "    " << type << std::endl;
                std::cout << "FieldOption   :" << "    " << option << std::endl;

                char type_value[1024];
                std::cin.getline(type_value, 1024);
                uint32_t length = std::strlen(type_value);
                lua["TypeValue"] = type_value;
            };

            lua["FieldRepeatNumFunc"] = [&lua](std::string message, std::string name){
                std::cout << "Enter Repeated Nums :" << "Message->" << message << "    " << "FieldName->" << name << std::endl;

                char type_value[1024];
                std::cin.getline(type_value, 1024);
                uint32_t length = std::strlen(type_value);
                lua["RepeatedNums"] = type_value;
            };

            lua["ChooseEnumFunc"] = [&lua](std::string enum_name, std::string type, std::string index, std::string name){
                std::cout << "Choose Enum Value :" << "Enum Type->" << type << "    " << "Enum Value->" << enum_name << std::endl;
                std::cout << "Name    :" << "    " << name << std::endl;
                std::cout << "Index   :" << "    " << index << std::endl;

                char type_value[1024];
                std::cin.getline(type_value, 1024);
                uint32_t length = std::strlen(type_value);
                lua["EnumValue"] = type_value;
            };

            std::string encode_data = lua.script_file("transpb.lua");
            std::cout << "Encode Data Num :" << std::to_string(encode_data.length()) << std::endl;

            std::cout << "===============TransPB End!!================" << std::endl;
            std::cout << "////////////////////////////////////////////" << std::endl;

            auto data = client.build_packet(encode_data);
            if (data == nullptr)
            {
                std::cout << "Encode Data Error!" << std::endl;
                continue;
            }

            client.send(data->c_str(), data->length());
        }
    }
    catch (std::exception& e)
    {
        std::cerr << "Exception: " << e.what() << "\n";
    }
  
    return 0;
}