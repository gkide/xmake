set(USR_PREFIX ${CMAKE_INSTALL_PREFIX}) # install root
set(USR_BINDIR ${CMAKE_INSTALL_PREFIX}/bin) # executable
set(USR_ETCDIR ${CMAKE_INSTALL_PREFIX}/etc) # configuration
set(USR_DOCDIR ${CMAKE_INSTALL_PREFIX}/doc) # documentation
set(USR_LIBDIR ${CMAKE_INSTALL_PREFIX}/lib) # C/C++ library
set(USR_SHADIR ${CMAKE_INSTALL_PREFIX}/share) # share data
set(USR_PLGDIR ${CMAKE_INSTALL_PREFIX}/plugin) # plugin data
set(USR_INCDIR ${CMAKE_INSTALL_PREFIX}/include) # C/C++ header

if(false)
    message(STATUS "USR_BINDIR=${USR_BINDIR}")
    message(STATUS "USR_ETCDIR=${USR_ETCDIR}")
    message(STATUS "USR_DOCDIR=${USR_DOCDIR}")
    message(STATUS "USR_LIBDIR=${USR_LIBDIR}")
    message(STATUS "USR_SHADIR=${USR_SHADIR}")
    message(STATUS "USR_PLGDIR=${USR_PLGDIR}")
    message(STATUS "USR_INCDIR=${USR_INCDIR}")
endif()

# This will create any directories that need to be created in the destination
# path with the owner, group, and user permissions, independent of the umask.
function(CreateDestDirWithPerms)
    cmake_parse_arguments(usr_dir
        ""
        "DESTINATION"
        "DIRECTORY_PERMISSIONS"
        ${ARGN})

    if(NOT usr_dir_DESTINATION)
        message(FATAL_ERROR "Must set DESTINATION")
    endif()

    if(EXISTS ${usr_dir_DESTINATION})
        return()
    endif()

    if(NOT usr_dir_DIRECTORY_PERMISSIONS)
        set(usr_dir_DIRECTORY_PERMISSIONS
            OWNER_READ OWNER_WRITE OWNER_EXECUTE
            GROUP_READ GROUP_EXECUTE
            WORLD_READ WORLD_EXECUTE)
    endif()

    install(CODE
    "
    set(parent_dirs)
    set(dir_perm \"${usr_dir_DIRECTORY_PERMISSIONS}\")
    set(dest_dir \"\${CMAKE_INSTALL_PREFIX}/${usr_dir_DESTINATION}\")

    set(prev_dir)
    while(NOT EXISTS \${dest_dir} AND NOT \${prev_dir} STREQUAL \${dest_dir})
        list(APPEND parent_dirs \${dest_dir})
        set(prev_dir \${dest_dir})
        get_filename_component(dest_dir \${dest_dir} PATH)
    endwhile()

    if(parent_dirs)
        list(REVERSE parent_dirs)
    endif()

    foreach(dest_dir \${parent_dirs})
        if(NOT IS_DIRECTORY \${dest_dir})
            file(INSTALL
                FILES \"\"
                TYPE DIRECTORY
                DESTINATION \${dest_dir}
                DIR_PERMISSIONS \${dir_perm})
        endif()
    endforeach()
    ")
endfunction()

function(InstallHelper)
    cmake_parse_arguments(install_helper
        ""
        "DESTINATION;DIRECTORY;RENAME"
        "FILES;PROGRAMS;TARGETS;DIRECTORY_PERMISSIONS;FILE_PERMISSIONS"
        ${ARGN})

    if(NOT install_helper_DESTINATION AND NOT install_helper_TARGETS)
        message(FATAL_ERROR "Must set TARGETS or DESTINATION")
    endif()

    if(NOT install_helper_FILES
       AND NOT install_helper_TARGETS
       AND NOT install_helper_PROGRAMS
       AND NOT install_helper_DIRECTORY)
        message(FATAL_ERROR "Must set FILES, PROGRAMS, TARGETS, or DIRECTORY")
    endif()

    if(NOT install_helper_FILE_PERMISSIONS)
        set(install_helper_FILE_PERMISSIONS
            OWNER_READ OWNER_WRITE
            GROUP_READ
            WORLD_READ)
    endif()

    if(NOT install_helper_PROGRAM_PERMISSIONS)
        set(install_helper_PROGRAM_PERMISSIONS
            OWNER_READ OWNER_WRITE OWNER_EXECUTE
            GROUP_READ GROUP_EXECUTE
            WORLD_READ WORLD_EXECUTE)
    endif()

    if(NOT install_helper_DIRECTORY_PERMISSIONS)
        set(install_helper_DIRECTORY_PERMISSIONS
            OWNER_READ OWNER_WRITE OWNER_EXECUTE
            GROUP_READ GROUP_EXECUTE
            WORLD_READ WORLD_EXECUTE)
    endif()

    if(install_helper_TARGETS)
        if(install_helper_DESTINATION)
            set(SUBDIR /${install_helper_DESTINATION})
        endif()

        # Create directory with the correct permissions.
        CreateDestDirWithPerms(DESTINATION ${USR_BINDIR}${SUBDIR})
        CreateDestDirWithPerms(DESTINATION ${USR_LIBDIR}${SUBDIR})
        install(TARGETS ${install_helper_TARGETS}
                # Executables, Shared Libraries(DLL)
                RUNTIME DESTINATION ${USR_BINDIR}${SUBDIR}
                # Module Libraries
                LIBRARY DESTINATION ${USR_LIBDIR}${SUBDIR}
                # Static Libraries, Import Libraries(DLL)
                ARCHIVE DESTINATION ${USR_LIBDIR}${SUBDIR})
        return()
    endif()

    # Create directory with the correct permissions.
    CreateDestDirWithPerms(
        DESTINATION ${install_helper_DESTINATION}
        DIRECTORY_PERMISSIONS ${install_helper_DIRECTORY_PERMISSIONS})

    if(install_helper_DIRECTORY)
        install(
            DIRECTORY ${install_helper_DIRECTORY}
            DESTINATION ${install_helper_DESTINATION}
            FILE_PERMISSIONS ${install_helper_FILE_PERMISSIONS}
            DIRECTORY_PERMISSIONS ${install_helper_DIRECTORY_PERMISSIONS})
    endif()

    if(install_helper_RENAME)
        set(RENAME RENAME ${install_helper_RENAME})
    endif()

    if(install_helper_FILES)
        install(
            FILES ${install_helper_FILES}
            DESTINATION ${install_helper_DESTINATION}
            PERMISSIONS ${install_helper_FILE_PERMISSIONS}
            ${RENAME})
    endif()

    if(install_helper_PROGRAMS)
        install(
            PROGRAMS ${install_helper_PROGRAMS}
            DESTINATION ${install_helper_DESTINATION}
            PERMISSIONS ${install_helper_PROGRAM_PERMISSIONS}
            ${RENAME})
    endif()
endfunction()
