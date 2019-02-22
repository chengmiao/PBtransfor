project(lua)

#----------- lua lib generate   -----------
if(CMAKE_SYSTEM_NAME MATCHES "Linux")
    set(LUA_USE_LINUX TRUE)
	set(COMMON_CFLAGS "${COMMON_CFLAGS} -DLUA_USE_LINUX")
    set(COMMON_LDFLAGS "${COMMON_LDFLAGS} -Wl,-E -ldl -lreadline -lhistory -lncurses")
    message("Linux chengmiao")
endif()

if(CMAKE_SYSTEM_NAME MATCHES "Windows")
    set(LUA_WIN TRUE)
    set(COMMON_CFLAGS "${COMMON_CFLAGS} -DLUA_BUILD_AS_DLL")
endif()


file(GLOB ALL_SRC ${CMAKE_CURRENT_SOURCE_DIR}/lua/*.c)	

SET(LIB_SRC ${ALL_SRC})
LIST(REMOVE_ITEM LIB_SRC lua.c luac.c)

ADD_LIBRARY(lua ${LIB_SRC})


#----------- lua pb.so generate -----------
add_library(pb SHARED ${CMAKE_CURRENT_SOURCE_DIR}/lua-protobuf/pb.c)
add_dependencies(pb lua)