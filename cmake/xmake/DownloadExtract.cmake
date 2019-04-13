# DownloadExtract(TARGET ...
#    URL ...
#    EXPECTED_SHA256 ...
#    DOWNLOAD_TO ...
#    EXTRACT_TO ...
#    FORCE)
function(DownloadExtract)
    cmake_parse_arguments(_def
        "FORCE" # Force download & extract if already done
        "URL;TARGET;EXPECTED_SHA256;DOWNLOAD_TO;EXTRACT_TO"
        ""
        ${ARGN})

    if(NOT _def_TARGET) # Download/Extract target
        message(FATAL_ERROR "TARGET must be passed.")
    endif()

    if(NOT _def_URL) # Target download URL
        message(FATAL_ERROR "URL must be passed.")
    endif()

    if(NOT _def_EXPECTED_SHA256) # Expected target SHA256
        option(SKIP_SHA256_CHECKING "Skip check target's SHA256" ON)
    endif()

    set(DOWNLOAD_TO "${DEPS_DOWNLOAD_DIR}/${_def_TARGET}")
    if(_def_DOWNLOAD_TO) # Target download directory
        set(DOWNLOAD_TO "${_def_DOWNLOAD_TO}/${_def_TARGET}")
    endif()

    set(SOURCE_DIR "${DEPS_BUILD_DIR}/${_def_TARGET}")
    if(_def_EXTRACT_TO) # Target extract directory
        set(SOURCE_DIR "${_def_EXTRACT_TO}/${_def_TARGET}")
    endif()

    file(MAKE_DIRECTORY "${DOWNLOAD_TO}")

    ###############
    # Downloading #
    ###############
    # Parse URL to get file name
    string(REGEX MATCH "[^/\\?]*$" fname "${_def_URL}")
    if(NOT "${fname}" MATCHES "(\\.|=)(bz2|tar|tgz|tar\\.gz|zip)$")
        string(REGEX MATCH "([^/\\?]+(\\.|=)(bz2|tar|tgz|tar\\.gz|zip))/.*$"
               match_result "${_def_URL}")
        set(fname "${CMAKE_MATCH_1}")
    endif()

    if(NOT "${fname}" MATCHES "(\\.|=)(bz2|tar|tgz|tar\\.gz|zip)$")
        message(FATAL_ERROR "Not found tarball filename from URL: ${_def_URL}")
    endif()

    string(REPLACE ";" "-" fname "${fname}")
    set(SRC_TARBALL ${DOWNLOAD_TO}/${fname})

    # If tarball exists, if not force then do nothing
    if(EXISTS "${SRC_TARBALL}")
        if(_def_FORCE)
            message(STATUS "Downloading ... skip")
            message(STATUS "Exists ${SRC_TARBALL}")
        else()
            return()
        endif()
    else()
        set(timeout 60)
        set(timeout_msg "${timeout} seconds")
        set(timeout_arg INACTIVITY_TIMEOUT ${timeout})
        message(STATUS "Downloading ...
   Timeout  = ${timeout_msg}
   From URL = ${_def_URL}
   Save As  = ${SRC_TARBALL}")

        file(DOWNLOAD ${_def_URL} ${SRC_TARBALL}
            ${timeout_arg}
            SHOW_PROGRESS
            STATUS status
            LOG log)

        list(GET status 0 status_code)
        list(GET status 1 status_string)

        if(NOT status_code EQUAL 0)
            message(FATAL_ERROR "Error: failed downloading from ${_def_URL}
Status Code: ${status_code}
Status String: ${status_string}
Log: ${log}")
        endif()
        message(STATUS "Downloading ... done.")
    endif()
    message(STATUS "")

    ############
    # Checking #
    ############
    if(SKIP_SHA256_CHECKING)
        message(STATUS "Checking SHA256 skip.")
    else()
        message(STATUS "Checking HASH256 ...")
        set(NULL_SHA256
            "0000000000000000000000000000000000000000000000000000000000000000")
        set(EMPTY_SHA256
            "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855")

        # Get the tarball actual SHA256
        file(SHA256 ${SRC_TARBALL} ACTUAL_SHA256)
        if(ACTUAL_SHA256 STREQUAL "${EMPTY_SHA256}")
            # File was empty. It's likely due to lack of SSL support.
            file(REMOVE ${SRC_TARBALL})
            message(FATAL_ERROR "Failed to download ${_def_URL}.
The file is empty and likely means CMake was built without SSL support.
Please use a version of CMake with proper SSL support and try again.")
        elseif((NOT _def_EXPECTED_SHA256 STREQUAL NULL_SHA256)
               AND (NOT _def_EXPECTED_SHA256 STREQUAL ACTUAL_SHA256))
            # Was not a NULL SHA256 and did not match
            file(REMOVE ${SRC_TARBALL})
            message(FATAL_ERROR "Checking HASH256 failed, remove it and try again.
Actual HASH256  : ${ACTUAL_SHA256}
Expected HASH256: ${_def_EXPECTED_SHA256}")
        endif()
        message(STATUS "Checking HASH256 ... done.")
    endif()
    message(STATUS "")

    ##############
    # Extracting #
    ##############
    message(STATUS "Extracting ...
   SRC = ${SRC_TARBALL}
   DST = ${SOURCE_DIR}")
    message(STATUS "")

    if(NOT EXISTS "${SRC_TARBALL}")
        message(FATAL_ERROR "Error: extract file does not exist ${SRC_TARBALL}")
    endif()

    # Prepare a space for extracting
    set(i 123) # For tmp directory suffix
    while(EXISTS "${SOURCE_DIR}/../ex-${_def_TARGET}-${i}")
        math(EXPR i "${i} + 1")
    endwhile()
    set(tmp_dir "${SOURCE_DIR}/../ex-${_def_TARGET}-${i}")
    file(MAKE_DIRECTORY "${tmp_dir}")

    # Extract it
    execute_process(COMMAND ${CMAKE_COMMAND} -E
        tar xzf ${SRC_TARBALL}
        WORKING_DIRECTORY ${tmp_dir}
        RESULT_VARIABLE extract_status)

    if(NOT extract_status EQUAL 0)
        message(STATUS "Extracting ... error clean up")
        file(REMOVE_RECURSE "${tmp_dir}")
        message(FATAL_ERROR "Error: failed extract ${SRC_TARBALL}")
    endif()

    # Analyze what came out from the extracting
    message(STATUS "extracting ... analysis")
    file(GLOB contents "${tmp_dir}/*")
    list(LENGTH contents files_nums)

    if(NOT files_nums EQUAL 1 OR NOT IS_DIRECTORY "${contents}")
        set(contents "${tmp_dir}") # All files in tmp directory
    endif()

    # Move source files to the final directory
    message(STATUS "Extracting ... rename/move")
    file(REMOVE_RECURSE ${SOURCE_DIR})
    get_filename_component(contents ${contents} ABSOLUTE)
    file(RENAME ${contents} ${SOURCE_DIR})

    # Clean up:
    message(STATUS "Extracting ... clean up")
    file(REMOVE_RECURSE "${tmp_dir}")

    message(STATUS "Extracting ... done.")
endfunction()
