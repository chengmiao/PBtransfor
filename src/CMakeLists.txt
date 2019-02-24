project(main)

file(GLOB CLIENT_SRCS ${CMAKE_SOURCE_DIR}/src/*.cpp)	
file(GLOB CLIENT_HDRS ${CMAKE_SOURCE_DIR}/src/*.h)


add_executable(PBclient main.cpp ${CLIENT_SRCS})
target_link_libraries(PBclient ${LUA_LIB})