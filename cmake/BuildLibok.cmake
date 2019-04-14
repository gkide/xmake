if(false)
    # Download git repo & build
    BuildDepsRepo(libok
        REPO_URL    https://github.com/gkide/ok.git
        BUILD_CMD   ${GNU_MAKE}
            BUILD_TYPE=${DEPS_BUILD_TYPE}
            INSTALL_PERFIX=${DEPS_INSTALL_DIR}
        INSTALL_CMD ${GNU_MAKE} install
    )
else()
    # Download tarball & build
    BuildDepsTarball(libok
        VERSION     1.0.5
        URL         https://github.com/gkide/ok/archive/v1.0.5.tar.gz
        SHA256      28de511c368b27e5e3f1ab2bbdac390495e6c2ed324439cd9eff13b1a6a27485
        BUILD_CMD   ${GNU_MAKE}
            BUILD_TYPE=${DEPS_BUILD_TYPE}
            INSTALL_PERFIX=${DEPS_INSTALL_DIR}
        INSTALL_CMD ${GNU_MAKE} install
    )
endif()

set(LIBOK_LIBRARY ${DEPS_INSTALL_DIR}/lib/libok.a)
