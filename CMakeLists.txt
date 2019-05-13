cmake_minimum_required(VERSION 2.8.12)
project(xdemo)

# Package Configuration
#set(PKG_NAME)
#set(PKG_VERSION)
set(PKG_VENDOR "GKIDE")
set(PKG_BRIEF_SUMMARY "cmake & make quick project template!")
set(PKG_REPO "https://github.com/gkide/xmake")
set(PKG_BUG_REPORT "https://github.com/gkide/xmake/issues")
set(PKG_MAINTAINER_EMAIL "Charlie WONG <1213charlie@163.com>")
set(PKG_LOGO ${CMAKE_SOURCE_DIR}/gkide.png)
set(PKG_ICON ${CMAKE_SOURCE_DIR}/docs/res/xmake.ico)
set(PKG_INSTALLER_LOGO ${CMAKE_SOURCE_DIR}/docs/res/install.ico)
set(PKG_UNINSTALLER_LOGO ${CMAKE_SOURCE_DIR}/docs/res/uninstall.ico)
#set(PKG_SOURCE)
#set(PKG_TYPE_GUI true)
#set(PKG_SOURCE_EXCLUDES)
set(PKG_MANUAL_DIR "${CMAKE_BINARY_DIR}")
set(PKG_HELP "doc/manual/index.html")

set(XDEMO_VERSION_MAJOR 1)
set(XDEMO_VERSION_MINOR 0)
set(XDEMO_VERSION_PATCH 0)
set(XDEMO_VERSION_TWEAK "dev") # date & HASH auto update at build time

#option(XDEMO_XMAKE_VERBOSE "Show verbose xmake message" ON)

option(XDEMO_ENABLE_GCOV "Enable Coverage" ON)
option(XDEMO_ENABLE_ASSERTION "Enable assertion." ON)
option(XDEMO_ENABLE_CI "Enable for CI build, like: Travis." ON)
option(XDEMO_ENABLE_DEPENDENCY "Enable deps download, build and install" ON)

option(XDEMO_ENABLE_CTEST "Enable Cmake ctest support" ON)
option(XDEMO_ENABLE_GTEST "Enable Google gtest support" ON)

#option(XDEMO_SKIP_RPATH_ORIGIN "Skip RPATH for dynamic link" ON)
#option(XDEMO_EXPORT_AS_COMPILER_ARGS "Export as CC cmd args" ON)
#option(XDEMO_DISABLE_CCACHE "Enale ccache by default for linux" ON)
#option(XDEMO_USE_STATIC_GCC_LIBS "Use static c/c++ libraries." ON)

