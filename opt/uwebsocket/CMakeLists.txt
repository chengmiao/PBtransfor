project(uWS)

file(GLOB ALL_SRC ${CMAKE_CURRENT_SOURCE_DIR}/uWebSockets-0.14.8/src/*.*)	

SET(LIB_SRC ${ALL_SRC})


add_library(uWS SHARED ${LIB_SRC})
target_link_libraries(uWS zlib openssl uv)
add_dependencies(uWS zlib openssl uv)
