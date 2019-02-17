#include "tcpclient.h"

class TransPBClient : public TcpClient
{
public:
    virtual int on_recv(const char * pData, uint32_t len);

private:
};