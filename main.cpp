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

        std::cout << "=============TransPB Start==============" << std::endl;

        //TransPBClient client;
        //client.connect(argv[1], static_cast<uint16_t>(std::atoi(argv[2])));

        std::cout << "============== Use Lua Start =================" << std::endl;
        sol::state lua;
        lua.open_libraries();

        lua["filename"] = argv[1];
        lua["messageName"] = argv[2];
        lua.script_file("Transfor.lua");

        std::cout << "Enter message" << std::endl;
        while (true)
        {
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
            lua.script_file("transpb.lua");

            //client.send(request, request_length);
        }
    }
    catch (std::exception& e)
    {
        std::cerr << "Exception: " << e.what() << "\n";
    }
  
    return 0;
}