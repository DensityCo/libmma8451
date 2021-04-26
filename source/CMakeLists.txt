cmake_minimum_required(VERSION 3.10)
project(libmma8452)

include_directories ("${PROJECT_SOURCE_DIR}/")
link_directories(BEFORE ${CMAKE_PREFIX_PATH}/lib)
include_directories(BEFORE ${CMAKE_PREFIX_PATH}/include)
ADD_DEFINITIONS ( -DPQXX_HIDE_EXP_OPTIONAL )
set(CMAKE_BUILD_TYPE Debug)

set(CMAKE_CXX_FLAGS_RELEASE "-std=c++11 -O0")
set(CMAKE_CXX_FLAGS_DEBUG "-std=c++11 -O0 -g")

add_library(mma8452 SHARED mma8452.c)
add_executable(mma8452-test mma8452-test.c)

target_link_libraries(mma8452-test mma8452)
install(TARGETS mma8452 DESTINATION lib)
install(TARGETS mma8452-test DESTINATION bin)
install(FILES mma8452.h DESTINATION include)

