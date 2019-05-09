Qt5SupportSetup(
    AUTOMATIC ${QT5_AUTOMATIC}
    STATIC_PREFIX ${QT5_STATIC_PREFIX}
    SHARED_PREFIX ${QT5_SHARED_PREFIX}
)

# Find Qt5 library
find_package(Qt5Gui CONFIG REQUIRED)
find_package(Qt5Widgets CONFIG REQUIRED)
find_package(Qt5Network CONFIG REQUIRED)

# Populate a CMake variable with the sources
set(qt5app_SRCS
    main.cpp
    mainwindow.ui
    mainwindow.cpp
)

add_executable(qt5app WIN32
    ${qt5app_SRCS}
    ${XDEMO_AUTO_QT5_SOURCES}
)

# Use the Widgets module from Qt5
target_link_libraries(qt5app
    Qt5::Widgets
    Qt5::Network
    ${XDEMO_AUTO_QT5_LIBRARIES}
)

InstallHelper(TARGETS qt5app)
