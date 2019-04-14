if(NOT DEPS_ROOT_DIR)
    set(DEPS_ROOT_DIR "${CMAKE_SOURCE_DIR}/.deps"
        CACHE PATH "Dependencies root directory.")
endif()

set(DEPS_DOWNLOAD_DIR "${DEPS_ROOT_DIR}/downloads"
    CACHE PATH "Dependencies download directory.")
set(DEPS_BUILD_DIR "${DEPS_ROOT_DIR}/build"
    CACHE PATH "Dependencies build directory.")
set(DEPS_INSTALL_DIR "${DEPS_ROOT_DIR}/usr"
    CACHE PATH "Dependencies install directory.")

set(DEPS_BIN_DIR "${DEPS_INSTALL_DIR}/bin"
    CACHE PATH "Dependencies binary install directory.")
set(DEPS_LIB_DIR "${DEPS_INSTALL_DIR}/lib"
    CACHE PATH "Dependencies library install directory.")
set(DEPS_INCLUDE_DIR "${DEPS_INSTALL_DIR}/include"
    CACHE PATH "Dependencies header install directory.")

# External project targets
include(ExternalProject)
include(CheckCCompilerFlag)
include(CMakeParseArguments)

if(NOT DEPS_BUILD_TYPE)
    set(DEPS_BUILD_TYPE "Release")
endif()

if(NOT MAKE_PROGRAM)
    find_program(MAKE_PROGRAM NAMES gmake make)
    if(MAKE_PROGRAM)
        execute_process(
            COMMAND "${MAKE_PROGRAM}" --version
            OUTPUT_VARIABLE MAKE_VERSION_INFO)
        if(NOT "${MAKE_VERSION_INFO}" MATCHES ".*GNU.*")
            unset(MAKE_PROGRAM)
        endif()
    endif()

    if(NOT MAKE_PROGRAM)
        message(FATAL_ERROR "GNU Make is required to build the dependencies.")
    else()
        message(STATUS "Found GNU Make at ${MAKE_PROGRAM}")
    endif()
endif()

if(NOT GIT_PROGRAM)
    find_program(GIT_PROGRAM NAMES git)
    if(NOT GIT_PROGRAM)
        message(WARNING "Git Program NOT found.")
    else()
        message(STATUS "Found Git at ${GIT_PROGRAM}")
    endif()
endif()

set(GIT_PROG ${GIT_PROGRAM})
set(GNU_MAKE ${MAKE_PROGRAM})
file(MAKE_DIRECTORY ${DEPS_DOWNLOAD_DIR})

include(TarballBuild)
include(RepoTreeBuild)
include(DownloadExtract)
include(PrebuildInstall)
