project(lua)

#----------- lua lib generate   -----------
file(GLOB ALL_SRC ${CMAKE_CURRENT_SOURCE_DIR}/lua/*.c)	

SET(LIB_SRC ${ALL_SRC})
LIST(REMOVE_ITEM LIB_SRC lua.c luac.c)

ADD_LIBRARY(lua ${LIB_SRC})


#----------- lua pb.so generate -----------
add_library(pb SHARED ${CMAKE_CURRENT_SOURCE_DIR}/lua-protobuf/pb.c)