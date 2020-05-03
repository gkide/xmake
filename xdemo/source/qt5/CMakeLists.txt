if(NOT DEMO_RUN_QT5)
    return()
endif()

if(XDEMO_SYSTEM_QT5)
    set(XDEMO_SYSTEM_QT5 SEARCH_SYSTEM)
endif()

XmakeQt5SupportSetup(${XDEMO_SYSTEM_QT5}
    STATIC_PREFIX ${QT5_STATIC_PREFIX}
    SHARED_PREFIX ${QT5_SHARED_PREFIX}
)

# Find Qt5 library
# https://doc.qt.io/qt-5/cmake-manual.html#variable-reference
find_package(Qt5Gui CONFIG REQUIRED)
find_package(Qt5Widgets CONFIG REQUIRED)
find_package(Qt5Network CONFIG REQUIRED)

if(false)
    message(STATUS "Qt5Widgets_FOUND=[${Qt5Widgets_FOUND}]")
    message(STATUS "Qt5Widgets_VERSION=[${Qt5Widgets_VERSION}]")
    message(STATUS "Qt5Widgets_LIBRARIES=[${Qt5Widgets_LIBRARIES}]")
    message(STATUS "Qt5Widgets_INCLUDE_DIRS=[${Qt5Widgets_INCLUDE_DIRS}]")
    message(STATUS "Qt5Widgets_DEFINITIONS=[${Qt5Widgets_DEFINITIONS}]")
    message(STATUS "Qt5Widgets_COMPILE_DEFINITIONS=[${Qt5Widgets_COMPILE_DEFINITIONS}]")
    message(STATUS "Qt5Widgets_EXECUTABLE_COMPILE_FLAGS=[${Qt5Widgets_EXECUTABLE_COMPILE_FLAGS}]")

    # Installation variables
    # https://doc.qt.io/qt-5/cmake-manual.html#installation-variables
    message(STATUS "QT_LIBINFIX=[${QT_LIBINFIX}]")
    message(STATUS "QT_VISIBILITY_AVAILABLE=[${QT_VISIBILITY_AVAILABLE}]")
endif()

# Populate a CMake variable with the sources
set(qt5app_SRCS
    app.qrc
    main.cpp
    mainwindow.ui
    mainwindow.cpp
)

# Qt5 Macros
# https://doc.qt.io/qt-5/cmake-manual.html#macro-reference
# NOTE
# Those cmake macros can be found in the Qt5 installation directory:
# <Qt5 Install Prefix>/lib/cmake

# Create C++ code from a list of Qt resource files. By use output sources,
# the related Qt resources hard-coded into the binary executalbe.
#
# qt5_add_resources(
#   OutfilesVar             The converted output C++ source file
#   QrcFile1 QrcFile2 ...   The list of Qt resource files
#   OPTIONS                 The extra args for rcc(Qt Resource Compiler)
# )
qt5_add_resources(QRC_FILE app.qrc # => qrc_app.cpp
    OPTIONS --verbose
)

# Create an RCC file from a list of Qt resource files. Output a binary file
# for use as a dynamic resource. See 'rcc --help' of '--binary' option
#
# qt5_add_binary_resources(
#   target                  The target to create RCC binary file
#   QrcFile1 QrcFile2 ...   The list of Qt resource files
#   OPTIONS ...             The extra args for rcc(Qt Resource Compiler)
#   DESTINATION ...         The RCC binary file location
# )
qt5_add_binary_resources(app-resource # => app-resource.rcc
    app.qrc
    OPTIONS --verbose
)

add_executable(qt5app WIN32 MACOSX_BUNDLE
    # https://forum.qt.io/topic/97983/multiple-definition-of-qinitresources_
    # ${QRC_FILE} This file will automatically added when add .qrc
    ${qt5app_SRCS}
)
XmakeQt5StaticPluginSrcAdd(qt5app)
# Use the Widgets module from Qt5
target_link_libraries(qt5app
    Qt5::Widgets
    Qt5::Network
    ${XDEMO_QT5_LIBRARIES}
)

XmakeInstallHelper(TARGETS qt5app)
XmakeCopyWinAppDlls(qt5app)
