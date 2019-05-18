function(XmakeDownloadExtract)
    cmake_parse_arguments(tarball
        ""
        "URL;TARGET;EXPECTED_SHA256;DOWNLOAD_TO;EXTRACT_TO"
        ""
        ${ARGN}
    )

    if(NOT tarball_TARGET) # Download/Extract target
        message(FATAL_ERROR "TARGET must be passed.")
    endif()

    if(NOT tarball_URL) # Target download URL
        message(FATAL_ERROR "URL must be passed.")
    endif()

    if(NOT tarball_EXPECTED_SHA256) # Expected target SHA256
        set(tarball_skip_sha256_check ON)
    endif()

    set(DOWNLOAD_TO "${DEPS_DOWNLOAD_DIR}/${tarball_TARGET}")
    if(tarball_DOWNLOAD_TO) # Target download directory
        set(DOWNLOAD_TO "${tarball_DOWNLOAD_TO}/${tarball_TARGET}")
    endif()

    set(SOURCE_DIR "${DEPS_BUILD_DIR}/${tarball_TARGET}")
    if(tarball_EXTRACT_TO) # Target extract directory
        set(SOURCE_DIR "${tarball_EXTRACT_TO}/${tarball_TARGET}")
    endif()

    file(MAKE_DIRECTORY "${DOWNLOAD_TO}")

    ###############
    # Downloading #
    ###############
    # Parse URL to get file name
    string(REGEX MATCH "[^/\\?]*$" fname "${tarball_URL}")
    if(NOT "${fname}" MATCHES "(\\.|=)(bz2|tar|tgz|tar\\.gz|zip)$")
        string(REGEX MATCH "([^/\\?]+(\\.|=)(bz2|tar|tgz|tar\\.gz|zip))/.*$"
               match_result "${tarball_URL}")
        set(fname "${CMAKE_MATCH_1}")
    endif()

    if(NOT "${fname}" MATCHES "(\\.|=)(bz2|tar|tgz|tar\\.gz|zip)$")
        message(FATAL_ERROR "Not found tarball filename from URL: ${tarball_URL}")
    endif()

    string(REPLACE ";" "-" fname "${fname}")
    set(SRC_TARBALL ${DOWNLOAD_TO}/${fname})

    # If tarball exists, if not force then do nothing
    if(EXISTS "${SRC_TARBALL}")
        if(EXISTS ${SOURCE_DIR} AND IS_DIRECTORY ${SOURCE_DIR})
            return()
        endif()

        message(STATUS "${tarball_TARGET}: Downloading ... skip")
        message(STATUS "Exists ${SRC_TARBALL}")
    else()
        set(timeout 60)
        set(timeout_msg "${timeout} seconds")
        set(timeout_arg INACTIVITY_TIMEOUT ${timeout})

        message(STATUS "${tarball_TARGET}: Downloading ...
   Timeout  = ${timeout_msg}
   From URL = ${tarball_URL}
   Save As  = ${SRC_TARBALL}")

        file(DOWNLOAD ${tarball_URL} ${SRC_TARBALL}
            ${timeout_arg}
            SHOW_PROGRESS
            STATUS status
            LOG log)

        list(GET status 0 status_code)
        list(GET status 1 status_string)

        if(NOT status_code EQUAL 0)
            message(FATAL_ERROR "Error: failed downloading from ${tarball_URL}
Status Code: ${status_code}
Status String: ${status_string}
Log: ${log}")
        endif()
    endif()

    ############
    # Checking #
    ############
    if(tarball_skip_sha256_check)
        message(STATUS "${tarball_TARGET}: Checking SHA256 skip.")
    else()
        message(STATUS "${tarball_TARGET}: Checking SHA256 ...")
        file(SHA256 ${SRC_TARBALL} ACTUAL_SHA256) # Get tarball actual SHA256

        set(NULL_SHA256
            "0000000000000000000000000000000000000000000000000000000000000000")
        set(EMPTY_SHA256
            "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855")

        if(ACTUAL_SHA256 STREQUAL "${EMPTY_SHA256}")
            # File was empty. It's likely due to lack of SSL support.
            file(REMOVE ${SRC_TARBALL})
            message(FATAL_ERROR "Failed to download ${tarball_URL}.
The file is empty and likely means CMake was built without SSL support.
Please use a version of CMake with proper SSL support and try again.")
        elseif((NOT tarball_EXPECTED_SHA256 STREQUAL NULL_SHA256)
               AND (NOT tarball_EXPECTED_SHA256 STREQUAL ACTUAL_SHA256))
            # Was not a NULL SHA256 and did not match
            file(REMOVE ${SRC_TARBALL})
            message(FATAL_ERROR "Checking HASH256 failed, remove it and try again.
Actual HASH256  : ${ACTUAL_SHA256}
Expected HASH256: ${tarball_EXPECTED_SHA256}")
        endif()
    endif()

    ##############
    # Extracting #
    ##############
    message(STATUS "${tarball_TARGET}: Extracting ...
   SRC = ${SRC_TARBALL}
   DST = ${SOURCE_DIR}")

    if(NOT EXISTS "${SRC_TARBALL}")
        message(FATAL_ERROR "Error: extract file does not exist ${SRC_TARBALL}")
    endif()

    # Prepare a space for extracting
    set(i 123) # For tmp directory suffix
    while(EXISTS "${SOURCE_DIR}/../ex-${tarball_TARGET}-${i}")
        math(EXPR i "${i} + 1")
    endwhile()
    set(tmp_dir "${SOURCE_DIR}/../ex-${tarball_TARGET}-${i}")
    file(MAKE_DIRECTORY "${tmp_dir}")

    # Extract it
    execute_process(COMMAND ${CMAKE_COMMAND} -E
        tar xzf ${SRC_TARBALL}
        WORKING_DIRECTORY ${tmp_dir}
        RESULT_VARIABLE extract_status
    )

    if(NOT extract_status EQUAL 0)
        message(STATUS "${tarball_TARGET}: Extracting ... error clean up")
        file(REMOVE_RECURSE "${tmp_dir}")
        message(FATAL_ERROR "Error: failed extract ${SRC_TARBALL}")
    endif()

    # Analyze what came out from the extracting
    message(STATUS "${tarball_TARGET}: Extracting ... analysis")
    file(GLOB contents "${tmp_dir}/*")
    list(LENGTH contents files_nums)

    if(NOT files_nums EQUAL 1 OR NOT IS_DIRECTORY "${contents}")
        set(contents "${tmp_dir}") # All files in tmp directory
    endif()

    # Move source files to the final directory
    message(STATUS "${tarball_TARGET}: Extracting ... rename/move")
    file(REMOVE_RECURSE ${SOURCE_DIR})
    get_filename_component(contents ${contents} ABSOLUTE)
    file(RENAME ${contents} ${SOURCE_DIR})

    # Clean up:
    message(STATUS "${tarball_TARGET}: Extracting ... clean up")
    file(REMOVE_RECURSE "${tmp_dir}")
endfunction()
