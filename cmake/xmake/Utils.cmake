include(CMakeParseArguments)

function(AutoCopyInstallFiles)
    cmake_parse_arguments(auto # prefix
        "" # options
        "INS_DEST;CPY_DEST;CPY_TARGET" # one value keywords
        "FILES;CPY_CMDS_PRE;CPY_CMDS_SUF;" # multi value keywords
        ${ARGN}
    )
    if(NOT auto_FILES)
        message(FATAL_ERROR "must set FILES")
    endif()

    if(NOT auto_INS_DEST AND NOT auto_CPY_DEST)
        message(FATAL_ERROR "must set INS_DEST/CPY_DEST, or both.")
    endif()

    # check if files exist, auto skip the none exists ones
    foreach(file ${auto_FILES})
        # ${file} must be full path to working
        # - for windows, it must be start by 'X:/'
        # - for unix likes, it should be start by '/'
        if(EXISTS ${file})
            list(APPEND auto_files "${file}")
        endif()
    endforeach()

    if(NOT auto_files)
        return()
    endif()

    if(auto_INS_DEST)
        XmakeInstallHelper(FILES ${auto_files} DESTINATION ${auto_INS_DEST})
    endif()

    if(auto_CPY_DEST)
        if(NOT auto_CPY_TARGET)
            message(FATAL_ERROR "must set CPY_TARGET for auto update.")
        endif()

        # do not copy for each build, just do it onece for performance
        foreach(file ${auto_files})
            get_filename_component(fname ${file} NAME)
            if(NOT EXISTS ${auto_CPY_DEST}/${fname})
                message(STATUS "COPY DLL: ${file} => ${auto_CPY_DEST}/${fname}")
                list(APPEND auto_files_todo "${file}")
            endif()
        endforeach()

        if(NOT auto_files_todo)
            return()
        endif()

        # Always update and run for each build
        add_custom_target(${auto_CPY_TARGET} ALL
            COMMAND ${CMAKE_COMMAND} -E make_directory ${auto_CPY_DEST}
            ${auto_CPY_CMDS_PRE} # before copy do something if any
            COMMAND ${CMAKE_COMMAND} -E copy ${auto_files_todo} ${auto_CPY_DEST}
            ${auto_CPY_CMDS_SUF} # after copy do something if any
        )
    endif()
endfunction()
