#include <iostream>
#include <cstring>

#include "sol.hpp"
#include "tcpclient.h"


int main(int argc, char* argv[])
{
    try
    {
        sol::state lua;
        lua.open_libraries();

        lua["lua"] = &lua;

        lua.new_usertype<TcpClient>( "client",
            sol::constructors<TcpClient(sol::state*)>(),
            // typical member function
            "connect", &TcpClient::connect,
            "send", &TcpClient::send,
            "isConnected", &TcpClient::isConnected
        );

        lua.script_file("client.lua");
    }
    catch (std::exception& e)
    {
        std::cerr << "Exception: " << e.what() << "\n";
    }

	system("pause");
  
    return 0;
}