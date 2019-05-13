set(${XMAKE}_INSTALL_DIR ${CMAKE_INSTALL_PREFIX})

# - If a full path (with a leading slash or drive letter) is, used it directly.
# - If a relative path is given, relative to the value of CMAKE_INSTALL_PREFIX
set(${XMAKE}_INSTALL_BIN_DIR bin)
set(${XMAKE}_INSTALL_ETC_DIR etc)
set(${XMAKE}_INSTALL_DOC_DIR doc)
set(${XMAKE}_INSTALL_LIB_DIR lib)
set(${XMAKE}_INSTALL_SHA_DIR share)
set(${XMAKE}_INSTALL_PLG_DIR plugin)
set(${XMAKE}_INSTALL_INC_DIR include)

# If installed targets' default RPATH is NOT system implicit link
# directories, then reset it to the cmake install library directory
list(FIND CMAKE_PLATFORM_IMPLICIT_LINK_DIRECTORIES "${CMAKE_INSTALL_RPATH}" isSysDir)
if(NOT ${XMAKE}_SKIP_RPATH_ORIGIN AND "${isSysDir}" STREQUAL "-1")
    # For installed target's property INSTALL_RPATH
    # https://www.technovelty.org/linux/exploring-origin.html
    list(APPEND CMAKE_INSTALL_RPATH "$ORIGIN/../lib")
endif()

