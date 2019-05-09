# xmake git repo is https://github.com/gkide/xmake
cmake_minimum_required(VERSION 2.8.12)

if(NOT PROJECT_NAME MATCHES "^[A-Za-z0-9_-]+$")
    message(FATAL_ERROR "PROJECT_NAME should consist of [A-Za-z0-9_-]!")
endif()

string(TOUPPER ${PROJECT_NAME} XMAKE) # The Uppercase of Project Name
mark_as_advanced(XMAKE)

string(APPEND ${XMAKE}_RELEASE_VERSION "v${${XMAKE}_VERSION_MAJOR}")
string(APPEND ${XMAKE}_RELEASE_VERSION ".${${XMAKE}_VERSION_MINOR}")
string(APPEND ${XMAKE}_RELEASE_VERSION ".${${XMAKE}_VERSION_PATCH}")

if(NOT PKG_VERSION)
    set(PKG_VERSION "${${XMAKE}_RELEASE_VERSION}")
endif()

# If not set, auto use the lower case of project and make it hidden
if(NOT PKG_NAME)
    string(TOLOWER ${PROJECT_NAME} PKG_NAME)
endif()

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

if(CMAKE_BUILD_TYPE MATCHES "Dev"
   OR CMAKE_BUILD_TYPE MATCHES "Debug"
   OR CMAKE_BUILD_TYPE MATCHES "Coverage")
    add_compile_options(-g)
    add_compile_options(-O0)
    set(${XMAKE}_DEBUG_BUILD ON)
    if(NOT ${XMAKE}_LOG_TYPE OR NOT ${XMAKE}_LOG_LEVEL)
        set(${XMAKE}_LOG_LEVEL 0) # DEV
    endif()
else()
    add_compile_options(-O3)

    if(NOT ${XMAKE}_LOG_TYPE OR NOT ${XMAKE}_LOG_LEVEL)
        set(${XMAKE}_LOG_LEVEL 3) # WARN
    endif()
endif()

if(CMAKE_BUILD_TYPE MATCHES "Debug")
    set(pkg_dir_name "${PKG_NAME}-latest")
else()
    set(pkg_dir_name "${PKG_NAME}-${PKG_VERSION}")
endif()
mark_as_advanced(pkg_dir_name)

# Change the default cmake value without overriding the user-provided one
if(CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT)
    if(NOT HOST_WINDOWS)
        set(pkg_install_dir "/opt/${pkg_dir_name}")
    else()
        if(HOST_ARCH_32)
            set(pkg_install_dir "C:/$ENV{PROGRAMFILES}/${pkg_dir_name}")
        else()
            set(pkg_install_dir "C:/$ENV{PROGRAMFILES64}/${pkg_dir_name}")
        endif()
    endif()

    mark_as_advanced(pkg_install_dir)
    set(CMAKE_INSTALL_PREFIX "${pkg_install_dir}" CACHE PATH "" FORCE)
endif()

# Make sure always install to $PKG_NAME-$PKG_VERSION
if(NOT CMAKE_INSTALL_PREFIX MATCHES ${pkg_dir_name})
    set(CMAKE_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}/${pkg_dir_name}")
endif()

# for Dev, Coverage build
if(${XMAKE}_DEBUG_BUILD AND NOT CMAKE_BUILD_TYPE MATCHES "Debug")
    set(CMAKE_INSTALL_PREFIX "${CMAKE_BINARY_DIR}/usr")
endif()

string(TOUPPER ${CMAKE_BUILD_TYPE} buildType)
mark_as_advanced(buildType)

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

# Cmake modules
list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_LIST_DIR}/xmake")
include(PreventInTreeBuilds)
include(CheckHostSystem)
include(InstallHelper)

# NOTE If want to strip the installed binaries for pack
# 'include(PkgSrcPackage)' should be put the last statement
# of the top cmake, thus when goes here, it gets all the targets
include(PkgSrcPackage)

