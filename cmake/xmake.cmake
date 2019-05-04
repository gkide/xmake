# xmake git repo is https://gitlab.com/gkide/xmake
cmake_minimum_required(VERSION 2.8.12)
string(TOUPPER ${PROJECT_NAME} XMAKE) # The Uppercase of Project Name

string(APPEND ${XMAKE}_RELEASE_VERSION "v${${XMAKE}_VERSION_MAJOR}")
string(APPEND ${XMAKE}_RELEASE_VERSION ".${${XMAKE}_VERSION_MINOR}")
string(APPEND ${XMAKE}_RELEASE_VERSION ".${${XMAKE}_VERSION_PATCH}")

# The available build type values
if(NOT CMAKE_CONFIGURATION_TYPES)
    list(APPEND CMAKE_CONFIGURATION_TYPES "Dev")
    list(APPEND CMAKE_CONFIGURATION_TYPES "Debug")
    list(APPEND CMAKE_CONFIGURATION_TYPES "Coverage")

    list(APPEND CMAKE_CONFIGURATION_TYPES "Release")
    list(APPEND CMAKE_CONFIGURATION_TYPES "MinSizeRel")
    list(APPEND CMAKE_CONFIGURATION_TYPES "RelWithDebInfo")
endif()

# In case of not set, set default build type to 'Debug'
if(NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE "Debug" CACHE STRING "Choose build type ..." FORCE)
endif()

string(TOUPPER ${CMAKE_BUILD_TYPE} buildType)

# Enable verbose output from Makefile builds.
option(CMAKE_VERBOSE_MAKEFILE OFF)
# Output compile commands to compile_commands.json
option(CMAKE_EXPORT_COMPILE_COMMANDS OFF)

# Output for binary, static/shared libraries.
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
foreach(type ${CMAKE_CONFIGURATION_TYPES})
    string(TOUPPER ${type} TYPE)
    set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_${TYPE} ${CMAKE_BINARY_DIR}/${type}/bin)
    set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY_${TYPE} ${CMAKE_BINARY_DIR}/${type}/lib)
    set(CMAKE_LIBRARY_OUTPUT_DIRECTORY_${TYPE} ${CMAKE_BINARY_DIR}/${type}/lib)
endforeach()

# Change the default cmake value without overriding the user-provided one
if(CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT)
    set(CMAKE_INSTALL_PREFIX "${PROJECT_BINARY_DIR}/usr" CACHE PATH "" FORCE)
endif()

# Cmake modules
list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_LIST_DIR}/xmake")
include(PreventInTreeBuilds)
include(CheckHostSystem)
include(InstallHelper)

#######################################################################
# dev/pre/nightly => alpha => beta => rc => lts/stable/release => eol #
# https://github.com/gkide/repo-hooks/blob/master/scripts/sync-release#
#######################################################################
if(${XMAKE}_VERSION_TWEAK)
    set(tweak_devs dev pre nightly)
    set(tweak_pres alpha beta rc)
    set(tweak_rels lts stable release eol)
    set(tweak "${${XMAKE}_VERSION_TWEAK}")

    foreach(item IN ITEMS ${tweak_devs} ${tweak_pres} ${tweak_rels})
        if(tweak MATCHES "^(${item})?(\\.?([0-9]+))?(\\+?([a-f0-9]+))?$")
            set(is_normalized_tweak true)
            string(REGEX MATCH "^(${item})?(\\.?([0-9]+))?(\\+?([a-f0-9]+))?$"
               match_result "${tweak}")
            set(tweak_text "${CMAKE_MATCH_1}") # Software Release Cycle
            set(tweak_nums "${CMAKE_MATCH_3}") # YYYYMMDD or numbers
            set(tweak_hash "${CMAKE_MATCH_5}") # repo HASH
            break()
        endif()
    endforeach()

    if(NOT is_normalized_tweak)
        string(REPLACE ";" "/" tweak_devs "${tweak_devs}")
        string(REPLACE ";" " -> " tweak_pres "${tweak_pres}")
        string(REPLACE ";" "/" tweak_rels "${tweak_rels}")
        set(normalized "${tweak_devs} -> ${tweak_pres} -> ${tweak_rels}")
        message(AUTHOR_WARNING "Consider the normalized tweaks:\n${normalized}\n")
    endif()

    set(xauto_semver_tweak "")
    if(tweak_text)
        set(xauto_semver_tweak "${tweak_text}")
        string(APPEND ${XMAKE}_RELEASE_VERSION "-${tweak_text}")
    endif()

    string(LENGTH "${tweak_nums}" tweak_nums_len) # YYYYMMDD...
    if(tweak_nums_len GREATER 7) # get current timestamp of YYYYMMDD
        set(yyyymmdd "${${XMAKE}_RELEASE_TIMESTAMP}")
        string(REPLACE "\"" "" yyyymmdd "${yyyymmdd}")
        string(REPLACE "\\" "" yyyymmdd "${yyyymmdd}")
        string(SUBSTRING "${yyyymmdd}" 00 10 yyyymmdd)
        string(REPLACE "-" "" yyyymmdd ${yyyymmdd})
        string(APPEND ${XMAKE}_RELEASE_VERSION ".${yyyymmdd}")
        set(tweak_nums "${yyyymmdd}")
    endif()

    if(xauto_semver_tweak)
        set(xauto_semver_tweak "${xauto_semver_tweak}.${tweak_nums}")
    else()
        set(xauto_semver_tweak "${tweak_nums}")
    endif()
