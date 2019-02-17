#include "TransPBClient.h"

int TransPBClient::on_recv(const char * pData, uint32_t len)
{
    send(pData, len);
}