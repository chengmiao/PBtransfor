
//#include "logger.hpp"
#include "tcpclient.h"
#include <netdb.h>
#include <functional>

int TcpClient::do_connect()
{
	static int try_period = 1; 
	sleep(try_period ); 
	if (fd != -1)
	{
		::close(fd); 
		fd = -1; 
	}

	fd = socket(AF_INET , SOCK_STREAM, 0); 
	if (-1 == fd)
	{
		//elog("open socket failed"); 
		return -1; 
	}

	struct sockaddr_in addr;
	addr.sin_family = AF_INET;
	//addr.sin_addr.s_addr = inet_addr(m_host.c_str());
	addr.sin_addr.s_addr = m_hosts[0]; 
	addr.sin_port = htons(m_port);
	if (-1 == ::connect(fd, (sockaddr*)&addr, sizeof(addr)))
	{
		//dlog("failed to connect server error %s:%d",inet_ntoa(addr.sin_addr),m_port);
		::close(fd); 
		return -1;
	}
	is_connected = true; 
	this->on_connected(); 
	return 0; 
}

int TcpClient::connect (const char * pHost, uint16_t port, bool reconnect  )
{
	//dlog("try to connecto to %s ,port %d",pHost, port); 
	m_port =  port; 
	m_host = pHost; 
	struct hostent *hp = gethostbyname(m_host.c_str());
	if(hp != NULL)  {
		//dlog("host name %s : ", hp->h_name);
		unsigned int i = 0;
		while ( hp -> h_addr_list[i] != NULL) {
			//dlog ( "address : %s ", inet_ntoa( *( struct in_addr*)( hp -> h_addr_list[i])));
			m_hosts.push_back( ((struct in_addr*) hp->h_addr_list[0])->s_addr); 
			i++;
		}
	}
	else {
		//elog("gethostbyname() failed");
		return -1; 
	}


	if (!is_running)
	{
		is_running  = true; 
		int ret = do_connect(); 
		m_recv_thread = std::thread(std::bind(&TcpClient::run, this)); 
		return ret; 
	}
	return 0; 
}

int TcpClient::send(const char * pData, uint32_t len)
{
	if (is_connected)
	{
		int ret = ::send(fd, pData, len,0); 
		if (ret <=  0)
		{
			this->on_disconnect(); 
			this->disconnect(); 
			return -1; 
		}
		return ret; 
	}
	return -1; 
}
int TcpClient::on_recv(const char * pData, uint32_t len) {
	//ilog("received data%s" , pData); 
	return 0;
}

void TcpClient::disconnect()
{
	::close(fd); 
	is_connected = false; 
	m_recv_thread.join(); 
}
int TcpClient::do_recv()
{
	int recvLen = ::recv(fd, recv_buf + recv_buf_pos , sizeof(recv_buf) - recv_buf_pos , 0);
	if (recvLen <= 0)
	{
		is_connected =false; 
		this->on_disconnect(); 
		return  -1; 
	}
	recv_buf_pos += recvLen; 
	uint32_t readPos = 0;
	int pkgLen = read_packet(recv_buf,recv_buf_pos);
	//dlog("package length:  is %d\n",pkgLen);
	while (pkgLen >0 )
	{
		if (readPos + pkgLen <= recv_buf_pos )
		{
			// char * pEnd = (char*)(recv_buf)+readPos+ pkgLen;
			// char endVal = *pEnd;
			// *pEnd=0;
			on_recv((char*)(recv_buf)+readPos, pkgLen);
			// *pEnd=endVal;
			readPos += pkgLen;
		}
		if (readPos  < recv_buf_pos)
		{
			pkgLen = read_packet(recv_buf + readPos, recv_buf_pos - readPos);
			if (pkgLen <=0)
			{
				memmove(recv_buf,(char*)recv_buf + readPos, recv_buf_pos - readPos);
				recv_buf_pos -= readPos;
				*(recv_buf +recv_buf_pos )=0;
				break;
			}
		}
		else
		{
			recv_buf_pos = 0;
			break;
		}
	}
	return 0; 
}

void TcpClient::run()
{
	while(is_running)
	{
		fd_set read_fds;
		fd_set write_fds;
		fd_set except_fds;

		FD_ZERO(&read_fds);
		FD_ZERO(&write_fds);
		FD_ZERO(&except_fds);
		if (fd != -1 && is_connected)
		{
			FD_SET(fd,&read_fds); 
			FD_SET(fd,&except_fds); 
		}

		struct timeval tv;
		tv.tv_sec = 5;
		tv.tv_usec = 0;
		//dlog(" fd is %d",fd); 
		int ret = select(fd+1, &read_fds, NULL, &except_fds, &tv);
		if (ret == -1)
		{
			//elog("select error remove %d  from sets", fd);
			sleep(1); 
		} else if (ret)
		{
			if(FD_ISSET(fd, &read_fds))
			{
				do_recv(); 
			}
			if (FD_ISSET(fd,&except_fds))
			{
				//dlog("socket error , close connection"); 
				FD_CLR(fd,&read_fds); 
				FD_CLR(fd,&except_fds); 
				on_disconnect(); 
			}
		}
		else
		{
			//dlog("select timeout"); 
			if (!is_connected)
			{
				do_connect(); 
			}
		}
	}
}