#######################################################################
# dev/pre/nightly => alpha => beta => rc => lts/stable/release => eol #
# https://github.com/gkide/repo-hooks/blob/master/scripts/sync-release#
#######################################################################
if(NOT ${XMAKE}_VERSION_TWEAK)
    if(NOT CMAKE_BUILD_TYPE MATCHES "Release"
       AND NOT CMAKE_BUILD_TYPE STREQUAL "MinSizeRel"
       AND NOT CMAKE_BUILD_TYPE STREQUAL "RelWithDebInfo")
        set(${XMAKE}_VERSION_TWEAK "dev")
    endif()
endif()

if(${XMAKE}_VERSION_TWEAK)
    set(tweak_devs dev pre nightly)
    set(tweak_pres alpha beta rc)
    set(tweak_rels lts stable release eol)
    set(tweak "${${XMAKE}_VERSION_TWEAK}")

    mark_as_advanced(tweak_devs tweak_pres tweak_rels tweak)

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

    mark_as_advanced(is_normalized_tweak)
    mark_as_advanced(tweak_text tweak_nums tweak_hash)

    if(NOT is_normalized_tweak)
        string(REPLACE ";" "/" tweak_devs "${tweak_devs}")
        string(REPLACE ";" " -> " tweak_pres "${tweak_pres}")
        string(REPLACE ";" "/" tweak_rels "${tweak_rels}")
        set(normalized "${tweak_devs} -> ${tweak_pres} -> ${tweak_rels}")
        mark_as_advanced(normalized)
        message(AUTHOR_WARNING "Consider the normalized tweaks:\n${normalized}\n")
    endif()

    set(pkg_version_tweak "")
    mark_as_advanced(pkg_version_tweak)
    if(tweak_text)
        set(pkg_version_tweak "${tweak_text}")
        string(APPEND ${XMAKE}_RELEASE_VERSION "-${tweak_text}")
    endif()

    string(LENGTH "${tweak_nums}" tweak_nums_len) # YYYYMMDD...
    mark_as_advanced(tweak_nums_len)
    if(tweak_nums_len GREATER 7 OR tweak_nums_len EQUAL 0)
        set(yyyymmdd "${${XMAKE}_RELEASE_TIMESTAMP}")
        string(REPLACE "\"" "" yyyymmdd "${yyyymmdd}")
        string(REPLACE "\\" "" yyyymmdd "${yyyymmdd}")
        string(SUBSTRING "${yyyymmdd}" 00 10 yyyymmdd)
        string(REPLACE "-" "" yyyymmdd ${yyyymmdd})
        string(APPEND ${XMAKE}_RELEASE_VERSION ".${yyyymmdd}")
        set(tweak_nums "${yyyymmdd}")
    endif()

    if(tweak_nums)
        if(tweak_text)
            set(pkg_version_tweak "${pkg_version_tweak}.${tweak_nums}")
        else()
            set(pkg_version_tweak "${tweak_nums}")
        endif()
    endif()
endif()

add_compile_options(-Wall)
add_compile_options(-fPIC)
add_compile_options(-Wextra)
add_compile_options(-Wunused)
add_compile_options(-Winit-self)
add_compile_options(-Wconversion)
add_compile_options(-Wfatal-errors)
add_compile_options(-Wuninitialized)
add_compile_options(-Wunused-parameter)

include_directories(${CMAKE_SOURCE_DIR})
include_directories(${CMAKE_BINARY_DIR})

if(${XMAKE}_ENABLE_ASSERTION)
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

# Disable CI build by default, like: Travis
if(${XMAKE}_ENABLE_CI)
    add_compile_options("-Werror")
    message(STATUS "Enable travis-ci")
endif()

# Enable code coverage
if(${XMAKE}_ENABLE_GCOV)
    include(CodeCoverage)
endif()

# Enable ccache for linux & likes by default
if(NOT HOST_WINDOWS AND NOT ${XMAKE}_DISABLE_CCACHE)
    find_program(CCACHE_PROG ccache)
    mark_as_advanced(CCACHE_PROG)
    if(CCACHE_PROG)
        message(STATUS "Enable recompilation speeds up by ccache")
        set_property(GLOBAL PROPERTY RULE_LAUNCH_LINK ${CCACHE_PROG})
        set_property(GLOBAL PROPERTY RULE_LAUNCH_COMPILE ${CCACHE_PROG})
    else()
        message(AUTHOR_WARNING "NOT found ccache for speeds up recompilation")
    endif()