if(false) # xmake debug message
    message(STATUS "${XMAKE}_INSTALL_BIN_DIR=${${XMAKE}_INSTALL_BIN_DIR}")
    message(STATUS "${XMAKE}_INSTALL_ETC_DIR=${${XMAKE}_INSTALL_ETC_DIR}")
    message(STATUS "${XMAKE}_INSTALL_DOC_DIR=${${XMAKE}_INSTALL_DOC_DIR}")
    message(STATUS "${XMAKE}_INSTALL_LIB_DIR=${${XMAKE}_INSTALL_LIB_DIR}")
    message(STATUS "${XMAKE}_INSTALL_SHA_DIR=${${XMAKE}_INSTALL_SHA_DIR}")
    message(STATUS "${XMAKE}_INSTALL_PLG_DIR=${${XMAKE}_INSTALL_PLG_DIR}")
    message(STATUS "${XMAKE}_INSTALL_INC_DIR=${${XMAKE}_INSTALL_INC_DIR}")
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
    # message(STATUS \"X0=${usr_dir_DESTINATION}\")
    set(dir_perm \"${usr_dir_DIRECTORY_PERMISSIONS}\")
    set(dest_dir \"${CMAKE_INSTALL_PREFIX}/${usr_dir_DESTINATION}\")

    #######################################################################
    # file(INSTALL ...) implicitly respects DESTDIR, but EXISTS does not. #
    #######################################################################

    set(prev_dir)
    # message(STATUS \"X1=\$ENV{DESTDIR}\${dest_dir}\")
    while(NOT EXISTS \$ENV{DESTDIR}\${dest_dir}
          AND NOT \"\${prev_dir}\" STREQUAL \"\${dest_dir}\")
        # message(STATUS \"X2=\${dest_dir}\")
        list(APPEND parent_dirs \${dest_dir})
        set(prev_dir \${dest_dir})
        get_filename_component(dest_dir \${dest_dir} PATH)
    endwhile()

    if(parent_dirs)
        list(REVERSE parent_dirs)
    endif()

    # message(STATUS \"X3=\${parent_dirs}\")
    foreach(dest_dir \${parent_dirs})
        # message(STATUS \"X4=\${dest_dir}\")
        if(NOT IS_DIRECTORY \${dest_dir})
            # NOTE: a relative destination is evaluated
            # with respect to the current build directory
            file(INSTALL FILES \"\"
                TYPE DIRECTORY
                DESTINATION \${dest_dir}
                DIR_PERMISSIONS \${dir_perm})
        endif()
    endforeach()
    ")
endfunction()

set(installed_binaries "")
function(XmakeGetInstallBinaries BINS)
    set(${BINS} "${installed_binaries}" PARENT_SCOPE)
endfunction()

# The install components: Runtime, Develop, Resource
function(XmakeInstallHelper)
    cmake_parse_arguments(install_helper # prefix
        "" # options
        "DESTINATION;DIRECTORY;RENAME;DOMAIN" # one value keywords
        # multi value keywords
        "FILES;PROGRAMS;TARGETS;DIRECTORY_PERMISSIONS;FILE_PERMISSIONS"
        ${ARGN})

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

    if(install_helper_DOMAIN AND
       NOT "${install_helper_DOMAIN}" MATCHES "^[A-Za-z0-9]+$")
        message(FATAL_ERROR "DOMAIN must consist of [A-Za-z0-9]")
    endif()

    if(install_helper_TARGETS)
        if(install_helper_DESTINATION)
            # The install layout controled by end user
            set(DomainBin ${install_helper_DESTINATION})
            set(DomainLib ${install_helper_DESTINATION})
            set(DomainShare ${install_helper_DESTINATION})
            set(DomainInclude ${install_helper_DESTINATION})
        else()
            # The default install layout
            set(DomainBin ${${XMAKE}_INSTALL_BIN_DIR})
            set(DomainLib ${${XMAKE}_INSTALL_LIB_DIR})
            set(DomainShare ${${XMAKE}_INSTALL_SHA_DIR})
            set(DomainInclude ${${XMAKE}_INSTALL_INC_DIR})
        endif()

        if(install_helper_DOMAIN)
            set(DomainBin ${DomainBin}/${install_helper_DOMAIN})
            set(DomainLib ${DomainLib}/${install_helper_DOMAIN})
            set(DomainShare ${DomainShare}/${install_helper_DOMAIN})
            set(DomainInclude ${DomainInclude}/${install_helper_DOMAIN})
        endif()

        string(REGEX REPLACE " +" ";"
               install_targets "${install_helper_TARGETS}")
        foreach(target ${install_targets}) # processed target one by one
            get_target_property(target_type ${target} TYPE)
            get_target_property(target_resources ${target} RESOURCE)
            get_target_property(macosx_bundle ${target} MACOSX_BUNDLE)

            set(install_resources)
            if(target_resources)
                if(${XMAKE}_XMAKE_VERBOSE)
                    message(STATUS "${target} resources")
                    string(REGEX REPLACE " +" ";" items "${target_resources}")
                    string(REGEX REPLACE "${CMAKE_INSTALL_PREFIX}/" ""
                           resource_directory "${DomainShare}/resource")
                    foreach(item ${items}) # pretty output message
                        message(STATUS "* ${item} => ${resource_directory}")
                    endforeach()
                endif()
                CreateDestDirWithPerms(DESTINATION ${DomainShare}/resource)
                set(install_resources RESOURCE
                    DESTINATION ${DomainShare}/resource COMPONENT Resource)
            endif()

            if(target_type STREQUAL EXECUTABLE) # Executable
                # Create directory with the correct permissions.
                CreateDestDirWithPerms(DESTINATION ${DomainBin})

                if(HOST_MACOS AND macosx_bundle)
                    # install(TARGETS ${target}
                    #    BUNDLE DESTINATION ...
                    #    COMPONENT Runtime)
                    message(FATAL_ERROR "MACOSX: Executable")
                else()
                    install(TARGETS ${target}
                        RUNTIME DESTINATION ${DomainBin} COMPONENT Runtime
                        ${install_resources})
                endif()

                set(installed_binaries "${installed_binaries}"
                    "EXE => ${DomainBin}/${target}" PARENT_SCOPE)

                if(${XMAKE}_XMAKE_VERBOSE)
                    string(REGEX REPLACE "${CMAKE_INSTALL_PREFIX}/" ""
                        bin_directory "${DomainBin}")
                    message(STATUS "${target} Executable => ${bin_directory}")
                endif()

                continue()
            endif()

            if(target_type STREQUAL STATIC_LIBRARY)
                set(lib_type "Static Library")
            elseif(target_type STREQUAL SHARED_LIBRARY)
                set(lib_type "Shared Library")
            elseif(target_type STREQUAL MODULE_LIBRARY)
                set(lib_type "Module Library")
            elseif(target_type STREQUAL INTERFACE_LIBRARY)
                set(lib_type "Interface Library")
            endif()

            if(${XMAKE}_XMAKE_VERBOSE)
                string(REGEX REPLACE "${CMAKE_INSTALL_PREFIX}/" ""
                    lib_directory "${DomainLib}")
                message(STATUS "${target} ${lib_type} => ${lib_directory}")
            endif()

            get_target_property(public_headers ${target} PUBLIC_HEADER)
            get_target_property(private_headers ${target} PRIVATE_HEADER)

            set(install_public_headers)
            if(public_headers)
                if(${XMAKE}_XMAKE_VERBOSE)
                    message(STATUS "${target} Library Public Headers")
                    string(REGEX REPLACE " +" ";" items "${public_headers}")
                    string(REGEX REPLACE "${CMAKE_INSTALL_PREFIX}/" ""
                        public_inc_directory "${DomainInclude}")
                    foreach(item ${items}) # pretty output message
                        message(STATUS "* ${item} => ${public_inc_directory}")
                    endforeach()
                endif()
                CreateDestDirWithPerms(DESTINATION ${DomainInclude})
                set(install_public_headers PUBLIC_HEADER
                    DESTINATION ${DomainInclude} COMPONENT Develop)
            endif()

            set(install_private_headers)
            if(private_headers)
                if(${XMAKE}_XMAKE_VERBOSE)
                    message(STATUS "${target} Library Private Headers")
                    string(REGEX REPLACE " +" ";" items "${private_headers}")
                    string(REGEX REPLACE "${CMAKE_INSTALL_PREFIX}/" ""
                        private_inc_directory "${DomainInclude}/private")
                    foreach(item ${items}) # pretty output message
                        message(STATUS "* ${item} => ${private_inc_directory}")
                    endforeach()
                endif()
                CreateDestDirWithPerms(DESTINATION ${DomainInclude}/private)
                set(install_private_headers PRIVATE_HEADER
                    DESTINATION ${DomainInclude}/private COMPONENT Develop)
            endif()

            # Create directory with the correct permissions.
            CreateDestDirWithPerms(DESTINATION ${DomainLib})

            get_target_property(macosx_framework ${target} FRAMEWORK)
            if(HOST_MACOS AND macosx_framework)
                # install(TARGETS ${target}
                #    FRAMEWORK DESTINATION
                #    COMPONENT Runtime)
                message(FATAL_ERROR "MACOSX: framework shared libraries")
            else()
                install(TARGETS ${target} ${install_resources}
                    # Shared Library(DLL)
                    RUNTIME DESTINATION ${DomainBin} COMPONENT Runtime
                    # Module Library, Shared Library(non-DLL)
                    LIBRARY DESTINATION ${DomainLib} COMPONENT Runtime
                    # Static Library, Shared Import Library(DLL)
                    ARCHIVE DESTINATION ${DomainLib} COMPONENT Develop
                    ${install_public_headers} ${install_private_headers})
            endif()

            set(installed_binaries "${installed_binaries}"
                "LIB => ${DomainLib}/${target}" PARENT_SCOPE)
        endforeach()

        return()
    endif()

    # install to the install prefix root directory
    if(NOT install_helper_DESTINATION)
        # NOTE DESTINATION can not empty though if want to install to
        # the root of CMAKE_INSTALL_PREFIX, just go up-level and down
        # to make it happy and it works.
        get_filename_component(top_dir ${CMAKE_INSTALL_PREFIX} NAME)
        set(install_helper_DESTINATION "../${top_dir}")
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
            DIRECTORY_PERMISSIONS ${install_helper_DIRECTORY_PERMISSIONS}
            COMPONENT Resource)
    endif()

    if(install_helper_RENAME)
        set(install_rename RENAME ${install_helper_RENAME})
    endif()

    if(install_helper_FILES)
        install(
            FILES ${install_helper_FILES}
            DESTINATION ${install_helper_DESTINATION}
            PERMISSIONS ${install_helper_FILE_PERMISSIONS}
            COMPONENT Resource ${install_rename})
    endif()

    if(install_helper_PROGRAMS)
        install(
            PROGRAMS ${install_helper_PROGRAMS}
            DESTINATION ${install_helper_DESTINATION}
            PERMISSIONS ${install_helper_PROGRAM_PERMISSIONS}
            COMPONENT Resource ${install_rename})
    endif()
endfunction()
