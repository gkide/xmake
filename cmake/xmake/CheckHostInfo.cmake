if(CMAKE_HOST_SYSTEM_NAME MATCHES "MSYS")
    option(MSYS "Host building system is windows/msys." ON)
endif()

# set ARCH_NAME to the normalized name: x86 or x86_64
# See https://github.com/axr/solar-cmake/blob/master/TargetArch.cmake
include(CheckSymbolExists)

# x86
check_symbol_exists("__i386__"  ""  T_I386)
check_symbol_exists("_M_IX86"   ""  T_M_IX86)
if(T_M_IX86 OR T_I386)
    set(ARCH_NAME "x86")
    option(ARCH_32 "Host system is 32-bits." ON)
endif()

# x86_64
check_symbol_exists("__amd64__"   ""  T_AMD64)
check_symbol_exists("__x86_64__"  ""  T_X86_64)
check_symbol_exists("_M_AMD64"    ""  T_M_AMD64)

if(T_M_AMD64 OR T_X86_64 OR T_AMD64)
    set(ARCH_NAME "x86_64")
    option(ARCH_64 "Host system is 64-bits." ON)
endif()

if(NOT ARCH_32 AND NOT ARCH_64)
    message(FATAL_ERROR "Unknown host system architecture!")
endif()

include(TestBigEndian)
TEST_BIG_ENDIAN(IS_BIG_ENDIAN)

include(xmake/HostInfo)
HostNameUserName(HOST_USER HOST_NAME)
HostSystemInfo(HOST_DIST_NAME HOST_DIST_VERSION)
HostSystemTime(${XMAKE}_RELEASE_TIMESTAMP)

string(REGEX MATCH "^([0-9]+)-([0-9]+)-([0-9]+) +([0-9]+):([0-9]+):([0-9]+).*"
    match_result "${${XMAKE}_RELEASE_TIMESTAMP}")
set(${XMAKE}_RELEASE_YEAR "${CMAKE_MATCH_1}")
set(${XMAKE}_RELEASE_MONTH "${CMAKE_MATCH_2}")
set(${XMAKE}_RELEASE_DAY "${CMAKE_MATCH_3}")
