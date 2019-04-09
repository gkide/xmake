function(PreventInTreeBuilds)
    get_filename_component(srcdir "${CMAKE_SOURCE_DIR}" REALPATH)
    get_filename_component(bindir "${CMAKE_BINARY_DIR}" REALPATH)

    if("${srcdir}" STREQUAL "${bindir}")
        message("")
        message("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
        message("!              In-source builds are not permitted.             !")
        message("! It's recommended that making a separate folder for building. !")
        message("!                                                              !")
        message("!       $ mkdir build; cd build; cmake <OPTIONS> ...           !")
        message("!       $ rm -rf CMakeCache.txt CMakeFiles                     !")
        message("!                                                              !")
        message("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
        message("")
        message(FATAL_ERROR "Stopping build.")
    endif()
endfunction()

PreventInTreeBuilds()