# Cmake modules
list(APPEND CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake")
include(xmake) # xmake should include in the top CMakeLists.txt

# Qt5 static/shared support
add_subdirectory(source/qt5)

# Install Static Library Example 1
########################################
add_library(xla STATIC source/library.c)
set_target_properties(xla PROPERTIES
    PUBLIC_HEADER "source/xla.h"
)
# lib/libxla.a
# include/xla.h
InstallHelper(TARGETS xla)
# lib/A/libxla.a
# include/A/xla.h
InstallHelper(TARGETS xla
    DOMAIN A
)

# Install Static Library Example 2
########################################
set(xlb_public_headers
    source/xlb1.h
    source/xlb2.h
)
set(xlb_private_headers
    source/xlb3.h
    source/xlb4.h
)
add_library(xlb STATIC source/library.c)
set_target_properties(xlb PROPERTIES
    PUBLIC_HEADER "${xlb_public_headers}"
    PRIVATE_HEADER "${xlb_private_headers}"
)
# lib/libxlb.a
# include/xlb1.h
# include/xlb2.h
# include/private/xlb3.h
# include/private/xlb4.h
InstallHelper(TARGETS xlb)
# lib/B/libxlb.a
# include/B/xlb1.h
# include/B/xlb2.h
# include/B/private/xlb3.h
# include/B/private/xlb4.h
InstallHelper(TARGETS xlb
    DOMAIN B
)

# Install Static Library Example 3
########################################
add_library(xlc STATIC source/library.c)
# lib/libxlc.a
InstallHelper(TARGETS xlc)

# lib/anywhere/libxlc.a
InstallHelper(TARGETS xlc
    DOMAIN anywhere
)
# include/anywhere/xlc.h
InstallHelper(FILES source/xlc.h
    DESTINATION anywhere # prefix/anywhere
)

# Install Shared Library Example 1
########################################
add_library(yla SHARED source/library.c)
set_target_properties(yla PROPERTIES
    PUBLIC_HEADER "source/yla.h"
)
# lib/libyla.so
# include/yla.h
InstallHelper(TARGETS yla)
# lib/A/libyla.so
# include/A/yla.h
InstallHelper(TARGETS yla
    DOMAIN A
)

# Install Shared Library Example 2
########################################
set(ylb_public_headers
    source/ylb1.h
    source/ylb2.h
)
set(ylb_private_headers
    source/ylb3.h
    source/ylb4.h
)
add_library(ylb SHARED source/library.c)
set_target_properties(ylb PROPERTIES
    PUBLIC_HEADER "${ylb_public_headers}"
    PRIVATE_HEADER "${ylb_private_headers}"
)
# lib/libylb.so
# include/ylb1.h
# include/ylb2.h
# include/private/ylb3.h
# include/private/ylb4.h
InstallHelper(TARGETS ylb)
# lib/B/libylb.so
# include/B/ylb1.h
# include/B/ylb2.h
# include/B/private/ylb3.h
# include/B/private/ylb4.h
InstallHelper(TARGETS ylb
    DOMAIN B
)

# Install Shared Library Example 3
########################################
add_library(ylc SHARED source/library.c)
# lib/libylc.so
InstallHelper(TARGETS ylc)

# lib/anywhere/libylc.so
InstallHelper(TARGETS ylc
    DOMAIN anywhere
)
# include/anywhere/ylc.h
InstallHelper(FILES source/ylc.h
    DESTINATION anywhere # prefix/anywhere
)

file(GLOB SOURCES source/main.c)

if(NOT XDEMO_EXPORT_AS_COMPILER_ARGS)
    configure_file(
        "${CMAKE_SOURCE_DIR}/source/config.h.in"
        "${CMAKE_BINARY_DIR}/config.generated.h")
    list(APPEND SOURCES
        "${CMAKE_BINARY_DIR}/config.generated.h")
    add_definitions(-DXDEMO_EXPORT_AS_CONFIG_FILE)
endif()

# Install Executable Example 1
########################################
if(HOST_WINDOWS)
    configure_file(
        "${CMAKE_SOURCE_DIR}/source/win.rc.in"
        "${CMAKE_BINARY_DIR}/generated.win.rc")
    list(APPEND XTEST_RC ${CMAKE_BINARY_DIR}/generated.win.rc)
elseif(HOST_MACOS)
    # TODO
    list(APPEND XTEST_RC info.plist)
endif()

add_executable(xtest ${SOURCES} ${XTEST_RC} source/library.c)
add_executable(xtest-cxx source/main.cpp source/library.c)
InstallHelper(TARGETS xtest)

# Install Executable Example 2
########################################
add_executable(prog ${SOURCES})
target_link_libraries(prog yla)
InstallHelper(TARGETS prog)

# Install Executable Example 3
########################################
add_executable(another ${SOURCES})
target_link_libraries(another ylc)
# show link detail command for target another
# target_link_libraries(another ylc --verbose)
set_target_properties(another PROPERTIES
    # Shared library search path overwrite the default value
    INSTALL_RPATH $ANY/lib/anywhere
)
InstallHelper(TARGETS xtest another)

# Install Executable Example 4
########################################
add_executable(check ${SOURCES})
target_link_libraries(check ylc)
set_target_properties(check PROPERTIES
    # make shared linked test programes only work in the build directory
    INSTALL_RPATH ""
)
InstallHelper(TARGETS check)

# Install Executable Example 5
########################################
add_executable(bundle ${SOURCES} source/library.c)
set(BUNDLE_RESOURCE # Extra resources for executable
    docs/res/install.ico
    docs/res/uninstall.ico
)
set_target_properties(bundle PROPERTIES
#   MACOSX_BUNDLE TRUE
    RESOURCE "${BUNDLE_RESOURCE}")
InstallHelper(TARGETS bundle)

# Download & Build External Project
########################################
include(BuildLibok)
add_dependencies(bundle libok)

# Download & Prebuild Binary
########################################
include(PreInstall)

# Install Executable of NOT Target
########################################
InstallHelper(PROGRAMS scripts/release
    DESTINATION ${XDEMO_INSTALL_PLG_DIR})
InstallHelper(PROGRAMS scripts/release
    DESTINATION ${XDEMO_INSTALL_PLG_DIR}/scripts)

# Install Normal Files
########################################
InstallHelper(FILES LICENSE) # prefix/LICENSE
InstallHelper(FILES docs/local.mk
    DESTINATION ${XDEMO_INSTALL_DOC_DIR})
InstallHelper(FILES docs/manual/index.html # PKG_HELP
    DESTINATION ${XDEMO_INSTALL_DOC_DIR}/manual)

# Install Directory
########################################
InstallHelper(DIRECTORY cmake
    DESTINATION ${XDEMO_INSTALL_SHA_DIR})

# Code Coverage Report
CodeCoverageGcovrXml(
    TARGET gcovr-xml
    EXECUTABLE another
)

CodeCoverageGcovrHtml(
    TARGET gcovr-html
    EXECUTABLE check
    GCOVR_ARGS --html-title "CCR - check"
)

CodeCoverageGcovrText(
    TARGET gcovr-text
    EXECUTABLE prog
)

CodeCoverageLcovHtml(
    TARGET lcov-html
    EXECUTABLE bundle
    LCOV_EXCLUDES
        source/qt5
        source/main.cpp
        ${XDEMO_AUTO_QT5_SOURCES}
        ${QT5_STATIC_PREFIX}
        ${QT5_SHARED_PREFIX}
    GENHTML_ARGS
        --title "bundle"
)

add_subdirectory(source/ccr)
add_subdirectory(source/gtest)

GetInstalledBinaries(installed_binaries)
foreach(item ${installed_binaries})
    message(STATUS "Install: ${item}")
endforeach()
