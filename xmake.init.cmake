# The xmake version to downloaded
set(xmakeVersion "v1.1.0") # This is the tag version string
set(xmakeTarballSHA256 # The tarball SHA256 to checking
    "cedefafd2b328d6613effc715ca4ce2ed98ed626bbba055c85fa605596327735"
)

# The xmake tarball file name to download
set(xmakeTarball "xmake-${xmakeVersion}.tar.gz")
# Check if xmake is init or not
set(xmakeInited "${CMAKE_SOURCE_DIR}/cmake/xmake.cmake")
# The local file for save the download xmake tarball
set(xmakeLocalTarball "${CMAKE_SOURCE_DIR}/cmake/${xmakeTarball}")

# Download the xmake tarball
function(xmakeInitDownload)
    if(EXISTS "${xmakeInited}" OR EXISTS "${xmakeLocalTarball}")
        return()
    endif()

    set(timeout 60)
    set(timeout_msg "${timeout} seconds")
    set(timeout_arg INACTIVITY_TIMEOUT ${timeout})

    # The release tarball download base URL
    set(xmakeDownloadUrl "https://github.com/gkide/xmake/releases/download")
    set(xmakeDownloadUrl "${xmakeDownloadUrl}/${xmakeVersion}/${xmakeTarball}")

    message(STATUS "${xmakeTarball}: Downloading ...
   Timeout  = ${timeout_msg}
   From URL = ${xmakeDownloadUrl}
   Save As  = ${xmakeLocalTarball}")

    file(DOWNLOAD ${xmakeDownloadUrl} ${xmakeLocalTarball}
        ${timeout_arg} SHOW_PROGRESS STATUS status LOG errorLog
    )

    list(GET status 0 errorCode)
    list(GET status 1 errorMsg)

    if(errorCode)
        message(FATAL_ERROR "${xmakeTarball}: Downloading failed
Error Code: ${errorCode}
Error String: ${errorMsg}
Error Log: ${errorLog}")
    endif()
endfunction()

# Checking SHA256
function(xmakeInitSha256Check)
    if(EXISTS "${xmakeInited}")
        return()
    endif()

    if(NOT EXISTS "${xmakeLocalTarball}")
        message(FATAL_ERROR "NOT exist ${xmakeLocalTarball}")
    endif()

    message(STATUS "${xmakeTarball}: Checking SHA256 ...")
    file(SHA256 ${xmakeLocalTarball} ActualSHA256) # Get tarball actual SHA256

    set(NullSHA256
        "0000000000000000000000000000000000000000000000000000000000000000")
    set(EmptySHA256
        "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855")

    if(ActualSHA256 STREQUAL "${EmptySHA256}")
        # File was empty. It's likely due to lack of SSL support.
        file(REMOVE ${xmakeLocalTarball})
        message(FATAL_ERROR "Failed to download ${xmakeLocalTarball}.
The file is empty and likely means CMake was built without SSL support.
Please use a version of CMake with proper SSL support and try again.")
    elseif((NOT xmakeTarballSHA256 STREQUAL NullSHA256)
           AND (NOT xmakeTarballSHA256 STREQUAL ActualSHA256))
        # Was not a NULL SHA256 and did not match
        file(REMOVE ${xmakeLocalTarball})
        message(FATAL_ERROR "Checking SHA256 failed, remove it and try again.
Actually SHA256: ${ActualSHA256}
Expected SHA256: ${xmakeTarballSHA256}")
    endif()
endfunction()

# Extracting tarball and setup
function(xmakeInitExtractSetup)
    if(EXISTS "${xmakeInited}")
        return()
    endif()

    if(NOT EXISTS "${xmakeLocalTarball}")
        message(FATAL_ERROR "NOT exist ${xmakeLocalTarball}")
    endif()

    set(xmakeExtractLocation ${CMAKE_SOURCE_DIR}/cmake)
    message(STATUS "${xmakeTarball}: Extracting ...
   SRC = ${xmakeLocalTarball}
   DST = ${xmakeExtractLocation}")

    execute_process(COMMAND ${CMAKE_COMMAND} -E
        tar xzf ${xmakeLocalTarball}
        WORKING_DIRECTORY ${xmakeExtractLocation}
        RESULT_VARIABLE extract_status
    )

    if(NOT extract_status EQUAL 0)
        message(STATUS "${xmakeTarball}: Extracting ... error clean up")
        file(REMOVE_RECURSE "${xmakeExtractLocation}")
        message(FATAL_ERROR "Error: failed extract ${xmakeLocalTarball}")
    endif()

    message(STATUS "${xmakeTarball}: Setup and clean ...")
    set(xmakeTmpDir ${xmakeExtractLocation}/xmake-${xmakeVersion})
    file(COPY ${xmakeTmpDir}/cmake/xmake
        DESTINATION ${CMAKE_SOURCE_DIR}/cmake)
    file(COPY ${xmakeTmpDir}/cmake/xmake.cmake
        DESTINATION ${CMAKE_SOURCE_DIR}/cmake)
    file(REMOVE_RECURSE "${xmakeTmpDir}")
    file(REMOVE ${xmakeLocalTarball})
endfunction()

if(EXISTS "${xmakeInited}")
    include(xmake) # include xmake
else()
    xmakeInitDownload()
    xmakeInitSha256Check()
    xmakeInitExtractSetup()
endif()
