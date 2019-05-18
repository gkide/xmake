cmake_minimum_required(VERSION 2.8.12)
project(xdemo)

set(XDEMO_VERSION_MAJOR 1)
set(XDEMO_VERSION_MINOR 0)
set(XDEMO_VERSION_PATCH 0)
set(XDEMO_VERSION_TWEAK "dev+bd5998caff") # date & HASH auto update at build time

#option(XDEMO_XMAKE_VERBOSE "Show verbose xmake message" ON)

option(XDEMO_ENABLE_GCOV "Enable Coverage" ON)
option(XDEMO_ENABLE_ASSERTION "Enable assertion." ON)
option(XDEMO_ENABLE_CI "Enable for CI build, like: Travis." ON)
option(XDEMO_ENABLE_DEPENDENCY "Enable deps download, build and install" ON)

#option(XDEMO_SKIP_RPATH_ORIGIN "Skip RPATH for dynamic link" ON)
#option(XDEMO_DISABLE_CCACHE "Enale ccache by default for linux" ON)
#option(XDEMO_USE_STATIC_GCC_LIBS "Use static c/c++ libraries." ON)

if(DEMO_RUN_CTEST)
    option(XDEMO_ENABLE_CTEST "Enable Cmake ctest support" ON)
endif()

if(DEMO_RUN_GTEST)
    option(XDEMO_ENABLE_GTEST "Enable Google gtest support" ON)
endif()

if(DEMO_RUN_QT5)
    option(QT5_AUTOMATIC "Enable Google gtest support" ON)
endif()

if(DEMO_RUN_IFW)
    option(XDEMO_ENABLE_IFW "Enable Qt Installer Framework." ON)
endif()

# Cmake modules
list(APPEND CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake")
include(xmake) # xmake should include in the top CMakeLists.txt

file(GLOB HOSTINFO_SOURCES source/*.c)
file(GLOB HOSTINFO_HEADERS source/*.h)

#option(XDEMO_EXPORT_AS_COMPILER_ARGS "Export as CC cmd args" ON)
if(NOT XDEMO_EXPORT_AS_COMPILER_ARGS)
    configure_file(
        "${CMAKE_SOURCE_DIR}/source/config.h.in"
        "${CMAKE_BINARY_DIR}/config.generated.h")
    list(APPEND SOURCES
        "${CMAKE_BINARY_DIR}/config.generated.h")
    add_definitions(-DXDEMO_EXPORT_AS_CONFIG_FILE)
    list(APPEND HOSTINFO_HEADERS ${CMAKE_BINARY_DIR}/config.generated.h)
endif()

if(HOST_WINDOWS)
    configure_file(
        "${CMAKE_SOURCE_DIR}/source/win.rc.in"
        "${CMAKE_BINARY_DIR}/generated.win.rc")
    list(APPEND HOSTINFO_SOURCES ${CMAKE_BINARY_DIR}/generated.win.rc)
elseif(HOST_MACOS)
    # TODO
    list(APPEND HOSTINFO_SOURCES info.plist)
endif()

list(REMOVE_ITEM HOSTINFO_SOURCES ${CMAKE_SOURCE_DIR}/source/awesome.c)
add_executable(hostinfo ${HOSTINFO_SOURCES} ${HOSTINFO_HEADERS})

# For XmakeInstallHelper demo
add_subdirectory(source/xihd)
add_subdirectory(source/ctest)
add_subdirectory(source/gtest)
add_subdirectory(source/qt5)

XmakeInstallHelper(FILES LICENSE
    DESTINATION ${XDEMO_INSTALL_DOC_DIR}
)
XmakeInstallHelper(FILES docs/local.mk
    DESTINATION ${XDEMO_INSTALL_DOC_DIR}
)
XmakeInstallHelper(FILES docs/manual/index.html # PKG_DOC_HELP
    DESTINATION ${XDEMO_INSTALL_DOC_DIR}/manual
)
XmakeInstallHelper(PROGRAMS scripts/release
    DESTINATION ${XDEMO_INSTALL_PLG_DIR}/scripts
)
XmakeInstallHelper(DIRECTORY cmake/xmake
    DESTINATION ${XDEMO_INSTALL_SHA_DIR}/xmake
)
