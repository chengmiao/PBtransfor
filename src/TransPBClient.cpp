#include "TransPBClient.h"

#include <iostream>
#include <string>

int TransPBClient::on_recv(const char * pData, uint32_t len)
{
    std::cout.write(pData, len);
    std::cout << std::endl;
    return 0;
}

std::shared_ptr<std::string> TransPBClient::build_packet(std::string encode_message)
{
    auto data = std::make_shared<std::string>();
    //const int MESSAGE_SIZE = encode_message.length();
    const int MESSAGE_SIZE = 0;

    if (NET_HEAD_SIZE + MESSAGE_SIZE > MAX_PACKET_LEN)
	{
		return nullptr;
	}

    data->resize(NET_HEAD_SIZE + MESSAGE_SIZE);
    if (MESSAGE_SIZE <= 0)
	{
		return nullptr;
	}

    data->insert(NET_HEAD_SIZE, encode_message);

    //NetHead *header = reinterpret_cast<NetHead*>(&data->at(0));
	//header->len = uint32_t(MESSAGE_SIZE);
	//header->flag = 0;

    return data;
}
