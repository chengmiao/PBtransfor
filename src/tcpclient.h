#pragma once 

//*********************//
//simple tcp client 
//created by: arthur 2019/1/10

#include <stdint.h>
#include "plat.h"
#include <fcntl.h>
#include <stdio.h>
#include <thread>
#include <vector>
#include "logger.hpp"
#include "sol.hpp"

#define MAX_RECV_BUF 2048

class TcpClient
{
	public:
		//TcpClient(sol::state* lua):client_lua(lua){}

		int connect(const char * pHost, uint16_t   port, bool reconnect  = true); 
		void disconnect(); 
		int send(const char * pData, uint32_t len); 

		virtual void on_connected() {
			dlog("on connected"); 
	   	}
		virtual void on_disconnect() {
			dlog("on disconnected"); 
	   	}

		virtual int read_packet(const char * pData , int dataLen) {
			return dataLen; 
		}

		virtual int on_recv(const char * pData, uint32_t len) ;

		bool isConnected(){
			return is_connected;
		} 
	private:
		void run(); 
		int do_connect(); 
		int do_recv(); 
		bool is_running = false; 
		bool is_connected = false; 
		std::thread m_recv_thread; 
		int fd = -1; 
		char recv_buf[MAX_RECV_BUF]; 
		uint32_t recv_buf_pos = 0; 
		std::string m_host; 
		uint16_t m_port; 
		std::vector<unsigned long > m_hosts; 
		uint32_t host_index = 0 ; 

		bool is_reconnect = false;
		static bool is_init;

		//sol::state* client_lua;
}; 
