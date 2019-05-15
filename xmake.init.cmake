# The xmake version to downloaded
set(xmakeVersion v1.0.0-dev) # This is the tag version string

# The xmake tarball file name to download
set(xmakeTarball "xmake-${xmakeVersion}.tar.gz")
# The local file for save the download xmake tarball
set(xmakeLocalTarball "${CMAKE_SOURCE_DIR}/cmake/${xmakeTarball}")
# The release tarball download base URL
set(xmakeDownloadUrl "https://github.com/gkide/xmake/releases/download")

# check if xmake is init or not
set(xmakeInited "${CMAKE_SOURCE_DIR}/cmake/xmake.cmake")

if(NOT EXISTS "${xmakeInited}" OR xmakeForceUpdate)
    file(DOWNLOAD "${xmakeDownloadUrl}/${xmakeVersion}/${xmakeTarball}"
        "${xmakeLocalTarball}"
        STATUS status
    )

    list(GET status 0 rc)
    list(GET status 1 msg)

    if(rc)
        message(FATAL_ERROR "Download ${xmakeTarball} failed")
    endif()
endif()
