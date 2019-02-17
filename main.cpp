#include <iostream>

#include "TransPBClient.h"

int main(int argc, char* argv[])
{
    try
    {
        if (argc != 3)
        {
            std::cerr << "Usage: " << argv[0] << " <ip>" << "<port>" << std::endl;
            return 1;
        }

        std::cout << "=============TransPB Start==============" << std::endl;

        TransPBClient client;
        client.connect(argv[1], static_cast<uint16_t>(std::atoi(argv[2])));

        client.loop();
    }
    catch (std::exception& e)
    {
        std::cerr << "Exception: " << e.what() << "\n";
    }
  
    return 0;
}