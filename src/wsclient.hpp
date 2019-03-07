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
		//WSClient(sol::state* lua):client_lua(lua){}

		int connect(const char * pURI)
		{
			m_recv_thread = std::thread(std::bind(&WSClient::run, this, std::string(pURI))); 
			return 0;
		} 

		int send(const char * pData, uint32_t len)
		{
			std::cout << "Connection Send." << std::endl;
			if (ws != nullptr && is_connected)
			{
				ws->send(pData, uWS::OpCode::BINARY);
			}

			return 0;
		}

		void on_recv(const char * pData, uint32_t len)
		{
			//if (client_lua != nullptr)
			//{
				//std::string data(pData, len);
				//(*client_lua)["on_lua_recv"](data, len);
			//}
		}

		bool isConnected()
		{
			return is_connected;
		}

	private:
		void run(std::string strURI)
		{
			uWS::Hub client;

			client.onConnection([&](uWS::WebSocket<uWS::CLIENT> *ws, uWS::HttpRequest req) {
				std::cout << "Connection started." << std::endl;
				this->ws = ws;
				//ws->send("Hello");
				this->is_connected = true;
	    	});

			client.onMessage([&](uWS::WebSocket<uWS::CLIENT> *ws, char *message, size_t len, uWS::OpCode opCode) {
				std::cout << "OnRecvWS" << std::endl;
				this->on_recv(message, len);
			});

			//client.connect("wss://echo.websocket.org", nullptr);
			client.connect(strURI.c_str(), nullptr);
			client.run();
		}


	private:
		bool is_connected = false;
		//sol::state* client_lua;
		uWS::WebSocket<uWS::CLIENT>* ws;
		std::thread m_recv_thread;
}; 
