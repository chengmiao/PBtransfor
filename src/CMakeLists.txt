project(main)

set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_DEBUG ${CMAKE_CURRENT_SOURCE_DIR}/../bin)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_RELEASE ${CMAKE_CURRENT_SOURCE_DIR}/../bin)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/../bin)

if(CMAKE_SYSTEM_NAME MATCHES "Linux")
    set (CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++14 -ldl -lpthread -fPIC -O3")
    add_definitions(-D_GLIBCXX_USE_CXX11_ABI=1)   
endif()


file(GLOB CLIENT_SRCS ${CMAKE_SOURCE_DIR}/src/*.cpp)	
file(GLOB CLIENT_HDRS ${CMAKE_SOURCE_DIR}/src/*.h ${CMAKE_SOURCE_DIR}/src/*.hpp)

add_executable(PBclient main.cpp ${CLIENT_HDRS} ${CLIENT_SRCS})
target_link_libraries(PBclient ${LUA_LIB} uWS)
add_dependencies(PBclient lua uWS)