set(XDEMO_DOXYGEN_OUTPUT_DIR "${CMAKE_CURRENT_BINARY_DIR}/doxygen")
set(XDEMO_BRIEF_DESCRIPTION "cmake & make quick project template!")
configure_file(
    "${CMAKE_CURRENT_SOURCE_DIR}/Doxyfile.in"
    "${CMAKE_CURRENT_BINARY_DIR}/Doxyfile"
)

if(NOT DOXYGEN_PROG)
    set(DOXYGEN_PROG ${DOXYGEN_EXECUTABLE})
endif()

add_custom_target(doxygen
    COMMENT "Generating Doxygen API Documentation"
    COMMAND ${DOXYGEN_PROG} ${CMAKE_CURRENT_BINARY_DIR}/Doxyfile
)
