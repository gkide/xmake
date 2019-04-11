cmake_minimum_required(VERSION 2.8.12)
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

include_directories(${CMAKE_SOURCE_DIR})
include_directories(${CMAKE_BINARY_DIR})

add_executable(check ${SOURCES})
InstallHelper(TARGETS check)
InstallHelper(TARGETS check
    DESTINATION test)
# target_link_libraries(check m --verbose)

add_library(libA STATIC source/libA.c)
InstallHelper(TARGETS libA)
InstallHelper(FILES source/libA.h
    DESTINATION ${USR_INCDIR})

add_library(libB SHARED source/libB.c)
InstallHelper(TARGETS libB
    DESTINATION libB)
InstallHelper(FILES source/libB.h
    DESTINATION ${USR_INCDIR}/libB)

InstallHelper(FILES LICENSE
    DESTINATION ${USR_PREFIX})
InstallHelper(FILES docs/local.mk
    DESTINATION ${USR_DOCDIR})

InstallHelper(PROGRAMS scripts/release
    DESTINATION ${USR_PLGDIR})
InstallHelper(PROGRAMS scripts/release
    DESTINATION ${USR_PLGDIR}/scripts)

InstallHelper(DIRECTORY cmake
    DESTINATION ${USR_SHADIR})

include(BuildLibok)
add_dependencies(check libok)
