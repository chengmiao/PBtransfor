project(main)

file(GLOB CLIENT_SRCS ${CMAKE_SOURCE_DIR}/src/*.cpp)	
file(GLOB CLIENT_HDRS ${CMAKE_SOURCE_DIR}/src/*.h)

if(CMAKE_SYSTEM_NAME MATCHES "Linux")
    set(LUA_LIB liblua.a)
endif()

if(CMAKE_SYSTEM_NAME MATCHES "Windows")
    set(LUA_LIB lua.lib)
endif()

add_executable(PBclient main.cpp ${CLIENT_SRCS})
target_link_libraries(PBclient ${LUA_LIB})