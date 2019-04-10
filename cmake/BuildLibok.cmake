if(true)
    # Download git repo & build
    BuildDepsRepo(libok
        REPO_URL    https://github.com/gkide/ok.git
        BUILD_CMD   ${GNU_MAKE}
            BUILD_TYPE=${DEPS_BUILD_TYPE}
            INSTALL_PERFIX=${DEPS_INSTALL_DIR}
        INSTALL_CMD ${GNU_MAKE} install)
else()
    # Download tarball & build
    BuildDepsTarBall(libok
        VERSION     1.0.4
        URL         https://github.com/gkide/ok/archive/v1.0.4.tar.gz
        SHA256      b001fa83bbe963c32ba952ea2d678f92fe1646fc8b43419386012c0c21046820
        BUILD_CMD   ${GNU_MAKE}
            BUILD_TYPE=${DEPS_BUILD_TYPE}
            INSTALL_PERFIX=${DEPS_INSTALL_DIR}
        INSTALL_CMD ${GNU_MAKE} install)
endif()

set(LIBOK_LIBRARY ${DEPS_INSTALL_DIR}/lib/libok.a)
