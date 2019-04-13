cmake_minimum_required(VERSION 2.8.12)
string(TOUPPER ${PROJECT_NAME} XBUILD) # upper project name

string(APPEND ${XBUILD}_RELEASE_VERSION "v${${XBUILD}_VERSION_MAJOR}")
string(APPEND ${XBUILD}_RELEASE_VERSION ".${${XBUILD}_VERSION_MINOR}")
string(APPEND ${XBUILD}_RELEASE_VERSION ".${${XBUILD}_VERSION_PATCH}")

if(${XBUILD}_VERSION_TWEAK)
    string(APPEND ${XBUILD}_RELEASE_VERSION "-${${XBUILD}_VERSION_TWEAK}")
endif()

if(NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE "Debug")
endif()

# Enable verbose output from Makefile builds.
option(CMAKE_VERBOSE_MAKEFILE OFF)
# Output compile commands to compile_commands.json
option(CMAKE_EXPORT_COMPILE_COMMANDS OFF)

# Output for binary, static/shared libraries.
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
foreach(CFGNAME ${CMAKE_CONFIGURATION_TYPES})
    string(TOUPPER ${CFGNAME} CFGNAME)
    set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_${CFGNAME} ${CMAKE_BINARY_DIR}/bin)
    set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY_${CFGNAME} ${CMAKE_BINARY_DIR}/lib)
    set(CMAKE_LIBRARY_OUTPUT_DIRECTORY_${CFGNAME} ${CMAKE_BINARY_DIR}/lib)
endforeach()

# Change the default cmake value without overriding the user-provided one
if(CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT)
    set(CMAKE_INSTALL_PREFIX "${PROJECT_BINARY_DIR}/usr" CACHE PATH "" FORCE)
endif()

# Cmake modules
list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_LIST_DIR}/xbuild")
include(PreventInTreeBuilds)
include(CheckHostSystem)
include(GetGitRepoInfo)
include(InstallHelper)
include(Dependencies)
#include(PrintCmake)

if(XBUILD_EXPORT_AS_COMPILER_ARGS)
    add_definitions(-DHOST_NAME=\"${HOST_NAME}\")
    add_definitions(-DHOST_USER=\"${HOST_USER}\")
    add_definitions(-DHOST_ARCH=\"${HOST_ARCH}\")
    add_definitions(-DHOST_SYSTEM_NAME=\"${HOST_SYSTEM_NAME}\")
    add_definitions(-DHOST_SYSTEM_VERSION=\"${HOST_SYSTEM_VERSION}\")
    add_definitions(-DHOST_OS_DIST_NAME=\"${HOST_OS_DIST_NAME}\")
    add_definitions(-DHOST_OS_DIST_VERSION=\"${HOST_OS_DIST_VERSION}\")

    add_definitions(-D${XBUILD}_VERSION_MAJOR=${${XBUILD}_VERSION_MAJOR})
    add_definitions(-D${XBUILD}_VERSION_MINOR=${${XBUILD}_VERSION_MINOR})
    add_definitions(-D${XBUILD}_VERSION_PATCH=${${XBUILD}_VERSION_PATCH})
    add_definitions(-D${XBUILD}_VERSION_TWEAK=\"${${XBUILD}_VERSION_TWEAK}\")

    add_definitions(-D${XBUILD}_RELEASE_TYPE=\"${CMAKE_BUILD_TYPE}\")
    add_definitions(-D${XBUILD}_RELEASE_VERSION=\"${${XBUILD}_RELEASE_VERSION}\")
    add_definitions(-D${XBUILD}_RELEASE_TIMESTAMP=\"${${XBUILD}_RELEASE_TIMESTAMP}\")

    if(HOST_LINUX)
        add_definitions(-DHOST_LINUX)
    endif()

    if(HOST_MACOS)
        add_definitions(-DHOST_MACOS)
    endif()

    if(HOST_WINDOWS)
        add_definitions(-DHOST_WINDOWS)
    endif()

    if(HOST_WINDOWS_MSYS)
        add_definitions(-DHOST_WINDOWS_MSYS)
    endif()

    if(HOST_WINDOWS_MINGW)
        add_definitions(-DHOST_WINDOWS_MINGW)
    endif()

    if(HOST_WINDOWS_CYGWIN)
        add_definitions(-DHOST_WINDOWS_CYGWIN)
    endif()

    if(HOST_ARCH_32)
        add_definitions(-DHOST_ARCH_32)
    endif()

    if(HOST_ARCH_64)
        add_definitions(-DHOST_ARCH_64)
    endif()

    if(HOST_BIG_ENDIAN)
        add_definitions(-DHOST_BIG_ENDIAN)
    endif()
endif()

mark_as_advanced(FORCE XBUILD)
