cmake_minimum_required(VERSION 3.1.0)

if(NOT ${XMAKE}_DEBUG_BUILD)
    add_definitions(-DQT_NO_DEBUG_OUTPUT)
endif()

# https://doc.qt.io/qt-5/cmake-manual.html
set(CMAKE_CXX_FLAGS_${buildType} "${CMAKE_CXX_FLAGS_${buildType}} -std=c++11")

# Create code from a list of Qt designer ui files
set(CMAKE_AUTOUIC ON)

# Instruct CMake to run moc automatically when needed
set(CMAKE_AUTOMOC ON)

# Handle Qt RCC code generator automatically
set(CMAKE_AUTORCC ON)

# Automatically adds directory to the include path
# CMAKE_CURRENT_SOURCE_DIR, CMAKE_CURRENT_BINARY_DIR
# Find includes in corresponding build & source directories
set(CMAKE_INCLUDE_CURRENT_DIR ON)

if(NOT ${XMAKE}_DEBUG_BUILD)
    # Q_ASSERT(cond)                => QT_NO_DEBUG
    # Q_ASSERT_X(cond, where, what) => QT_NO_DEBUG
    # Q_CHECK_PTR(ptr)              => QT_NO_DEBUG & QT_NO_EXCEPTIONS
    # https://doc.qt.io/qt-5/qtglobal.html
    add_definitions("-DQT_NO_DEBUG")
    add_definitions("-DQT_NO_EXCEPTIONS")
endif()

find_package(PkgConfig REQUIRED)

macro(xmakeI_QT5_IS_VALID QT5_PREFIX IS_STATIC)
    set(ENV{PKG_CONFIG_PATH} "${QT5_PREFIX}/lib/pkgconfig")
    pkg_search_module(_Qt5Core QUIET REQUIRED Qt5Core)

    if(${IS_STATIC})
        message(STATUS "Qt5 SDK Static Version: ${_Qt5Core_VERSION}")
        message(STATUS "Qt5 SDK Static Library: ${_Qt5Core_LIBRARY_DIRS}")
    else()
        message(STATUS "Qt5 SDK Shared Version: ${_Qt5Core_VERSION}")
        message(STATUS "Qt5 SDK Shared Library: ${_Qt5Core_LIBRARY_DIRS}")
    endif()
endmacro()

# Qt Repo Branches
# https://wiki.qt.io/Branches
#
# Qt-Version-Compatibility
# https://wiki.qt.io/Qt-Version-Compatibility
#
# Policies/Binary Compatibility Issues With C++
# https://community.kde.org/Policies/Binary_Compatibility_Issues_With_C%2B%2B

# Download Shared Qt Binary Offline Installer
# http://download.qt.io/official_releases/qt

if(xmakeI_QT5_STATIC_PREFIX)
    if(NOT EXISTS ${xmakeI_QT5_STATIC_PREFIX})
        message(FATAL_ERROR "Qt5 Installation Prefix NOT EXIST, STOP!")
    endif()

    xmakeI_QT5_IS_VALID("${xmakeI_QT5_STATIC_PREFIX}" ON)
    if(NOT EXISTS "${_Qt5Core_LIBRARY_DIRS}/libQt5Core.a")
        message(FATAL_ERROR "NOT Static Qt5 Library, STOP!")
    endif()

    list(INSERT CMAKE_PREFIX_PATH 0 ${xmakeI_QT5_STATIC_PREFIX})

    # find Qt5 by pk-config & find_package
    macro(XmakeQt5FindPackage NAME REQUIRED)
        # message(STATUS "PKG_CONFIG_PATH=$ENV{PKG_CONFIG_PATH}")
        pkg_check_modules(${NAME} QUIET ${REQUIRED} ${NAME})
# https://cmake.org/cmake/help/v3.5/module/FindPkgConfig.html
if(false)
    message(STATUS "${NAME}_STATIC_LIBRARIES=${${NAME}_STATIC_LIBRARIES}")
    message(STATUS "${NAME}_STATIC_LIBRARY_DIRS=${${NAME}_STATIC_LIBRARY_DIRS}")
    message(STATUS "${NAME}_STATIC_LDFLAGS=${${NAME}_STATIC_LDFLAGS}")
    message(STATUS "${NAME}_STATIC_INCLUDE_DIRS=${${NAME}_STATIC_INCLUDE_DIRS}")
    message(STATUS "${NAME}_STATIC_CFLAGS=${${NAME}_STATIC_CFLAGS}")
