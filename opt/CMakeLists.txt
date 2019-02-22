project(lua)

#----------- lua lib generate   -----------
AUX_SOURCE_DIRECTORY(. ALL_SRC)

SET(LIB_SRC ${ALL_SRC})
LIST(REMOVE_ITEM LIB_SRC lua.c luac.c)

ADD_LIBRARY(lua ${LIB_SRC})



#----------- lua pb.so generate -----------
add_library(pb SHARED ${CMAKE_CURRENT_SOURCE_DIR}/opt/lua-protobuf/pb.c)