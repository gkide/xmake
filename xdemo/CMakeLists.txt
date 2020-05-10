cmake_minimum_required(VERSION 2.8.12)
project(xdemo)

set(XDEMO_VERSION_MAJOR 1)
set(XDEMO_VERSION_MINOR 0)
set(XDEMO_VERSION_PATCH 0)
set(XDEMO_VERSION_TWEAK "") # date & HASH auto update at build time

#option(XDEMO_XMAKE_VERBOSE "Show verbose xmake message" ON)

option(XDEMO_ENABLE_GCOV "Enable Coverage" ON)
option(XDEMO_ENABLE_ASSERTION "Enable assertion." ON)
option(XDEMO_ENABLE_CI "Enable for CI build, like: Travis." ON)
option(XDEMO_ENABLE_DEPENDENCY "Enable deps download, build and install" ON)

#option(XDEMO_SKIP_RPATH_ORIGIN "Skip RPATH for dynamic link" ON)
#option(XDEMO_DISABLE_CCACHE "Enale ccache by default for linux" ON)
#option(XDEMO_WIN_USE_STATIC_GCC_LIBS "Use static c/c++ libraries." ON)
#option(XDEMO_EXPORT_AS_COMPILER_ARGS "Export as CC cmd args" ON)
#option(XDEMO_APPIMAGE_DOWNLOAD_SKIP_SHA256 "Do NOT check SHA256" OFF)
#option(XDEMO_ENABLE_APPIMAGE "Enable AppImage support for linux" ON)
#option(XDEMO_ENABLE_IFW "Enable Qt Installer Framework." ON)

# Cmake User Modules & Xmake
list(APPEND CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake")
include(xmake.init) # Should init in the top CMakeLists.txt

configure_file("${CMAKE_SOURCE_DIR}/source/config.h.in"
    "${XDEMO_GENERATED_DIR}/config.h")

if(WIN32)
    configure_file("${CMAKE_SOURCE_DIR}/source/win.rc.in"
        "${XDEMO_GENERATED_DIR}/win.rc")
    set(HOSTINFO_WIN_RC ${CMAKE_BINARY_DIR}/generated.win.rc)
endif()

file(GLOB BARLIB_SOURCES source/bar/*.c)
file(GLOB BARLIB_HEADERS source/bar/*.h)

add_library(bar SHARED ${BARLIB_SOURCES} ${BARLIB_HEADERS})
set_target_properties(bar PROPERTIES
    PUBLIC_HEADER "source/bar/bar.h"
    PRIVATE_HEADER "source/bar/bar-private.h"
)
XmakeInstallHelper(TARGETS bar)

add_executable(hostinfoc source/hostinfo.c)
target_link_libraries(hostinfoc bar)
XmakeInstallHelper(TARGETS hostinfoc)

# cd install dir, then 'hostinfocpp' works
add_executable(hostinfocpp source/hostinfo.cpp)
target_link_libraries(hostinfocpp bar)
XmakeInstallHelper(TARGETS hostinfocpp)
set_target_properties(hostinfocpp PROPERTIES
    # Shared library search path overwrite the default value
    # Shared linked tests only work in the build directory if set ""
    INSTALL_RPATH "../lib"
#   MACOSX_BUNDLE TRUE
#   RESOURCE "..."
)

add_subdirectory(source/gtest)

# https://cmake.org/cmake/help/latest/module/CTest.html
# include(CTest) # Automatically creates a BUILD_TESTING, ON by default
# https://github.com/google/googletest
