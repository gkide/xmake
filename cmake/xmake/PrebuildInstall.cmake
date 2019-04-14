include(CMakeParseArguments)

# Download & Install Prebuild Binary
function(PrebuildInstall name)
    cmake_parse_arguments(bin # prefix
        "SKIP;REPO;TARBALL" # options
        "URL;SHA256;VERSION" # one value keywords
        "PATCH_CMD;INSTALL_CMD" # multi value keywords
        ${ARGN})

    if(bin_SKIP)
        return() # skip download & install
    endif()

    if(NOT bin_REPO AND NOT bin_TARBALL)
        message(FATAL_ERROR "Must set REPO or TARBALL for ${name}.")
    endif()

    if(NOT bin_URL)
        message(FATAL_ERROR "Must set URL for ${name}.")
    endif()

    if(NOT bin_INSTALL_CMD)
        message(FATAL_ERROR "Must set INSTALL_CMD for ${name}.")
    endif()

    if(NOT bin_PATCH_CMD)
        set(bin_PATCH_CMD "")
    endif()

    if(bin_TARBALL)
        # Download tarball, extract, and install the prebuild binary
        BuildDepsTarball(${name}
            VERSION     ${bin_VERSION}
            URL         ${bin_URL}
            SHA256      ${bin_SHA256}
            PATCH_CMD   ${bin_PATCH_CMD}
            INSTALL_CMD ${bin_INSTALL_CMD}
        )
        return()
    endif()

    # Download git repo, and install the prebuild binary
    BuildDepsRepo(  ${name}
        REPO_URL    ${bin_URL}
        PATCH_CMD   ${bin_PATCH_CMD}
        INSTALL_CMD ${bin_INSTALL_CMD}
    )

    #list(APPEND THIRD_PARTY_DEPS ${_bin_TARGET})
endfunction()
