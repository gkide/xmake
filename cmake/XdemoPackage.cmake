# Host Arch: x86 or x86_64
string(REGEX REPLACE "^([x864_]+).*$" "\\1"
    ARCH "${CMAKE_C_LIBRARY_ARCHITECTURE}")

# For preparing a package
set(CPACK_SET_DESTDIR true)
# The binary package files: stripping all
set(CPACK_STRIP_FILES true)
# The source package files: do NOT stripping
set(CPACK_SOURCE_STRIP_FILES false)
# The packing working directory
set(CPACK_PACKAGE_DIRECTORY "${CMAKE_BINARY_DIR}/Release")

if(HOST_WINDOWS)
    # source package generator
    set(CPACK_SOURCE_GENERATOR "")
    # binary package generator: x86 & x86_64
    set(CPACK_GENERATOR "NSIS;NSIS64")
else() # Linux & MacOS
    # source package generator: tar.gz
    set(CPACK_SOURCE_GENERATOR "TGZ")
    # binary package generator: tar.gz, .sh
    set(CPACK_GENERATOR "TGZ;STGZ")
endif()

# Name of project and vendor
set(CPACK_PACKAGE_NAME "xdemo")
set(CPACK_PACKAGE_VENDOR "GKIDE")
set(CPACK_PACKAGE_DESCRIPTION_SUMMARY
    "cmake & make quick project template!")

set(CPACK_PACKAGE_VERSION_MAJOR "${XDEMO_VERSION_MAJOR}")
set(CPACK_PACKAGE_VERSION_MINOR "${XDEMO_VERSION_MINOR}")
set(CPACK_PACKAGE_VERSION_PATCH "${XDEMO_VERSION_PATCH}")
string(APPEND PKG_VERSION "${XDEMO_VERSION_MAJOR}.")
string(APPEND PKG_VERSION "${XDEMO_VERSION_MINOR}.")
string(APPEND PKG_VERSION "${XDEMO_VERSION_PATCH}")

# The binary package name, not including the extension
set(CPACK_PACKAGE_FILE_NAME
    "${CPACK_PACKAGE_NAME}-${PKG_VERSION}-${CMAKE_HOST_SYSTEM_NAME}-${ARCH}")
# The source package name, not including the extension
set(CPACK_SOURCE_PACKAGE_FILE_NAME
    "${CPACK_PACKAGE_NAME}-${XDEMO_RELEASE_VERSION}")
# The source package ignored file regex patterns
set(CPACK_SOURCE_IGNORE_FILES
    # local config/debug files
    ${CMAKE_SOURCE_DIR}/*.log
    ${CMAKE_SOURCE_DIR}/*.txt.user
    ${CMAKE_SOURCE_DIR}/.gitignore
    ${CMAKE_SOURCE_DIR}/local.mk
    # repo & tools directories
    ${CMAKE_SOURCE_DIR}/.git/
    ${CMAKE_SOURCE_DIR}/.svn/
    ${CMAKE_SOURCE_DIR}/.deps/
    ${CMAKE_SOURCE_DIR}/.github/
    ${CMAKE_SOURCE_DIR}/.standard-release/
    # local development directories
    ${CMAKE_SOURCE_DIR}/*/tmp/*
    ${CMAKE_SOURCE_DIR}/*/temp/*
    ${CMAKE_SOURCE_DIR}/*/todo/*
    ${CMAKE_SOURCE_DIR}/*/build/*
)

if(HOST_WINDOWS)
    # Make sure there is at least one set of four (4) backslashes.
    # This is a bug in NSIS that does not handle full unix paths properly.

    # The install prefix
    set(CPACK_PACKAGE_INSTALL_DIRECTORY "gkide")

    # The brand image displayed on the top of the installer.
    set(CPACK_PACKAGE_ICON "${CMAKE_SOURCE_DIR}\\\\gkide.png")
    set(CPACK_RESOURCE_FILE_LICENSE "${CMAKE_SOURCE_DIR}\\\\LICENSE")
    set(CPACK_RESOURCE_FILE_README "${CMAKE_SOURCE_DIR}\\\\README.md")
    #set(CPACK_RESOURCE_FILE_WELCOME "")

    # TODO: how can change the start menu to GKIDE/xdemo
    # Display name is used for the installer and as start menu folder.
    set(CPACK_NSIS_DISPLAY_NAME "xdemo")
    # create start menu entries for executables
    set(CPACK_PACKAGE_EXECUTABLES xdemo;xdemo)

    # The ICON file for the generated install program.
    set(CPACK_NSIS_MUI_ICON "${CMAKE_SOURCE_DIR}\\\\docs\\\\res\\\\install.ico")
    # The ICON file for the generated uninstall program.
    set(CPACK_NSIS_MUI_UNIICON "${CMAKE_SOURCE_DIR}\\\\docs\\\\res\\\\uninstall.ico")

    # Set the icon used for the Windows "Add or Remove Programs" tool.
    set(CPACK_NSIS_INSTALLED_ICON_NAME "bin\\\\helloworld.exe")

    set(CPACK_NSIS_CONTACT "1213charlie@163.com")
    set(CPACK_NSIS_HELP_LINK "https://github.com/gkide/xmake")
    set(CPACK_NSIS_URL_INFO_ABOUT "https://github.com/gkide/xmake")
else()
    # The brand image displayed on the top of the GUI installer.
    set(CPACK_PACKAGE_ICON "${CMAKE_SOURCE_DIR}/gkide.png")
    set(CPACK_RESOURCE_FILE_LICENSE "${CMAKE_SOURCE_DIR}/LICENSE")
    set(CPACK_RESOURCE_FILE_README "${CMAKE_SOURCE_DIR}/README.md")

    # Info for debian packages
    set(CPACK_PACKAGE_CONTACT "1213charlie@163.com")
    set(CPACK_DEBIAN_PACKAGE_MAINTAINER "GKIDE")
endif()

include(CPack)
