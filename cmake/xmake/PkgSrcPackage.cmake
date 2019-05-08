# project name, logo, vendor, maintainer, summory
set(CPACK_PACKAGE_NAME "${PKG_NAME}")
set(CPACK_PACKAGE_ICON "${PKG_LOGO}")
set(CPACK_PACKAGE_VENDOR "${PKG_VENDOR}")
set(CPACK_PACKAGE_CONTACT "${PKG_MAINTAINER_EMAIL}")
set(CPACK_PACKAGE_DESCRIPTION_SUMMARY "${PKG_BRIEF_SUMMARY}")

set(CPACK_PACKAGE_VERSION_MAJOR "${XDEMO_VERSION_MAJOR}")
set(CPACK_PACKAGE_VERSION_MINOR "${XDEMO_VERSION_MINOR}")
set(CPACK_PACKAGE_VERSION_PATCH "${XDEMO_VERSION_PATCH}")

set(CPACK_DEBIAN_PACKAGE_MAINTAINER "${PKG_MAINTAINER_EMAIL}")
set(CPACK_PACKAGE_INSTALL_DIRECTORY "${PKG_NAME}-${PKG_VERSION}")

# The source package name, not including the extension
set(CPACK_SOURCE_PACKAGE_FILE_NAME "${PKG_NAME}-${PKG_VERSION}")

# The binary package name, not including the extension
set(CPACK_PACKAGE_FILE_NAME "${PKG_NAME}-${PKG_VERSION}-${HOST_SYSTEM_NAME}-${HOST_ARCH}")

if(EXISTS ${CMAKE_SOURCE_DIR}/LICENSE)
    set(CPACK_RESOURCE_FILE_LICENSE "${CMAKE_SOURCE_DIR}/LICENSE")
elseif(EXISTS ${CMAKE_SOURCE_DIR}/COPYRIGHT)
    set(CPACK_RESOURCE_FILE_LICENSE "${CMAKE_SOURCE_DIR}/COPYRIGHT")
endif()

if(EXISTS ${CMAKE_SOURCE_DIR}/DESCRIPTION)
    set(CPACK_PACKAGE_DESCRIPTION_FILE "${CMAKE_SOURCE_DIR}/DESCRIPTION")
elseif(EXISTS ${CMAKE_SOURCE_DIR}/LICENSE)
    set(CPACK_PACKAGE_DESCRIPTION_FILE "${CMAKE_SOURCE_DIR}/LICENSE")
endif()

set(CPACK_GENERATOR "TGZ;STGZ")
set(CPACK_SOURCE_GENERATOR "TGZ")

# Windows Installers
if(HOST_WINDOWS)
    set(CPACK_SOURCE_GENERATOR "")

    if(HOST_ARCH_32)
        set(CPACK_GENERATOR "NSIS")
    else()
        set(CPACK_GENERATOR "NSIS64")
    endif()

    if(HOST_ARCH_32)
        # Root install directory, displayed to end user at installer-run time
        set(CPACK_NSIS_INSTALL_ROOT "$PROGRAMFILES")
        # "NSIS Package Display Name", text used in the installer GUI
        set(CPACK_NSIS_PACKAGE_NAME "${PKG_NAME} ${PKG_VERSION} WIN64")
    else()
        set(CPACK_NSIS_INSTALL_ROOT "$PROGRAMFILES64")
        set(CPACK_NSIS_PACKAGE_NAME "${PKG_NAME} ${PKG_VERSION} WIN32")
    endif()
    # Registry key used to store info about the installation
    set(CPACK_PACKAGE_INSTALL_REGISTRY_KEY "${CPACK_NSIS_PACKAGE_NAME}")
endif()

# The source package files do NOT stripping
set(CPACK_SOURCE_STRIP_FILES false)

# The binary package files to strip
GetInstalledBinaries(installed_binaries)
if(installed_binaries)
    set(CPACK_STRIP_FILES ${installed_binaries})
endif()

if(false)
    foreach(item ${installed_binaries})
        message(STATUS "Install: ${item}")
    endforeach()
endif()

# The source package ignored file regex patterns
set(CPACK_SOURCE_IGNORE_FILES
    # version control files
    "/\\\\.svn/"
    "/\\\\.git/"
    "/\\\\.github/"
    "/\\\\.gitignore$"
    "/\\\\.hooks-config$"
    "/\\\\.gitattributes$"

    # generated temp files
    "/#"
    "~$"
    "\\\\.#"
    "\\\\.swp$"
    "\\\\.swap$"

    # local log/config/debug files
    "\\\\.log$"
    "^local\\\\.mk$"
    "^CMakeLists\\\\.txt\\\\.user$"
    "/\\\\.standard-release/"

    # build and external-deps directory
    "/build/"
    "/\\\\.deps/"

    # Extra common regular temporary files
    "/tmp/"
    "/temp/"
    "/todo/"
)

# Set the options file that needs to be included
configure_file("${CMAKE_CURRENT_LIST_DIR}/CPackOptions.cmake.in"
    "${CMAKE_BINARY_DIR}/CPackOptions.cmake" @ONLY)
set(CPACK_PROJECT_CONFIG_FILE "${CMAKE_BINARY_DIR}/CPackOptions.cmake")

# For preparing a package
set(CPACK_SET_DESTDIR true)

# The packing working directory
set(CPACK_PACKAGE_DIRECTORY "${CMAKE_BINARY_DIR}/ReleasePackage")

include(CPack)
