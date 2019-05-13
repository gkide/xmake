cmake_minimum_required(VERSION 3.1.0)

set(CMAKE_CXX_FLAGS_${buildType} "${CMAKE_CXX_FLAGS_${buildType}} -std=c++11")

# Create code from a list of Qt designer ui files
set(CMAKE_AUTOUIC ON)

# Instruct CMake to run moc automatically when needed
set(CMAKE_AUTOMOC ON)

# Automatically adds directory to the include path
# CMAKE_CURRENT_SOURCE_DIR, CMAKE_CURRENT_BINARY_DIR
# Find includes in corresponding build & source directories
set(CMAKE_INCLUDE_CURRENT_DIR ON)

if(qt5_SHARED_PREFIX)
    if(NOT EXISTS ${qt5_SHARED_PREFIX})
        set(wmsg " Qt5 Shared Search Path Not Exist: ${qt5_SHARED_PREFIX}")
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
    else()
        list(INSERT CMAKE_PREFIX_PATH 0 ${qt5_SHARED_PREFIX})
        message(STATUS "Qt5 Shared Search Path: ${qt5_SHARED_PREFIX}")
    endif()
endif()

if(qt5_STATIC_PREFIX)
    if(NOT EXISTS ${qt5_STATIC_PREFIX})
        set(wmsg " Qt5 Static Search Path Not Exist: ${qt5_STATIC_PREFIX}")
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
    else()
        list(INSERT CMAKE_PREFIX_PATH 0 ${qt5_STATIC_PREFIX})
        message(STATUS "Qt5 Static Search Path: ${qt5_STATIC_PREFIX}")
    endif()
endif()

if(NOT ${XMAKE}_DEBUG_BUILD)
    # Q_ASSERT(cond)                => QT_NO_DEBUG
    # Q_ASSERT_X(cond, where, what) => QT_NO_DEBUG
    # Q_CHECK_PTR(ptr)              => QT_NO_DEBUG & QT_NO_EXCEPTIONS
    # https://doc.qt.io/qt-5/qtglobal.html
    add_definitions("-DQT_NO_DEBUG")
    add_definitions("-DQT_NO_EXCEPTIONS")
endif()

# This determines the thread library of the system, see 'FindThreads.cmake'
find_package(Threads)

if(qt5_STATIC_PREFIX)
    # Qt5 static qt-plugin
    set(qt5_plugin_moc "${CMAKE_CURRENT_BINARY_DIR}/xmake_qt5_moc.cpp")
    mark_as_advanced(qt5_plugin_moc)
    file(WRITE ${qt5_plugin_moc} "#include <QtPlugin>\n")
    list(APPEND ${XMAKE}_AUTO_QT5_SOURCES ${qt5_plugin_moc})

    if(HOST_WINDOWS)
        file(APPEND ${qt5_plugin_moc}
             "Q_IMPORT_PLUGIN(QWindowsIntegrationPlugin)\n")
    else()
        include(xmake/Qt5Static)
        list(APPEND ${XMAKE}_AUTO_QT5_LIBRARIES ${CMAKE_THREAD_LIBS_INIT})
        file(APPEND ${qt5_plugin_moc}
            "Q_IMPORT_PLUGIN(QXcbIntegrationPlugin)\n")
        file(APPEND ${qt5_plugin_moc} "Q_IMPORT_PLUGIN(QGifPlugin)\n")
        file(APPEND ${qt5_plugin_moc} "Q_IMPORT_PLUGIN(QICNSPlugin)\n")
        file(APPEND ${qt5_plugin_moc} "Q_IMPORT_PLUGIN(QICOPlugin)\n")
        file(APPEND ${qt5_plugin_moc} "Q_IMPORT_PLUGIN(QJpegPlugin)\n")
        file(APPEND ${qt5_plugin_moc} "Q_IMPORT_PLUGIN(QTgaPlugin)\n")
        file(APPEND ${qt5_plugin_moc} "Q_IMPORT_PLUGIN(QTiffPlugin)\n")
        file(APPEND ${qt5_plugin_moc} "Q_IMPORT_PLUGIN(QWbmpPlugin)\n")
        file(APPEND ${qt5_plugin_moc} "Q_IMPORT_PLUGIN(QWebpPlugin)\n")
    endif()
endif()
