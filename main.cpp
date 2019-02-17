#include <iostream>

#include "TransPBClient.h"

int main(int argc, char* argv[])
{
    if (argc != 3)
    {
        std::cerr << "Usage: " << argv[0] << " <ip>" << "<port>" << std::endl;
        return 1;
    }

    std::cout << "=============TransPB Start==============" << std::endl;

    TransPBClient client;
    client.connect(argv[1], static_cast<uint16_t>(std::atoi(argv[2])))
  
    return 0;
}