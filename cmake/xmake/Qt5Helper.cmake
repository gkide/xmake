# https://doc.qt.io/qt-5/cmake-manual.html
cmake_minimum_required(VERSION 3.1.0)

# Create code from a list of Qt designer ui files
set(CMAKE_AUTOUIC ON)

# Instruct CMake to run moc automatically when needed
set(CMAKE_AUTOMOC ON)

# Automatically adds directory to the include path
# - CMAKE_CURRENT_SOURCE_DIR
# - CMAKE_CURRENT_BINARY_DIR
# Find includes in corresponding build & source directories
set(CMAKE_INCLUDE_CURRENT_DIR ON)

if(XMAKE_QT5_SHARED_PREFIX AND NOT EXISTS XMAKE_QT5_SHARED_PREFIX)
    set(wmsg " Qt5 Shared Search Path Not Exist: ${XMAKE_QT5_SHARED_PREFIX}")
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
endif()

if(false)
if(XMAKE_QT5_STATIC_PREFIX AND NOT EXISTS XMAKE_QT5_STATIC_PREFIX)
    #message(WARNING "Qt5 Static Search Path Not Exist: ${XMAKE_QT5_STATIC_PREFIX}")
endif()

message(STATUS "==============================================================")
message(STATUS "C_IMPLICIT_LINK_LIBRARIES=${CMAKE_C_IMPLICIT_LINK_LIBRARIES}")
message(STATUS "C_IMPLICIT_LINK_DIRECTORIES=${CMAKE_C_IMPLICIT_LINK_DIRECTORIES}")
message(STATUS "C_IMPLICIT_INCLUDE_DIRECTORIES=${CMAKE_C_IMPLICIT_INCLUDE_DIRECTORIES}")
message(STATUS "==============================================================")
message(STATUS "CXX_IMPLICIT_LINK_LIBRARIES=${CMAKE_CXX_IMPLICIT_LINK_LIBRARIES}")
message(STATUS "CXX_IMPLICIT_LINK_DIRECTORIES=${CMAKE_CXX_IMPLICIT_LINK_DIRECTORIES}")
message(STATUS "CXX_IMPLICIT_INCLUDE_DIRECTORIES=${CMAKE_CXX_IMPLICIT_INCLUDE_DIRECTORIES}")
message(STATUS "==============================================================")
message(STATUS "PLATFORM_IMPLICIT_LINK_LIBRARIES=${CMAKE_PLATFORM_IMPLICIT_LINK_LIBRARIES}")
message(STATUS "PLATFORM_IMPLICIT_LINK_DIRECTORIES=${CMAKE_PLATFORM_IMPLICIT_LINK_DIRECTORIES}")
message(STATUS "PLATFORM_IMPLICIT_INCLUDE_DIRECTORIES=${CMAKE_PLATFORM_IMPLICIT_INCLUDE_DIRECTORIES}")
message(STATUS "==============================================================")
endif()
