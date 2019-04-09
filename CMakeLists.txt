cmake_minimum_required(VERSION 2.8.11)
project(xbuild) # Replace 'xbuild' to the real name

set(XBUILD_VERSION_MAJOR 1)
set(XBUILD_VERSION_MINOR 0)
set(XBUILD_VERSION_PATCH 0)
set(XBUILD_VERSION_TWEAK "release")

option(XBUILD_EXPORT_AS_COMPILER_ARGS "" OFF)

# Cmake modules
list(APPEND CMAKE_MODULE_PATH "${PROJECT_SOURCE_DIR}/cmake")
include(xbuild)

add_compile_options(-Wall)
file(GLOB SOURCES source/*.c)

if(NOT XBUILD_EXPORT_AS_COMPILER_ARGS)
    configure_file(
        "${CMAKE_SOURCE_DIR}/source/config.h.in"
        "${CMAKE_BINARY_DIR}/config.generated.h")
    list(APPEND SOURCES
        "${CMAKE_BINARY_DIR}/config.generated.h")
    add_definitions(-DXBUILD_EXPORT_AS_CONFIG_FILE)
endif()

include_directories(${CMAKE_BINARY_DIR})
add_executable(check ${SOURCES})
# target_link_libraries(check m --verbose)

#include(BuildLibok)
#add_dependencies(check libok)
