#include "tcpclient.h"

#pragma pack(push, 1)
struct NetHead
{
	uint32_t len:24;		//这个长度是指报文体的长度，没有包括报文头的长度
	uint32_t flag:8;
};
#pragma pack(pop)

const size_t NET_HEAD_SIZE = sizeof(NetHead);

#define MAX_PACKET_LEN (2 * 1024)

class TransPBClient : public TcpClient
{
public:
    virtual int on_recv(const char * pData, uint32_t len);
    virtual std::shared_ptr<std::string> build_packet(std::string encode_message);
    
private:
};