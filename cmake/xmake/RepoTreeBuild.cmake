include(CMakeParseArguments)

function(XmakeDepRepoBuild name)
    cmake_parse_arguments(repo # prefix
        "" # options
        "REPO_URL" # one value keywords
        "PATCH_CMD;CONFIG_CMD;BUILD_CMD;INSTALL_CMD" # multi value keywords
        ${ARGN})

    if(NOT repo_REPO_URL)
        message(FATAL_ERROR "Must set REPO_URL for ${name}.")
    endif()

    if(NOT repo_CONFIG_CMD AND
       NOT repo_BUILD_CMD AND
       NOT repo_INSTALL_CMD)
        message(FATAL_ERROR
            "Must set one of CONFIG_CMD, BUILD_CMD, INSTALL_CMD for ${name}.")
    endif()

    if(NOT repo_PATCH_CMD)
        set(repo_PATCH_CMD "")
    endif()

    if(NOT repo_CONFIG_CMD)
        set(repo_CONFIG_CMD "")
    endif()

    if(NOT repo_BUILD_CMD)
        set(repo_BUILD_CMD "")
    endif()

    if(NOT repo_INSTALL_CMD)
        set(repo_INSTALL_CMD "")
    endif()

    set(BuildDir ${DEPS_BUILD_DIR}/${name})
    set(RepoDir ${DEPS_DOWNLOAD_DIR}/${name})

    ExternalProject_Add(   ${name}
        # General
        PREFIX             ${DEPS_BUILD_DIR}
        STAMP_DIR          ${BuildDir}-stamp
        # Download
        DOWNLOAD_DIR       ${DEPS_DOWNLOAD_DIR}
        DOWNLOAD_COMMAND   ${CMAKE_COMMAND}
            -E copy_directory ${RepoDir} ${BuildDir}
        # Patch
        PATCH_COMMAND      "${repo_PATCH_CMD}"
        # Configure
        SOURCE_DIR         "${BuildDir}"
        CONFIGURE_COMMAND  "${repo_CONFIG_CMD}"
        # Build
        BINARY_DIR         "${BuildDir}"
        BUILD_COMMAND      "${repo_BUILD_CMD}"
        # Install
        INSTALL_DIR        "${DEPS_INSTALL_DIR}"
        INSTALL_COMMAND    "${repo_INSTALL_CMD}"
    )

    if(NOT (EXISTS ${RepoDir} AND IS_DIRECTORY ${RepoDir}
            AND EXISTS ${RepoDir}/.git AND IS_DIRECTORY ${RepoDir}/.git))
        ExternalProject_Add_Step(${name} ${name}-repo-clone
            COMMENT "git clone ${repo_REPO_URL} ${name}"
                WORKING_DIRECTORY ${DEPS_DOWNLOAD_DIR}
            COMMAND ${GIT_PROG} clone ${repo_REPO_URL} ${name}
        )
    endif()
endfunction()
