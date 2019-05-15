include(CMakeParseArguments)

function(XmakeDepTarballBuild name)
    cmake_parse_arguments(tarball # prefix
        "" # options
        "URL;SHA256;VERSION" # one value keywords
        "PATCH_CMD;CONFIG_CMD;BUILD_CMD;INSTALL_CMD" # multi value keywords
        ${ARGN})

    if(NOT tarball_VERSION)
        message(FATAL_ERROR "Must set VERSION for ${name}.")
    endif()

    if(NOT tarball_URL)
        message(FATAL_ERROR "Must set URL for ${name}.")
    endif()

    if(NOT tarball_SHA256)
        message(FATAL_ERROR "Must set SHA256 for ${name}.")
    endif()

    if(NOT tarball_CONFIG_CMD AND
       NOT tarball_BUILD_CMD AND
       NOT tarball_INSTALL_CMD)
        message(FATAL_ERROR
            "Must set one of CONFIG_CMD, BUILD_CMD, INSTALL_CMD for ${name}.")
    endif()

    if(NOT tarball_PATCH_CMD)
        set(tarball_PATCH_CMD "")
    endif()

    if(NOT tarball_CONFIG_CMD)
        set(tarball_CONFIG_CMD "")
    endif()

    if(NOT tarball_BUILD_CMD)
        set(tarball_BUILD_CMD "")
    endif()

    if(NOT tarball_INSTALL_CMD)
        set(tarball_INSTALL_CMD "")
    endif()

    DownloadExtract(TARGET "${name}"
        URL "${tarball_URL}"
        EXPECTED_SHA256 "${tarball_SHA256}"
    )

    ExternalProject_Add(    ${name}
        # General
        PREFIX              ${DEPS_BUILD_DIR}
        STAMP_DIR           ${DEPS_BUILD_DIR}/${name}-stamp
        # Download
        DOWNLOAD_DIR        "${DEPS_DOWNLOAD_DIR}"
        # Patch
        PATCH_COMMAND       "${tarball_PATCH_CMD}"
        # Configure
        SOURCE_DIR          "${DEPS_BUILD_DIR}/${name}"
        CONFIGURE_COMMAND   "${tarball_CONFIG_CMD}"
        # Build
        BINARY_DIR          "${DEPS_BUILD_DIR}/${name}"
        BUILD_COMMAND       "${tarball_BUILD_CMD}"
        # Install
        INSTALL_DIR         "${DEPS_INSTALL_DIR}"
        INSTALL_COMMAND     "${tarball_INSTALL_CMD}"
    )
endfunction()