endif()
        find_package(${NAME} QUIET ${REQUIRED} CONFIG
            NO_DEFAULT_PATH PATHS ${xmakeI_QT5_STATIC_PREFIX}
        )
        string(REPLACE "Qt5" "Qt5::" ${NAME}_LIBRARIES ${NAME})
        list(APPEND ${NAME}_LIBRARIES ${${NAME}_STATIC_LDFLAGS})
        #message(STATUS "${NAME}_LIBRARIES=${${NAME}_LIBRARIES}")
    endmacro()

    # Find all static plugins ld flags
    macro(XmakeQt5FindPlugins Plugins_LdFlags)
        file(GLOB plugin_DIRS LIST_DIRECTORIES true
            ${xmakeI_QT5_STATIC_PREFIX}/plugins/*)
        foreach(plg_DIR ${plugin_DIRS})
            if(NOT IS_DIRECTORY ${plg_DIR})
                continue()
            endif()

            file(GLOB plugin_LIBS ${plg_DIR}/*.a)
            foreach(plg_LIB ${plugin_LIBS})
                #message(STATUS "plg_LIB=[${plg_LIB}]")
                get_filename_component(fname ${plg_LIB} NAME_WE)

                file(STRINGS "${plg_DIR}/${fname}.prl" QMAKE_PRL_LIBS
                    REGEX "QMAKE_PRL_LIBS *= *.*$")
                string(REGEX REPLACE ".*QMAKE_PRL_LIBS *= *"
                    "" QMAKE_PRL_LIBS ${QMAKE_PRL_LIBS})
                string(REPLACE "\$\$[QT_INSTALL_LIBS]"
                    "${xmakeI_QT5_STATIC_PREFIX}" QMAKE_PRL_LIBS ${QMAKE_PRL_LIBS})
                #message(STATUS "QMAKE_PRL_LIBS=[${QMAKE_PRL_LIBS}]")
                set(${Plugins_LdFlags} ${${Plugins_LdFlags}}
                    ${plg_LIB} ${QMAKE_PRL_LIBS})
            endforeach()
        endforeach()
    endmacro()
endif()

if(xmakeI_QT5_SHARED_PREFIX)
    if(NOT EXISTS ${xmakeI_QT5_SHARED_PREFIX})
        message(FATAL_ERROR "Qt5 Installation Prefix NOT EXIST, STOP!")
    endif()

    xmakeI_QT5_IS_VALID("${xmakeI_QT5_SHARED_PREFIX}" OFF)
    if(NOT EXISTS "${_Qt5Core_LIBRARY_DIRS}/libQt5Core.so")
        message(FATAL_ERROR "NOT Shared Qt5 Library, STOP!")
    endif()

    list(INSERT CMAKE_PREFIX_PATH 0 ${xmakeI_QT5_SHARED_PREFIX})

    macro(XmakeQt5FindPackage NAME REQUIRED)
        find_package(${NAME} QUIET ${REQUIRED} CONFIG
            NO_DEFAULT_PATH PATHS ${xmakeI_QT5_SHARED_PREFIX}
        )
        string(REPLACE "Qt5" "Qt5::" ${NAME}_LIBRARIES ${NAME})
        #message(STATUS "${NAME}_LIBRARIES=${${NAME}_LIBRARIES}")
    endmacro()

    macro(XmakeQt5FindPlugins Plugins_LdFlags)
        # Nothing Todo
    endmacro()
endif()

if(xmakeI_QT5_SEARCH_SYSTEM)
    #############################################
    # Multi Arch Spec                           #
    # - https://wiki.ubuntu.com/MultiarchSpec   #
    # - https://err.no/debian/amd64-multiarch-3 #
    #############################################
    if(ARCH_32)
        if(MINGW OR MSYS)
            list(APPEND MultiArchSearchDirs "/usr/lib")
            list(APPEND MultiArchSearchDirs "/mingw32/lib")
        else()
            list(APPEND MultiArchSearchDirs "/lib32")
            list(APPEND MultiArchSearchDirs "/usr/lib32")
            list(APPEND MultiArchSearchDirs "/lib/i386-linux-gnu")
            list(APPEND MultiArchSearchDirs "/usr/lib/i386-linux-gnu")
        endif()
    else()
        if(MINGW OR MSYS)
            list(APPEND MultiArchSearchDirs "/usr/lib")
            list(APPEND MultiArchSearchDirs "/mingw64/lib")
        else()
            list(APPEND MultiArchSearchDirs "/lib64")
            list(APPEND MultiArchSearchDirs "/usr/lib64")
            list(APPEND MultiArchSearchDirs "/lib/x86_64-linux-gnu")
            list(APPEND MultiArchSearchDirs "/usr/lib/x86_64-linux-gnu")
        endif()
    endif()

    find_package(Qt5Core REQUIRED)
    mark_as_advanced(MultiArchSearchDirs)

    foreach(item ${MultiArchSearchDirs})
        if(EXISTS "${item}/libQt5Core.a")
            message(STATUS "Qt5 SDK Static Version: ${Qt5Core_VERSION}")
            message(STATUS "Qt5 SDK Static Library: ${item}")
            break()
        endif()
        if(EXISTS "${item}/libQt5Core.so")
            message(STATUS "Qt5 SDK Shared Version: ${Qt5Core_VERSION}")
            message(STATUS "Qt5 SDK Shared Library: ${item}")
            break()
        endif()
    endforeach()

    macro(XmakeQt5FindPackage NAME REQUIRED)
        find_package(${NAME} QUIET ${REQUIRED})
        string(REPLACE "Qt5" "Qt5::" ${NAME}_LIBRARIES ${NAME})
        #message(STATUS "${NAME}_LIBRARIES=${${NAME}_LIBRARIES}")
    endmacro()

    macro(XmakeQt5FindPlugins Plugins_LdFlags)
        # Nothing Todo
    endmacro()
endif()
