set (CMAKE_CXX_COMPILER /usr/local/bin/g++)
set (CMAKE_C_COMPILER /usr/bin/gcc)

project(uWS)

file(GLOB ALL_SRC ${CMAKE_CURRENT_SOURCE_DIR}/uWebSockets-0.14.8/src/*.*)	

SET(LIB_SRC ${ALL_SRC})

#add_definitions(-D__cplusplus)
add_definitions(-D_GLIBCXX_USE_CXX11_ABI=1)

if(CMAKE_SYSTEM_NAME MATCHES "Linux")
    set (CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++14 -ldl -lpthread -fPIC -O3")   
endif()

add_library(uWS SHARED ${LIB_SRC})
target_link_libraries(uWS zlib openssl uv)
add_dependencies(uWS zlib openssl uv)


