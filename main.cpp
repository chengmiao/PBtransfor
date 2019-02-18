#include <iostream>
#include <cstring>
#include "sol.hpp"

#include "TransPBClient.h"

int main(int argc, char* argv[])
{
    try
    {
        //if (argc != 3)
        //{
            //std::cerr << "Usage: " << argv[0] << " <ip>" << "<port>" << std::endl;
            //return 1;
        //}

        //TransPBClient client;
        //client.connect(argv[1], static_cast<uint16_t>(std::atoi(argv[2])));

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

            lua["TypeFieldFunc"] = [&lua](std::string name, std::string number, std::string type, std::string value, std::string option ){
                std::cout << "Enter Type Value" << std::endl;
                std::cout << "Name :" << name << "Index :" << number << "Type :" << type << "Default Value :" << value << "Option :" << option << std::endl;
                char type_value[1024];
                std::cin.getline(type_value, 1024);
                uint32_t length = std::strlen(type_value);
                lua["TypeValue"] = type_value;
            };

            lua.script_file("transpb.lua");

            std::cout << "===============TransPB End!!================" << std::endl;
            std::cout << "////////////////////////////////////////////" << std::endl;

            //client.send(request, request_length);
        }
    }
    catch (std::exception& e)
    {
        std::cerr << "Exception: " << e.what() << "\n";
    }
  
    return 0;
}