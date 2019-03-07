set (CMAKE_CXX_COMPILER /usr/local/bin/g++)
set (CMAKE_C_COMPILER /usr/bin/gcc)


cmake_minimum_required(VERSION 2.8)
project(PBclient)

if(CMAKE_SYSTEM_NAME MATCHES "Linux")
    set (CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++14 -ldl -lpthread -fPIC -O3")
    set (CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -fPIC")
    set(LUA_LIB liblua.a) 
    add_definitions(-D_GLIBCXX_USE_CXX11_ABI=1)
endif()


if(CMAKE_SYSTEM_NAME MATCHES "Windows")
    set(CMAKE_CXX_FLAGS_RELEASE "/MT")
    set(CMAKE_CXX_FLAGS_DEBUG "/MTd")
    SET(CMAKE_BUILD_TYPE "Release")
    set(LUA_LIB lua.lib)
endif()

#add_definitions(-DUSE_ASIO -DASIO_STANDALONE)
add_definitions(-DUSE_LIBUV)

include_directories(
    ${CMAKE_SOURCE_DIR}/opt/lua
    ${CMAKE_SOURCE_DIR}/opt/sol2
    ${CMAKE_SOURCE_DIR}/opt/lua-protobuf
    ${CMAKE_SOURCE_DIR}/opt/zlib
    ${CMAKE_SOURCE_DIR}/opt/uwebsocket/uWebSockets-0.14.8/src
    ${CMAKE_SOURCE_DIR}/opt/openssl/openssl
    ${CMAKE_SOURCE_DIR}/opt/asio/asio-boost-1.65.1/include
    ${CMAKE_SOURCE_DIR}/opt/libuv/include
    ${CMAKE_SOURCE_DIR}/build/openssl/include
    ${CMAKE_SOURCE_DIR}/opt/openssl/openssl-configs/ia32
    ${CMAKE_SOURCE_DIR}/build/opt/zlib
)

link_directories(
    ${CMAKE_SOURCE_DIR}/lib
)

add_subdirectory(${CMAKE_SOURCE_DIR}/opt)
add_subdirectory(${CMAKE_SOURCE_DIR}/src)





