#include <iostream>
#include <cstring>
#include "sol.hpp"

#include "TransPBClient.h"

void get_input_value(sol::state& lua, std::string lua_value_name)
{
    char type_value[1024];
    std::cin.getline(type_value, 1024);
    lua[lua_value_name] = type_value;
}

void register_lua_func(sol::state& lua)
{
    lua["TypeFieldFunc"] = [&lua](std::string message, std::string name, std::string number, std::string type, std::string option ){
        std::cout << "Enter Type Value" << std::endl;

        std::cout << "Message       :" << "    " << message << std::endl;
        std::cout << "FieldName     :" << "    " << name << std::endl;
        std::cout << "FieldIndex    :" << "    " << number << std::endl;
        std::cout << "FieldBaseType :" << "    " << type << std::endl;
        std::cout << "FieldOption   :" << "    " << option << std::endl;

        get_input_value(lua, "TypeValue");
    };

    lua["FieldRepeatNumFunc"] = [&lua](std::string message, std::string name){
        std::cout << "Enter Repeated Nums :" << "Message->" << message << "    " << "FieldName->" << name << std::endl;

        get_input_value(lua, "RepeatedNums");
    };

    lua["ChooseEnumFunc"] = [&lua](std::string enum_name, std::string type, std::string index, std::string name){
        std::cout << "Choose Enum Value :" << "Enum Type->" << type << "    " << "Enum Value->" << enum_name << std::endl;
        std::cout << "Name    :" << "    " << name << std::endl;
        std::cout << "Index   :" << "    " << index << std::endl;

        get_input_value(lua, "EnumValue");
    };
}

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

        register_lua_func(lua);

        while (true)
        {
            std::cout << "===============TransPB Start================" << std::endl;
            std::cout << "Enter Proto File Name :" << std::endl;
            get_input_value(lua, "filename");
            
            std::cout << "Enter Message Type Name :" << std::endl;
            get_input_value(lua, "messageName");

            std::string encode_data = lua.script_file("client.lua");
            if (encode_data.empty())
            {
                continue;
            }

            std::cout << "===============TransPB End!!================" << std::endl;
            std::cout << "////////////////////////////////////////////" << std::endl;

            client.send(encode_data.c_str(), encode_data.length());
        }
    }
    catch (std::exception& e)
    {
        std::cerr << "Exception: " << e.what() << "\n";
    }

	system("pause");
  
    return 0;
}