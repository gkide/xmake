cmake_minimum_required(VERSION 2.8.12)
project(xmake)

set(XMAKE_VERSION_MAJOR 1)
set(XMAKE_VERSION_MINOR 0)
set(XMAKE_VERSION_PATCH 0)
set(XMAKE_VERSION_TWEAK "release")

option(XMAKE_VERBOSE_MESSAGE "Show verbose xmake message" OFF)
option(XMAKE_SKIP_RPATH_ORIGIN "Skip RPATH for dynamic link" OFF)
option(XMAKE_EXPORT_AS_COMPILER_ARGS "Export as CC cmd args" OFF)

# Cmake modules
list(APPEND CMAKE_MODULE_PATH "${PROJECT_SOURCE_DIR}/cmake")
include(xmake)

add_compile_options(-Wall)
include_directories(${CMAKE_SOURCE_DIR})
include_directories(${CMAKE_BINARY_DIR})

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
    DESTINATION ${${XMAKE}_PREFIX}/anywhere
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
    DESTINATION ${${XMAKE}_PREFIX}/anywhere
)

file(GLOB SOURCES source/main.c)

if(NOT XMAKE_EXPORT_AS_COMPILER_ARGS)
    configure_file(
        "${CMAKE_SOURCE_DIR}/source/config.h.in"
        "${CMAKE_BINARY_DIR}/config.generated.h")
    list(APPEND SOURCES
        "${CMAKE_BINARY_DIR}/config.generated.h")
    add_definitions(-DXMAKE_EXPORT_AS_CONFIG_FILE)
endif()

# Install Executable Example 1
########################################
add_executable(check ${SOURCES} source/library.c)
InstallHelper(TARGETS check)

# Download & Build External Project
########################################
include(BuildLibok)
add_dependencies(check libok)

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
InstallHelper(TARGETS check another)

# Install Executable Example 4
########################################
add_executable(xtest ${SOURCES})
target_link_libraries(xtest ylc)
set_target_properties(xtest PROPERTIES
    # make shared linked test programes only work in the build directory
    INSTALL_RPATH ""
)
InstallHelper(TARGETS xtest)

# Install Executable Example 5
########################################
add_executable(bundle ${SOURCES} source/library.c)
set(BUNDLE_RESOURCE # Extra resources for executable
    source/resources/gnu.jpeg
    source/resources/linux.jpeg
)
set_target_properties(bundle PROPERTIES
#   MACOSX_BUNDLE TRUE
    RESOURCE "${BUNDLE_RESOURCE}")
InstallHelper(TARGETS bundle)

# Install Executable of NOT Target
########################################
InstallHelper(PROGRAMS scripts/release
    DESTINATION ${XMAKE_PLGDIR})
InstallHelper(PROGRAMS scripts/release
    DESTINATION ${XMAKE_PLGDIR}/scripts)

# Install Normal Files
########################################
InstallHelper(FILES LICENSE
    DESTINATION ${XMAKE_PREFIX})
InstallHelper(FILES docs/local.mk
    DESTINATION ${XMAKE_DOCDIR})

# Install Directory
########################################
InstallHelper(DIRECTORY cmake
    DESTINATION ${XMAKE_SHADIR})
