#pragma once 

//*********************//
//simple tcp client 
//created by: arthur 2019/1/10

#include <stdint.h>
//#include "plat.h"
#include <fcntl.h>
#include <unistd.h>
#include <stdio.h>
#include <thread>
#include <vector>
//#include "logger.hpp"

#define MAX_RECV_BUF 2048

class TcpClient
{
	public: 
		int connect(const char * pHost, uint16_t   port, bool reconnect  = true); 
		void disconnect(); 
		int send(const char * pData, uint32_t len); 

		virtual void on_connected() {
			//dlog("on connected"); 
	   	}
		virtual void on_disconnect() {
			//dlog("on disconnected"); 
	   	}

		virtual int read_packet(const char * pData , int dataLen) {
			return dataLen; 
		}

		virtual int on_recv(const char * pData, uint32_t len) ; 
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
}; 
