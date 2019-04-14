# Find Qt5 QtWidgets library
find_package(Qt5Widgets CONFIG REQUIRED)

# Populate a CMake variable with the sources
set(hello_qt5_SRCS
    main.cpp
    mainwindow.ui
    mainwindow.cpp
)

add_executable(hello-qt5 WIN32 ${hello_qt5_SRCS})

# Use the Widgets module from Qt5
target_link_libraries(hello-qt5 Qt5::Widgets)

InstallHelper(TARGETS hello-qt5)