endif()

if(XMAKE_ENABLE_ASSERTION)
    message(STATUS "Enable assert")
    if(CMAKE_C_FLAGS_${buildType} MATCHES DNDEBUG)
        string(REPLACE "-DNDEBUG" "" CMAKE_C_FLAGS_${buildType}
            "${CMAKE_C_FLAGS_${buildType}}")
    endif()
    if(CMAKE_CXX_FLAGS_${buildType} MATCHES DNDEBUG)
        string(REPLACE "-DNDEBUG" "" CMAKE_CXX_FLAGS_${buildType}
            "${CMAKE_CXX_FLAGS_${buildType}}")
    endif()
else()
    message(STATUS "Disable assert")
    if(NOT CMAKE_C_FLAGS_${buildType} MATCHES DNDEBUG)
        set(CMAKE_C_FLAGS_${buildType}
            "-DNDEBUG ${CMAKE_C_FLAGS_${buildType}}")
    endif()
    if(NOT CMAKE_CXX_FLAGS_${buildType} MATCHES DNDEBUG)
        set(CMAKE_CXX_FLAGS_${buildType}
            "-DNDEBUG ${CMAKE_CXX_FLAGS_${buildType}}")
    endif()
endif()

# Disable Travis CI by default
if(XMAKE_ENABLE_TRAVIS_CI)
    add_compile_options("-Werror")
    message(STATUS "Enable travis-ci")
endif()

# Enable code coverage
if(XMAKE_ENABLE_GCOV)
    include(CodeCoverage)
endif()

# Enable ccache for linux & likes by default
if(NOT HOST_WINDOWS AND NOT XMAKE_DISABLE_CCACHE)
    find_program(CCACHE_PROG ccache)
    if(CCACHE_PROG)
        message(STATUS "Enable recompilation speeds up by ccache")
        set_property(GLOBAL PROPERTY RULE_LAUNCH_LINK ${CCACHE_PROG})
        set_property(GLOBAL PROPERTY RULE_LAUNCH_COMPILE ${CCACHE_PROG})
    else()
        message(AUTHOR_WARNING "NOT found ccache for speeds up recompilation")
    endif()
endif()

if(XMAKE_QT5_STATIC_PREFIX OR XMAKE_QT5_SHARED_PREFIX OR XMAKE_QT5_SUPPORT)
    include(Qt5Helper)
endif()

if(XMAKE_ENABLE_DEPENDENCY)
    include(Dependencies)
endif()

#include(PrintCmake)

if(XMAKE_EXPORT_AS_COMPILER_ARGS)
    add_definitions(-DHOST_NAME=\"${HOST_NAME}\")
    add_definitions(-DHOST_USER=\"${HOST_USER}\")
    add_definitions(-DHOST_ARCH=\"${HOST_ARCH}\")
    add_definitions(-DHOST_SYSTEM_NAME=\"${HOST_SYSTEM_NAME}\")
    add_definitions(-DHOST_SYSTEM_VERSION=\"${HOST_SYSTEM_VERSION}\")
    add_definitions(-DHOST_OS_DIST_NAME=\"${HOST_OS_DIST_NAME}\")
    add_definitions(-DHOST_OS_DIST_VERSION=\"${HOST_OS_DIST_VERSION}\")

    add_definitions(-D${XMAKE}_VERSION_MAJOR=${${XMAKE}_VERSION_MAJOR})
    add_definitions(-D${XMAKE}_VERSION_MINOR=${${XMAKE}_VERSION_MINOR})
    add_definitions(-D${XMAKE}_VERSION_PATCH=${${XMAKE}_VERSION_PATCH})
    add_definitions(-D${XMAKE}_VERSION_TWEAK=\"${${XMAKE}_VERSION_TWEAK}\")

    add_definitions(-D${XMAKE}_RELEASE_TYPE=\"${CMAKE_BUILD_TYPE}\")
    add_definitions(-D${XMAKE}_RELEASE_VERSION=\"${${XMAKE}_RELEASE_VERSION}\")
    add_definitions(-D${XMAKE}_RELEASE_TIMESTAMP=\"${${XMAKE}_RELEASE_TIMESTAMP}\")

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

if(HOST_WINDOWS_MSYS OR HOST_WINDOWS_MINGW OR HOST_WINDOWS_CYGWIN)
    # do not need:
    # - msys-gcc_s-seh-1.dll for MSYS
    # - libgcc_s-seh-1.dll for MinGW
    # - cyg-gcc_s-seh-1.dll for Cygwin
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -static-libgcc -static")
    # do not need:
    # - msys-stdc++-6.dll for MSYS
    # - libstdc++-6.dll for MinGW
    # - cyg-stdc++-6.dll for Cygwin
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -static-libstdc++ -static")

    if(HOST_WINDOWS_MSYS)
        InstallHelper(FILES
            /usr/bin/${CMAKE_SHARED_LIBRARY_PREFIX}2.0${CMAKE_SHARED_LIBRARY_SUFFIX}
            DESTINATION ${${XMAKE}_PREFIX}/bin)
    elseif(HOST_WINDOWS_CYGWIN)
        InstallHelper(FILES
            /usr/bin/${CMAKE_SHARED_LIBRARY_PREFIX}win1${CMAKE_SHARED_LIBRARY_SUFFIX}
            DESTINATION ${${XMAKE}_PREFIX}/bin)
    endif()
endif()

include(GetGitRepoInfo)

mark_as_advanced(FORCE XMAKE)
