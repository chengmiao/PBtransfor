#include "TransPBClient.h"

#include <iostream>

int TransPBClient::on_recv(const char * pData, uint32_t len)
{
    std::cout.write(pData, len);
    std::cout << std::endl;
    return 0;
}
