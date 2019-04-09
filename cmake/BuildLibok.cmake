set(LIBOK_VERSION 1.0.4)
set(LIBOK_URL "https://github.com/gkide/ok/archive/v1.0.4.tar.gz")
set(LIBOK_SHA256 "b001fa83bbe963c32ba952ea2d678f92fe1646fc8b43419386012c0c21046820")

DownloadExtract(TARGET "libok"
    URL "${LIBOK_URL}"
    EXPECTED_SHA256 "${LIBOK_SHA256}")

ExternalProject_Add(    libok
    PREFIX              ${DEPS_BUILD_DIR}
    DOWNLOAD_DIR        ${DEPS_DOWNLOAD_DIR}
    SOURCE_DIR          ${DEPS_BUILD_DIR}/libok
    BINARY_DIR          ${DEPS_BUILD_DIR}/libok
    STAMP_DIR           ${DEPS_BUILD_DIR}/libok-stamp
    INSTALL_DIR         ${DEPS_INSTALL_DIR}
    CONFIGURE_COMMAND   ""
    BUILD_COMMAND       ${GNU_MAKE}
        BUILD_TYPE=${CMAKE_BUILD_TYPE}
        INSTALL_PERFIX=${DEPS_INSTALL_DIR}
    INSTALL_COMMAND     ${GNU_MAKE} install
)

set(LIBOK_LIBRARY ${DEPS_INSTALL_DIR}/lib/libok.a)
