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
		WSClient(sol::state* lua):client_lua(lua){}

		int connect(const char * pURI)
		{
			m_recv_thread = std::thread(std::bind(&WSClient::run, this)); 
			return 0;
		} 

		int send(const char * pData)
		{
			std::cout << "Connection Send." << std::endl;
			if (ws != nullptr && is_connected)
			{
				ws->send(pData);
				is_connected = false;
			}

			return 0;
		}

		void on_recv(uWS::WebSocket<uWS::CLIENT> *ws, char *message, size_t len, uWS::OpCode opCode)
		{
			std::cout << std::string(message, len) << std::endl;
		}

		bool isConnected(){
			return is_connected;
		} 

	private:
		void run(const char* pURI)
		{
			uWS::Hub client;

			client.onConnection([&](uWS::WebSocket<uWS::CLIENT> *ws, uWS::HttpRequest req) {
					std::cout << "Connection started." << std::endl;
					this->ws = ws;
					//ws->send("Hello");
					this->is_connected = true;
	    		});

			client.connect("wss://echo.websocket.org", nullptr);
			//client.connect(pURI, nullptr);

			std::function<void(uWS::WebSocket<uWS::CLIENT> *, char *, size_t , uWS::OpCode)> f = std::bind(&WSClient::on_recv, this, std::placeholders::_1, std::placeholders::_2, std::placeholders::_3, std::placeholders::_4);
			client.onMessage(f);

			client.run();
		}


	private:
		
		bool is_connected = false; 
		sol::state* client_lua;
		uWS::WebSocket<uWS::CLIENT>* ws;
		std::thread m_recv_thread;
}; 
