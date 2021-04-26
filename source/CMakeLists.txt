cmake_minimum_required(VERSION 3.10)
project(libmma8451)

include_directories ("${PROJECT_SOURCE_DIR}/")
link_directories(BEFORE ${CMAKE_PREFIX_PATH}/lib)
include_directories(BEFORE ${CMAKE_PREFIX_PATH}/include)
ADD_DEFINITIONS ( -DPQXX_HIDE_EXP_OPTIONAL )
set(CMAKE_BUILD_TYPE Debug)

set(CMAKE_CXX_FLAGS_RELEASE "-std=c++11 -O0")
set(CMAKE_CXX_FLAGS_DEBUG "-std=c++11 -O0 -g")

add_library(mma8451 SHARED mma8451.c)
add_executable(mma8451-test mma8451-test.c)

target_link_libraries(mma8451-test mma8451)
install(TARGETS mma8451 DESTINATION lib)
install(TARGETS mma8451-test DESTINATION bin)
install(FILES mma8451.h DESTINATION include)

