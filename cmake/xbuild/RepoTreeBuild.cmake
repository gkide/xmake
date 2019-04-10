include(CMakeParseArguments)

function(BuildDepsRepo name)
    string(TOUPPER ${name} BDTB)
    cmake_parse_arguments(${BDTB} # prefix
        "" # options
        "REPO_URL" # one_value_keywords
        "PATCH_CMD;CONFIG_CMD;BUILD_CMD;INSTALL_CMD" # multi_value_keywords
        ${ARGN})

    if(NOT ${BDTB}_REPO_URL)
        message(FATAL_ERROR "Must set REPO_URL for ${name}.")
    endif()

    if(NOT ${BDTB}_CONFIG_CMD AND
       NOT ${BDTB}_BUILD_CMD AND
       NOT ${BDTB}_INSTALL_CMD)
        message(FATAL_ERROR
            "Must set one of CONFIG_CMD, BUILD_CMD, INSTALL_CMD for ${name}.")
    endif()

    if(NOT ${BDTB}_PATCH_CMD)
        set(${BDTB}_PATCH_CMD "")
    endif()

    if(NOT ${BDTB}_CONFIG_CMD)
        set(${BDTB}_CONFIG_CMD "")
    endif()

    if(NOT ${BDTB}_BUILD_CMD)
        set(${BDTB}_BUILD_CMD "")
    endif()

    if(NOT ${BDTB}_INSTALL_CMD)
        set(${BDTB}_INSTALL_CMD "")
    endif()

    set(REPO_DIR ${DEPS_DOWNLOAD_DIR}/${name})
    set(BUILD_DIR ${DEPS_BUILD_DIR}/${name})
    
    ExternalProject_Add(   ${name}
    # General
        PREFIX             ${DEPS_BUILD_DIR}
        STAMP_DIR          ${BUILD_DIR}-stamp
    # Download
        DOWNLOAD_DIR       ${DEPS_DOWNLOAD_DIR}
        DOWNLOAD_COMMAND   ${CMAKE_COMMAND}
            -E copy_directory ${REPO_DIR} ${BUILD_DIR}
    # Patch
        PATCH_COMMAND       "${${BDTB}_PATCH_CMD}"
    # Configure
        SOURCE_DIR         ${BUILD_DIR}
        CONFIGURE_COMMAND  "${${BDTB}_CONFIG_CMD}"
    # Build
        BINARY_DIR         ${BUILD_DIR}
        BUILD_COMMAND      "${${BDTB}_BUILD_CMD}"
    # Install
        INSTALL_DIR        ${DEPS_INSTALL_DIR}
        INSTALL_COMMAND    "${${BDTB}_INSTALL_CMD}")
        
    if(NOT (EXISTS ${REPO_DIR} AND IS_DIRECTORY ${REPO_DIR} 
            AND EXISTS ${REPO_DIR}/.git AND IS_DIRECTORY ${REPO_DIR}/.git))
        ExternalProject_Add_Step(${name} ${name}-repo-clone
            COMMENT "git clone ${${BDTB}_REPO_URL} ${name}"
                WORKING_DIRECTORY ${DEPS_DOWNLOAD_DIR}
            COMMAND ${GIT_PROG} clone ${${BDTB}_REPO_URL} ${name})

    endif()
endfunction()