cmake_minimum_required(VERSION 3.1.0)
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
if(xmakeI_QT5_SHARED_PREFIX)
    if(NOT EXISTS ${xmakeI_QT5_SHARED_PREFIX})
        set(wmsg " Qt5 Shared Search Path Not Exist: ${xmakeI_QT5_SHARED_PREFIX}")
        set(wmsg "${wmsg}\n Try the platform system ones ...")
        foreach(item ${CMAKE_C_IMPLICIT_LINK_DIRECTORIES})
            set(sdirs "${sdirs} C   => ${item}\n")
        endforeach()
        foreach(item ${CMAKE_CXX_IMPLICIT_LINK_DIRECTORIES})
            set(sdirs "${sdirs} CPP => ${item}\n")
        endforeach()
        foreach(item ${CMAKE_PLATFORM_IMPLICIT_LINK_DIRECTORIES})
            set(sdirs "${sdirs} SYS => ${item}\n")
        endforeach()
        if(sdirs)
            set(wmsg "${wmsg}\n${sdirs}")
        endif()
        message(WARNING "${wmsg}")
        set(xmakeI_QT5_SYSTEM_PREFIX TRUE)
    else()
        list(INSERT CMAKE_PREFIX_PATH 0 ${xmakeI_QT5_SHARED_PREFIX})
    endif()
endif()

if(xmakeI_QT5_STATIC_PREFIX)
    if(NOT EXISTS ${xmakeI_QT5_STATIC_PREFIX})
        set(wmsg " Qt5 Static Search Path Not Exist: ${xmakeI_QT5_STATIC_PREFIX}")
        set(wmsg "${wmsg}\n Try the platform system ones ...")
        foreach(item ${CMAKE_C_IMPLICIT_LINK_DIRECTORIES})
            set(sdirs "${sdirs} C   => ${item}\n")
        endforeach()
        foreach(item ${CMAKE_CXX_IMPLICIT_LINK_DIRECTORIES})
            set(sdirs "${sdirs} CPP => ${item}\n")
        endforeach()
        foreach(item ${CMAKE_PLATFORM_IMPLICIT_LINK_DIRECTORIES})
            set(sdirs "${sdirs} SYS => ${item}\n")
        endforeach()
        if(sdirs)
            set(wmsg "${wmsg}\n${sdirs}")
        endif()
        message(WARNING "${wmsg}")
        set(xmakeI_QT5_SYSTEM_PREFIX TRUE)
    else()
        list(INSERT CMAKE_PREFIX_PATH 0 ${xmakeI_QT5_STATIC_PREFIX})
    endif()
endif()

if(NOT xmakeI_QT5_SHARED_PREFIX AND NOT xmakeI_QT5_STATIC_PREFIX)
    set(xmakeI_QT5_SYSTEM_PREFIX TRUE)
endif()

if(NOT ${XMAKE}_DEBUG_BUILD)
    # Q_ASSERT(cond)                => QT_NO_DEBUG
    # Q_ASSERT_X(cond, where, what) => QT_NO_DEBUG
    # Q_CHECK_PTR(ptr)              => QT_NO_DEBUG & QT_NO_EXCEPTIONS
    # https://doc.qt.io/qt-5/qtglobal.html
    add_definitions("-DQT_NO_DEBUG")
    add_definitions("-DQT_NO_EXCEPTIONS")
endif()

# find the Qt root directory
find_package(Qt5Core REQUIRED)
set(Qt5_SDK_VERSION "${Qt5Core_VERSION}")
get_filename_component(Qt5_SDK_ROOT_DIR "${Qt5Core_DIR}/../../.." ABSOLUTE)
message(STATUS "Qt5 SDK Version: ${Qt5_SDK_VERSION}")
message(STATUS "Qt5 SDK RootDir: ${Qt5_SDK_ROOT_DIR}")

# TODO: to find a better way for check static Qt5
if(EXISTS "${Qt5_SDK_ROOT_DIR}/lib/libQt5Core.a")
    set(xmakeI_QT5_STATIC_PREFIX "${Qt5_SDK_ROOT_DIR}")
endif()

# For circular dependencies
list(APPEND ${XMAKE}_QT5_LIBRARIES -Wl,--start-group)

if(NOT HOST_WINDOWS)
    find_package(Threads) # FindThreads.cmake
    list(APPEND ${XMAKE}_QT5_LIBRARIES ${CMAKE_THREAD_LIBS_INIT})
endif()

# https://doc.qt.io/QtForDeviceCreation/qtee-static-linking.html
if(xmakeI_QT5_STATIC_PREFIX)
    include(xmake/Qt5Static)
    include(xmake/Qt5StaticPlugin)
else()
    function(XmakeQt5StaticPluginSrcAdd TARGET)
        # Nothing Todo
    endfunction()
endif()

# For circular dependencies
list(APPEND ${XMAKE}_QT5_LIBRARIES -Wl,--end-group)

# It's safe to remove the duplicated ones for circular dependencies link flags
list(REMOVE_DUPLICATES ${XMAKE}_QT5_LIBRARIES)

if(false)
    foreach(item ${${XMAKE}_QT5_LIBRARIES})
        message(STATUS "Qt5Lib: ${item}")
    endforeach()
    message(FATAL_ERROR "STOP")
endif()
