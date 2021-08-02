cmake_minimum_required(VERSION 3.13)

project(Example)

set(CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/../cmake")
include(rc)

add_resource(res FILES CMakeLists.txt test.cpp=test_source)
add_library(test SHARED test.cpp)
target_link_libraries(test PRIVATE res)
add_executable(test_driver test_driver.cpp)
target_link_libraries(test_driver PRIVATE test)
