# Package Configuration

set(PKG_NAME "xmake")
#set(PKG_VERSION)
#set(PKG_LICENSE)
#set(PKG_TYPE_GUI)
#set(PKG_MANUAL_DIR)
#set(PKG_DOXYGEN_SOURCE)
#set(PKG_DOXYGEN_EXCLUDES)

set(PKG_VENDOR "GKIDE")
set(PKG_BRIEF_SUMMARY "cmake and make project quick template!")
set(PKG_REPO "https://github.com/gkide/xmake")
set(PKG_BUG_REPORT "https://github.com/gkide/xmake/issues")
set(PKG_MAINTAINER_EMAIL "Charlie WONG <1213charlie@163.com>")
set(PKG_LOGO ${CMAKE_SOURCE_DIR}/gkide.png)
set(PKG_DOC_HELP "doc/manual/index.html")

set(PKG_SOURCE_EXCLUDES
    ${CMAKE_SOURCE_DIR}/docs
    ${CMAKE_SOURCE_DIR}/scripts
    ${CMAKE_SOURCE_DIR}/source

    ${CMAKE_SOURCE_DIR}/LICENSE
    ${CMAKE_SOURCE_DIR}/Makefile
    ${CMAKE_SOURCE_DIR}/local.mk
    ${CMAKE_SOURCE_DIR}/TODOS.md
    ${CMAKE_SOURCE_DIR}/README.md
    ${CMAKE_SOURCE_DIR}/gkide.png
    ${CMAKE_SOURCE_DIR}/CHANGELOG.md
    ${CMAKE_SOURCE_DIR}/CMakeLists.txt
    ${CMAKE_SOURCE_DIR}/DistRepoInfo

    ${CMAKE_SOURCE_DIR}/xmake.init.mk
    ${CMAKE_SOURCE_DIR}/xmake.init.cmake

    ${CMAKE_SOURCE_DIR}/cmake/BuildLibok.cmake
    ${CMAKE_SOURCE_DIR}/cmake/CopyWinDlls.cmake
    ${CMAKE_SOURCE_DIR}/cmake/InstallAstyle.cmake
    ${CMAKE_SOURCE_DIR}/cmake/PkgConfig.cmake
    ${CMAKE_SOURCE_DIR}/cmake/PkgInstaller.cmake
)

# make the release xmake package include the repo info
file(COPY ${CMAKE_SOURCE_DIR}/DistRepoInfo
    DESTINATION ${CMAKE_SOURCE_DIR}/cmake/xmake
)
