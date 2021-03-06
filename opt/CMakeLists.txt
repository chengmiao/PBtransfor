set (CMAKE_CXX_COMPILER /usr/local/bin/g++)
set (CMAKE_C_COMPILER /usr/bin/gcc)


project(lua)

set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY_DEBUG ${CMAKE_CURRENT_SOURCE_DIR}/../lib)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY_DEBUG ${CMAKE_CURRENT_SOURCE_DIR}/../lib)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_DEBUG ${CMAKE_CURRENT_SOURCE_DIR}/../bin)

set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY_RELEASE ${CMAKE_CURRENT_SOURCE_DIR}/../lib)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY_RELEASE ${CMAKE_CURRENT_SOURCE_DIR}/../lib)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_RELEASE ${CMAKE_CURRENT_SOURCE_DIR}/../bin)

set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/../lib)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/../lib)

#----------- lua lib generate   -----------


if(CMAKE_SYSTEM_NAME MATCHES "Linux")
    set(LUA_USE_LINUX TRUE)
	set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -DLUA_USE_LINUX -DLUA_USE_MKSTEMP -Wl,-E -ldl -lreadline -lhistory -lncurses")
endif()

if(CMAKE_SYSTEM_NAME MATCHES "Windows")
    set(LUA_WIN TRUE)
    set(CMAKE_C_FLAGS "-DLUA_BUILD_AS_DLL /O2 /LD")
    set(CMAKE_C_FLAGS_RELEASE "/MT")
    set(CMAKE_C_FLAGS_DEBUG "/MTd")
endif()


file(GLOB ALL_SRC ${CMAKE_CURRENT_SOURCE_DIR}/lua/*.c)	

SET(LIB_SRC ${ALL_SRC})
LIST(REMOVE_ITEM LIB_SRC ${CMAKE_CURRENT_SOURCE_DIR}/lua/lua.c ${CMAKE_CURRENT_SOURCE_DIR}/lua/luac.c)

if(CMAKE_SYSTEM_NAME MATCHES "Linux")
    ADD_LIBRARY(lua ${LIB_SRC})

    #----------- lua pb.so generate -----------
    add_library(pb SHARED ${CMAKE_CURRENT_SOURCE_DIR}/lua-protobuf/pb.c)
    add_dependencies(pb lua)
endif()

if(CMAKE_SYSTEM_NAME MATCHES "Windows")
    ADD_LIBRARY(lua SHARED ${LIB_SRC})

    #----------- lua pb.so generate -----------
    add_library(pb SHARED ${CMAKE_CURRENT_SOURCE_DIR}/lua-protobuf/pb.c)
    target_link_libraries(pb ${LUA_LIB})
    add_dependencies(pb lua)
endif()

add_subdirectory(${CMAKE_CURRENT_SOURCE_DIR}/zlib)
add_subdirectory(${CMAKE_CURRENT_SOURCE_DIR}/openssl)
add_subdirectory(${CMAKE_CURRENT_SOURCE_DIR}/libuv)
add_subdirectory(${CMAKE_CURRENT_SOURCE_DIR}/uwebsocket)
