cmake_minimum_required(VERSION 2.8)
project(PBclient)

set (CMAKE_CXX_COMPILER /usr/local/bin/g++)
set (CMAKE_C_COMPILER /usr/bin/gcc)
set (CMAKE_CXX_FLAGS "-std=c++14 -ldl -lpthread")
set (CMAKE_C_FLAGS "-fPIC")

include_directories(${CMAKE_SOURCE_DIR}/opt/lua ${CMAKE_SOURCE_DIR}/opt/sol2 ${CMAKE_SOURCE_DIR}/opt/lua-protobuf)
link_directories(${CMAKE_SOURCE_DIR}/lib)

file(GLOB CLIENT_SRCS ${CMAKE_SOURCE_DIR}/src/*.cpp)	
file(GLOB CLIENT_HDRS ${CMAKE_SOURCE_DIR}/src/*.h)

include_directories(${CMAKE_SOURCE_DIR}/src)
add_executable(PBclient main.cpp ${CLIENT_SRCS})
target_link_libraries(PBclient liblua.a)

add_library(pb SHARED ${CMAKE_SOURCE_DIR}/opt/lua-protobuf/pb.c)



