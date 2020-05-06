# This file is used by 'build/CPackOptions.cmake', which
# is generated from 'xmake/CPackOptions.cmake.in'

# NOTE
# message(STATUS ...) do not working, don't known why?
# message(WARNING/FATAL_ERROR ...) works, can be used to debug!

if(CPACK_GENERATOR MATCHES "NSIS")
    # This is for to find 'xmake/NSIS.template.in', if not set then
    # try to use the cmake orginal module provided one
    list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_LIST_DIR}/xmake")

    # For windows start menu link create
    # A pair of value list: targetName => menu/linkName
    set(NSIS_MENU_LINKS "bin/xtest.exe" "xtest")
    set(NSIS_INSTALLER_LOGO "${CMAKE_SOURCE_DIR}/docs/res/install.ico")
    set(NSIS_UNINSTALLER_LOGO "${CMAKE_SOURCE_DIR}docs/res/uninstall.ico")
endif()

if(CPACK_GENERATOR MATCHES "IFW")

endif()
