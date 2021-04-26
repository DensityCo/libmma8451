cmake_minimum_required(VERSION 3.7.2)
project(libtailgate_avigilon)

# Find includes in the build directories
#set(CMAKE_INCLUDE_CURRENT_DIR ON)

include_directories ("${PROJECT_SOURCE_DIR}/")
link_directories(BEFORE ${CMAKE_PREFIX_PATH}/lib)
include_directories(BEFORE ${CMAKE_PREFIX_PATH}/include)
ADD_DEFINITIONS ( -DPQXX_HIDE_EXP_OPTIONAL )
set(CMAKE_BUILD_TYPE Debug)

if(APPLE)
set(CMAKE_CXX_FLAGS_RELEASE "-std=c++11 -O0")
set(CMAKE_CXX_FLAGS_DEBUG "-std=c++11 -O0 -g")
else(APPLE)
	#set(CMAKE_CXX_FLAGS_RELEASE "-std=c++11 -O0")
set(CMAKE_CXX_FLAGS_RELEASE "-std=c++11 -O0 -ggdb -g3")
set(CMAKE_CXX_FLAGS_DEBUG "-std=c++11 -O0 -ggdb -g3")
endif(APPLE)
find_package(ZLIB REQUIRED)

if(CMAKE_SYSTEM_NAME STREQUAL "Linux" OR CMAKE_SYSTEM_NAME STREQUAL "Darwin")
  add_definitions(-std=c++11)
endif()

add_library(tailgate_avigilon SHARED tailgate_avigilon_parser.cpp avigilonclient.cpp)

#target_link_libraries(tailgate placeholder)
install(TARGETS tailgate_avigilon DESTINATION lib)
install(FILES tailgate_avigilon_parser.h DESTINATION include)
install(FILES avigilonclient.h DESTINATION include)