endif()

# Checking logging level
# DEV(0), DEBUG(1), INFO(2), WARN(3), ERROR(4), FATAL(5), DISABLE(6)
if(${XMAKE}_LOG_LEVEL MATCHES "^[0-6]$")
    if(${XMAKE}_LOG_LEVEL EQUAL 0)
        set(${XMAKE}_LOG_TYPE "DEV")
    elseif(${XMAKE}_LOG_LEVEL EQUAL 1)
        set(${XMAKE}_LOG_TYPE "DEBUG")
    elseif(${XMAKE}_LOG_LEVEL EQUAL 2)
        set(${XMAKE}_LOG_TYPE "INFO")
    elseif(${XMAKE}_LOG_LEVEL EQUAL 3)
        set(${XMAKE}_LOG_TYPE "WARN")
    elseif(${XMAKE}_LOG_LEVEL EQUAL 4)
        set(${XMAKE}_LOG_TYPE "ERROR")
    elseif(${XMAKE}_LOG_LEVEL EQUAL 5)
        set(${XMAKE}_LOG_TYPE "FATAL")
    else()
        set(${XMAKE}_LOG_TYPE "DISABLE")
        add_definitions("-D${XMAKE}_LOG_DISABLE")
    endif()
    message(STATUS "Min Log Level: ${${XMAKE}_LOG_TYPE}(${${XMAKE}_LOG_LEVEL})")
else()
    message(FATAL_ERROR "ERROR: log level is ${${XMAKE}_LOG_TYPE}(${${XMAKE}_LOG_LEVEL})")
endif()

if(QT5_STATIC_PREFIX OR QT5_SHARED_PREFIX OR QT5_AUTOMATIC)
    include(Qt5Helper)
endif()

if(${XMAKE}_ENABLE_DEPENDENCY)
    include(Dependencies)
endif()

#include(PrintCmake)

if(${XMAKE}_EXPORT_AS_COMPILER_ARGS)
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
            DESTINATION ${${XMAKE}_INSTALL_BIN_DIR})
    elseif(HOST_WINDOWS_CYGWIN)
        InstallHelper(FILES
            /usr/bin/${CMAKE_SHARED_LIBRARY_PREFIX}win1${CMAKE_SHARED_LIBRARY_SUFFIX}
            DESTINATION ${${XMAKE}_INSTALL_BIN_DIR})
    endif()
endif()

include(GetGitRepoInfo)

if(NOT PKG_MANUAL_DIR)
    set(PKG_MANUAL_DIR "${CMAKE_BINARY_DIR}")
endif()

# Generate Doxygen API Manual
find_package(Doxygen)
if(DOXYGEN_PROG OR DOXYGEN_FOUND)
    if(NOT DOXYGEN_PROG)
        set(DOXYGEN_PROG ${DOXYGEN_EXECUTABLE})
    endif()

    if(NOT PKG_SOURCE)
        if(EXISTS ${CMAKE_SOURCE_DIR}/src)
            set(PKG_SOURCE ${CMAKE_SOURCE_DIR}/src)
        elseif(EXISTS ${CMAKE_SOURCE_DIR}/source)
            set(PKG_SOURCE ${CMAKE_SOURCE_DIR}/source)
        else()
            set(PKG_SOURCE ${CMAKE_SOURCE_DIR})
        endif()
    endif()

    set(pkg_version ${PKG_VERSION})
    if(pkg_version_tweak)
        set(pkg_version ${pkg_version}-${pkg_version_tweak})
    endif()

    configure_file(
        "${CMAKE_CURRENT_LIST_DIR}/xmake/doxygen/Doxyfile.in"
        "${PKG_MANUAL_DIR}/doxygen/Doxyfile"
    )

    add_custom_target(doxygen
        COMMENT "Generating API documentation by doxygen"
        COMMAND ${DOXYGEN_PROG} ${PKG_MANUAL_DIR}/doxygen/Doxyfile
    )
endif()

# Automatically creates a BUILD_TESTING, ON by default
include(CTest)
