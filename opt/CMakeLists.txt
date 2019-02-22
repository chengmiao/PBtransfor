project(lua)

#----------- lua lib generate   -----------
if(CMAKE_SYSTEM_NAME MATCHES "Linux")
    set (CMAKE_CXX_FLAGS "-std=c++14 -ldl -lpthread")
    set (CMAKE_C_FLAGS "-fPIC -Wl -E -ldl -lreadline")
    add_definitions(-DLUA_USE_LINUX)    
endif()

file(GLOB ALL_SRC ${CMAKE_CURRENT_SOURCE_DIR}/lua/*.c)	

SET(LIB_SRC ${ALL_SRC})
LIST(REMOVE_ITEM LIB_SRC lua.c luac.c)

ADD_LIBRARY(lua ${LIB_SRC})


#----------- lua pb.so generate -----------
add_library(pb SHARED ${CMAKE_CURRENT_SOURCE_DIR}/lua-protobuf/pb.c)