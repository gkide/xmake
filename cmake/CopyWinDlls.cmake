function(CopyInstallDlls_qt5app)
    # Step1. run 'ldd' on the target to get all needed dlls
    execute_process(COMMAND ldd qt5app # qt5app is the build target
        OUTPUT_STRIP_TRAILING_WHITESPACE
        RESULT_VARIABLE isLddOk
        OUTPUT_VARIABLE dllsDepsText
        WORKING_DIRECTORY ${CMAKE_BINARY_DIR}/${buildType}/bin
    )

    if(NOT isLddOk EQUAL 0)
        message(FATAL_ERROR "ldd qt5app ERROR, STOP")
    endif()

    # Step2. parssing the ldd output, found what dll need to copy
    # write output text to a file for debug usage
    #file(WRITE ${CMAKE_BINARY_DIR}/${buildType}/bin/abc.txt "${dllsDepsText}")

    # convert to cmake list format for easy to process
    string(REPLACE "\n\r" ";" dllsDepsText "${dllsDepsText}")
    string(REPLACE "\n" ";" dllsDepsText "${dllsDepsText}")

    foreach(line ${dllsDepsText})
        # message(STATUS "LINE=[${line}]")
        # Get dll name and referenced file full path
        string(REGEX MATCH "^( *\t*)([^=>]*)( *\t*)=>( *\t*)([^\\(]*).*$"
            match_result "${line}")
        set(dll_name "${CMAKE_MATCH_2}")
        set(dll_file "${CMAKE_MATCH_5}")

        # Remove leading/trailing white spaces
        string(REGEX MATCH "^( *\t*)([^ \t]+)( *\t*)$"
            match_result "${dll_name}")
        set(dll_name "${CMAKE_MATCH_2}")
        string(REGEX MATCH "^( *\t*)([^ \t]+)( *\t*)$"
            match_result "${dll_file}")
        set(dll_file "${CMAKE_MATCH_2}")

        # SKIP the system ones, which start by '/c/Windows'
        string(REGEX MATCH "^/c/Windows/.*$"
            is_windows_dll "${dll_file}")
        if(is_windows_dll)
            #message(STATUS "WIN DLL=[${dll_name}] => [${dll_file}]")
            continue()
        endif()

        # CMAKE_BINARY_DIR may leading with a drive char, fix this
        string(REGEX MATCH "^([A-Za-z]):(.*)$"
            has_drive_char "${CMAKE_BINARY_DIR}")
        if(has_drive_char)
            string(TOLOWER "${CMAKE_MATCH_1}" win_drive)
            set(usr_build_dir "/${win_drive}${CMAKE_MATCH_2}")
        else()
            set(usr_build_dir "${CMAKE_BINARY_DIR}")
        endif()

        # SKIP the BUILD ones, which start by '${usr_build_dir}'
        string(REGEX MATCH "^${usr_build_dir}/.*$"
            is_build_dll "${dll_file}")
        if(is_build_dll)
            #message(STATUS "USR DLL=[${dll_name}] => [${dll_file}]")
            continue()
        endif()

        #message(STATUS "CIL DLL=[${dll_name}] => [${dll_file}]")
        list(APPEND copy_dlls_list ${dll_file})
    endforeach()

    # Step3. copy and install DLLS file as needed
    foreach(dll_file ${copy_dlls_list})
        #message(STATUS "CI DLL => [${dll_file}]")
        # Find the full path, which start by 'X:/'
        get_filename_component(dll_fname ${dll_file} NAME)
        list(APPEND copy_install_dlls "${WIN_DLLS_DIR}/${dll_fname}")
    endforeach()

    # Step4. Just do it
    AutoCopyInstallFiles(
        FILES       "${copy_install_dlls}"
        INS_DEST    "${XDEMO_INSTALL_BIN_DIR}"
        CPY_TARGET  "copy-dlls-for-qt5app"
        CPY_DEST    "${CMAKE_BINARY_DIR}/${buildType}/bin"
    )
endfunction()

if(NOT QT5_STATIC_PREFIX AND (QT5_SHARED_PREFIX OR QT5_AUTOMATIC))
    if(EXISTS ${CMAKE_BINARY_DIR}/${buildType}/bin/qt5app.exe)
        CopyInstallDlls_qt5app()
    endif()
endif()