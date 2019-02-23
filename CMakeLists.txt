set (CMAKE_CXX_COMPILER /usr/local/bin/g++)
set (CMAKE_C_COMPILER /usr/bin/gcc)


cmake_minimum_required(VERSION 2.8)
project(PBclient)

set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${PROJECT_SOURCE_DIR}/lib)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${PROJECT_SOURCE_DIR}/lib)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${PROJECT_SOURCE_DIR}/build)

if(CMAKE_SYSTEM_NAME MATCHES "Linux")
    set (CMAKE_CXX_FLAGS "-std=c++14 -ldl -lpthread")
    set (CMAKE_C_FLAGS "-fPIC")    
endif()

if(CMAKE_SYSTEM_NAME MATCHES "Windows")
endif()


include_directories(
    ${CMAKE_SOURCE_DIR}/opt/lua
    ${CMAKE_SOURCE_DIR}/opt/sol2
    ${CMAKE_SOURCE_DIR}/opt/lua-protobuf
)

link_directories(
    ${CMAKE_SOURCE_DIR}/lib
)

add_subdirectory(${CMAKE_SOURCE_DIR}/opt)
add_subdirectory(${CMAKE_SOURCE_DIR}/src)





