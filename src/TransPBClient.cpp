#include "TransPBClient.h"

#include <iostream>
#include <cstring>

int TransPBClient::on_recv(const char * pData, uint32_t len)
{
    std::cout.write(pData, len);
    std::cout << std::endl;
    std::cout << "Enter message" << std::endl;
    char request[1024];
    std::cin.getline(request, 1024);
    uint32_t request_length = std::strlen(request);
    send(request, request_length);
}

void TransPBClient::on_connected()
{
    std::cout << "Enter message" << std::endl;
    char request[1024];
    std::cin.getline(request, 1024);
    uint32_t request_length = std::strlen(request);
    send(request, request_length);
}

void TransPBClient::loop()
{
    m_recv_thread.join();
}