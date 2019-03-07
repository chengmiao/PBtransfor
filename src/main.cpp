#include <iostream>
#include <cstring>

#include "sol.hpp"
#include "tcpclient.h"

#include "wsclient.hpp"


int main(int argc, char* argv[])
{
    try
    {
    
        sol::state lua;
        lua.open_libraries();

        lua["lua"] = &lua;

        lua.new_usertype<TcpClient>( "client",
            sol::constructors<TcpClient(sol::state*)>(),
             //typical member function
            "connect", &TcpClient::connect,
            "send", &TcpClient::send,
            "isConnected", &TcpClient::isConnected
        );

        lua.new_usertype<WSClient>( "wsclient",
            sol::constructors<WSClient(sol::state*)>(),
             //typical member function
            "connect", &WSClient::connect,
            "send", &WSClient::send,
            "isConnected", &WSClient::isConnected
        );

        lua.script_file("client.lua");

        while (true)
        {
            lua.script_file("../loop.lua");
        }
        

    /*
        uWS::Hub h;

	    h.onConnection([&h](uWS::WebSocket<uWS::CLIENT> *ws, uWS::HttpRequest req) {
			char message[] = "hello";
			std::cout << "Client send: " << message << std::endl;
			ws->send(message);
			//h.getDefaultGroup<uWS::CLIENT>().close();
	    });

		h.onMessage([&h](uWS::WebSocket<uWS::CLIENT> *ws, char *message, size_t len, uWS::OpCode opCode) {
			std::cout << "OnRecvWS" << std::endl;
			std::cout << std::string(message, len) << std::endl;
		});

	    std::cout << "Connection started." << std::endl;

	    h.connect("wss://echo.websocket.org", nullptr);
	    h.run();

	    std::cout << "Connection terminated." << std::endl;
    */

        //sol::state lua;

        //WSClient client(&lua);
        //client.connect("wss://echo.websocket.org");
		//std::cout << "Connection terminated." << std::endl;
        //while(true)
        //{
            //Sleep(1);
        //}
    }
    catch (std::exception& e)
    {
        std::cerr << "Exception: " << e.what() << "\n";
    }

	system("pause");
  
    return 0;
}