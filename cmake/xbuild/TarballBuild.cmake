include(CMakeParseArguments)

function(BuildDepsTarball name)
    string(TOUPPER ${name} BDTB)
    cmake_parse_arguments(${BDTB} # prefix
        "" # options
        "VERSION;URL;SHA256" # one_value_keywords
        "PATCH_CMD;CONFIG_CMD;BUILD_CMD;INSTALL_CMD" # multi_value_keywords
        ${ARGN})

    if(NOT ${BDTB}_VERSION)
        message(FATAL_ERROR "Must set VERSION for ${name}.")
    endif()

    if(NOT ${BDTB}_URL)
        message(FATAL_ERROR "Must set URL for ${name}.")
    endif()

    if(NOT ${BDTB}_SHA256)
        message(FATAL_ERROR "Must set SHA256 for ${name}.")
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

    DownloadExtract(TARGET "${name}"
        URL "${${BDTB}_URL}"
        EXPECTED_SHA256 "${${BDTB}_SHA256}")

    ExternalProject_Add(    ${name}
        # General
        PREFIX              ${DEPS_BUILD_DIR}
        STAMP_DIR           ${DEPS_BUILD_DIR}/${name}-stamp
        # Download
        DOWNLOAD_DIR        ${DEPS_DOWNLOAD_DIR}
        # Patch
        PATCH_COMMAND       "${${BDTB}_PATCH_CMD}"
        # Configure
        SOURCE_DIR          ${DEPS_BUILD_DIR}/${name}
        CONFIGURE_COMMAND   "${${BDTB}_CONFIG_CMD}"
        # Build
        BINARY_DIR          ${DEPS_BUILD_DIR}/${name}
        BUILD_COMMAND       "${${BDTB}_BUILD_CMD}"
        # Install
        INSTALL_DIR         ${DEPS_INSTALL_DIR}
        INSTALL_COMMAND     "${${BDTB}_INSTALL_CMD}")
endfunction()
