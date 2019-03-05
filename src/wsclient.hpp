#pragma once 

#include <iostream>
#include <functional>
#include <thread>

#include "logger.hpp"
#include "sol.hpp"
#include "uWS.h"

class WSClient
{
	public:
		WSClient(uWS::Hub* hub, sol::state* lua):client_lua(lua), client_hub(hub){}

		int connect(const char * pURI)
		{
			if (client_hub != nullptr)
			{
				m_recv_thread = std::thread(std::bind(&WSClient::run, this)); 
			}

			return 0;
		} 

		int send(const char * pData)
		{
			std::cout << "Connection Send." << std::endl;
			//if (client_hub != nullptr && ws != nullptr && is_connected)
			//{
				ws->send(pData);
			//}

			return 0;
		}

		void on_recv(uWS::WebSocket<uWS::CLIENT> *ws, char *message, size_t len, uWS::OpCode opCode)
		{
			std::cout << std::string(message, len) << std::endl;
			//send("World");
		}

		bool is_connected = false; 
	private:
		void run()
		{
			uWS::Hub client;

			client.onConnection([&](uWS::WebSocket<uWS::CLIENT> *ws, uWS::HttpRequest req) {
					std::cout << "Connection started." << std::endl;
					this->ws = ws;
					//ws->send("Hello");
					this->is_connected = true;
	    		});

			client.connect("wss://echo.websocket.org", nullptr);

			std::function<void(uWS::WebSocket<uWS::CLIENT> *, char *, size_t , uWS::OpCode)> f = std::bind(&WSClient::on_recv, this, std::placeholders::_1, std::placeholders::_2, std::placeholders::_3, std::placeholders::_4);
			client.onMessage(f);

			//client.onMessage([&client](uWS::WebSocket<uWS::CLIENT> *ws, char *message, size_t len, uWS::OpCode opCode) {
				//std::cout << "OnRecvWS" << std::endl;
				//std::cout << std::string(message, len) << std::endl;
			//});

			client.run();
		}


	private:
		
		sol::state* client_lua;
        uWS::Hub* client_hub;
		uWS::WebSocket<uWS::CLIENT>* ws;
		std::thread m_recv_thread;
}; 
