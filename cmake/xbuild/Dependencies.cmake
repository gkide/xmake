set(DEPS_ROOT_DIR "${CMAKE_SOURCE_DIR}/.deps"
    CACHE PATH "Dependencies root directory.")
set(DEPS_BUILD_DIR "${DEPS_ROOT_DIR}/build"
    CACHE PATH "Dependencies build directory.")
set(DEPS_DOWNLOAD_DIR "${DEPS_ROOT_DIR}/downloads"
    CACHE PATH "Dependencies download directory.")
set(DEPS_INSTALL_DIR "${DEPS_ROOT_DIR}/usr"
    CACHE PATH "Dependencies install directory.")
set(DEPS_BIN_DIR "${DEPS_INSTALL_DIR}/bin"
    CACHE PATH "Dependencies binary install directory.")
set(DEPS_LIB_DIR "${DEPS_INSTALL_DIR}/lib"
    CACHE PATH "Dependencies library install directory.")

# External project targets
include(ExternalProject)
include(CheckCCompilerFlag)
include(CMakeParseArguments)

if(CMAKE_BUILD_TYPE STREQUAL "Debug")
    add_compile_options(-O0)
    add_definitions(-DDEBUG)
    check_c_compiler_flag(-Og HAS_OG_FLAG)
    if(HAS_OG_FLAG)
        set(DEFAULT_MAKE_CFLAGS CFLAGS+=-Og ${DEFAULT_MAKE_CFLAGS})
    endif()
endif()

find_program(MAKE_PRG NAMES gmake make)
if(MAKE_PRG)
    execute_process(
        COMMAND "${MAKE_PRG}" --version
        OUTPUT_VARIABLE MAKE_VERSION_INFO)
    if(NOT "${MAKE_VERSION_INFO}" MATCHES ".*GNU.*")
        unset(MAKE_PRG)
    endif()
endif()

if(NOT MAKE_PRG)
    message(FATAL_ERROR "GNU Make is required to build the dependencies.")
else()
    message(STATUS "Found GNU Make at ${MAKE_PRG}")
endif()

set(GNU_MAKE ${MAKE_PRG})

include(DownloadExtract)
