add_definitions(-DHOST_NAME=\"${HOST_NAME}\")
add_definitions(-DHOST_USER=\"${HOST_USER}\")
add_definitions(-DHOST_DIST_NAME=\"${HOST_DIST_NAME}\")
add_definitions(-DHOST_DIST_VERSION=\"${HOST_DIST_VERSION}\")

add_definitions(-D${XMAKE}_VERSION_MAJOR=${${XMAKE}_VERSION_MAJOR})
add_definitions(-D${XMAKE}_VERSION_MINOR=${${XMAKE}_VERSION_MINOR})
add_definitions(-D${XMAKE}_VERSION_PATCH=${${XMAKE}_VERSION_PATCH})
add_definitions(-D${XMAKE}_VERSION_TWEAK=\"${${XMAKE}_VERSION_TWEAK}\")

add_definitions(-D${XMAKE}_RELEASE_TYPE=\"${CMAKE_BUILD_TYPE}\")
add_definitions(-D${XMAKE}_RELEASE_VERSION=\"${${XMAKE}_RELEASE_VERSION}\")
add_definitions(-D${XMAKE}_RELEASE_TIMESTAMP=\"${${XMAKE}_RELEASE_TIMESTAMP}\")

if(UNIX)
    add_definitions(-DUNIX)
endif()

if(APPLE)
    add_definitions(-DAPPLE)
endif()

if(WIN32)
    add_definitions(-DWIN32)
endif()

if(MSYS)
    add_definitions(-DMSYS)
endif()

if(MINGW)
    add_definitions(-DMINGW)
endif()

if(CYGWIN)
    add_definitions(-DCYGWIN)
endif()

if(ARCH_32)
    add_definitions(-DARCH_32)
endif()

if(ARCH_64)
    add_definitions(-DARCH_64)
endif()

if(IS_BIG_ENDIAN)
    add_definitions(-DIS_BIG_ENDIAN)
endif()
