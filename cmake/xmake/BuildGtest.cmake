if(true)
    # Download git repo & build
    BuildDepsRepo(  gtest
        REPO_URL    https://github.com/google/googletest.git
        CONFIG_CMD  ${CMAKE_COMMAND} -E make_directory build
            COMMAND cd build && ${CMAKE_COMMAND}
                -DCMAKE_BUILD_TYPE=${DEPS_BUILD_TYPE}
                -DCMAKE_INSTALL_PREFIX=${DEPS_INSTALL_DIR} ..
        BUILD_CMD   ${MAKE_PROG} -C build
        INSTALL_CMD ${MAKE_PROG} -C build install
    )
else()
    # Download tarball & build
    BuildDepsTarball(gtest
        VERSION     1.8.1
        URL         https://github.com/google/googletest/archive/release-1.8.1.tar.gz
        SHA256      9bf1fe5182a604b4135edc1a425ae356c9ad15e9b23f9f12a02e80184c3a249c
        CONFIG_CMD  ${CMAKE_COMMAND} -E make_directory build
            COMMAND cd build && ${CMAKE_COMMAND}
                -DCMAKE_BUILD_TYPE=${DEPS_BUILD_TYPE}
                -DCMAKE_INSTALL_PREFIX=${DEPS_INSTALL_DIR} ..
        BUILD_CMD   ${MAKE_PROG} -C build
        INSTALL_CMD ${MAKE_PROG} -C build install
    )
endif()

set(GTEST_LIBRARY ${DEPS_INSTALL_DIR}/lib/libok.a)
