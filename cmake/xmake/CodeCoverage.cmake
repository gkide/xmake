include(CMakeParseArguments)

# Check prereqs
find_program(GCOV_PROG gcov)
find_program(LCOV_PROG NAMES lcov lcov.bat lcov.exe lcov.perl)
find_program(GENHTML_PROG NAMES genhtml genhtml.perl genhtml.bat)

find_program(GCOVR_PROG gcovr)
if(NOT GCOVR_PROG)
    message(WARNING "NOT found gcovr, code coverage skip ...")
    return()
endif()

find_program(PYTHON_PROG python)
if(NOT PYTHON_PROG)
    message(WARNING "NOT found python, code coverage skip ...")
    return()
endif()

if("${CMAKE_CXX_COMPILER_ID}" MATCHES "(Apple)?[Cc]lang"
   AND "${CMAKE_CXX_COMPILER_VERSION}" VERSION_LESS 3)
    message(WARNING "Clang version must be 3.0.0 or greater, code coverage skip ...")
    return()
elseif(NOT CMAKE_COMPILER_IS_GNUCXX)
    message(WARNING "Compiler is not GNU GCC, code coverage skip ...")
    return()
endif()

message(STATUS "Enabling code coverage measurements")
if(NOT CMAKE_BUILD_TYPE STREQUAL "Dev"
   AND NOT CMAKE_BUILD_TYPE STREQUAL "Debug"
   AND NOT CMAKE_BUILD_TYPE STREQUAL "Coverage")
    message(WARNING "Code coverage results of optimised build may be misleading")
endif()

set(CODE_COVERAGE_FLAGS "-g -O0 --coverage -fprofile-arcs -ftest-coverage"
    CACHE INTERNAL "")

set(CMAKE_C_FLAGS_COVERAGE ${CODE_COVERAGE_FLAGS}
    CACHE STRING "The C compiler flags for coverage builds." FORCE)
set(CMAKE_CXX_FLAGS_COVERAGE ${CODE_COVERAGE_FLAGS}
    CACHE STRING "The C++ compiler flags for coverage builds." FORCE)
set(CMAKE_EXE_LINKER_FLAGS_COVERAGE ""
    CACHE STRING "The binaries linking flags for coverage builds." FORCE)
set(CMAKE_SHARED_LINKER_FLAGS_COVERAGE ""
    CACHE STRING "The shared libraries linking flags for coverage builds." FORCE)

mark_as_advanced(
    CMAKE_C_FLAGS_COVERAGE
    CMAKE_CXX_FLAGS_COVERAGE
    CMAKE_EXE_LINKER_FLAGS_COVERAGE
    CMAKE_SHARED_LINKER_FLAGS_COVERAGE
)

if(CMAKE_C_COMPILER_ID STREQUAL "GNU")
    link_libraries(gcov) # For all targets
else()
    set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} --coverage")
endif()

# Defines a target for running and collection code coverage information.
# Builds dependencies first, runs the given executable and outputs reports.
#
# NOTE! The executable should always have a ZERO as exit code otherwise
# the coverage generation will not complete.
#
# - TARGET              Target name, if not set auto set to *.code.coverage
# - EXECUTABLE          Executable to run
# - EXECUTABLE_ARGS     Executable arguments
# - DEPENDENCIES        Dependencies to build first
#
# - LCOV_ARGS           Extra arguments for lcov
# - GENHTML_ARGS        Extra arguments for genhtml
# - LCOV_EXCLUDES       Exclude patterns from the report
#
# Example usage:
# CodeCoverageLcovHtml(
#     TARGET runner_coverage
#     EXECUTABLE runner -j ${PROCESSOR_COUNT}
#     DEPENDENCIES runner-deps
# )
function(CodeCoverageLcovHtml)
    cmake_parse_arguments(cct
        "" # options
        "TARGET" # one value keywords
        # multi value keywords
        "EXECUTABLE;EXECUTABLE_ARGS;DEPENDENCIES;LCOV_ARGS;LCOV_EXCLUDES;GENHTML_ARGS"
        ${ARGN}
    )

    if(NOT LCOV_PROG)
        message(FATAL_ERROR "Code coverage stop, NOT found lcov")
    endif()

    if(NOT GCOV_PROG)
        message(FATAL_ERROR "Code coverage stop, NOT found gcov")
    endif()

    if(NOT GENHTML_PROG)
        message(FATAL_ERROR "Code coverage stop, NOT found genhtml")
    endif()

    if(NOT cct_EXECUTABLE)
        message(FATAL_ERROR "Must set EXECUTABLE for code coverage.")
    endif()

    get_filename_component(runner ${cct_EXECUTABLE} NAME)
    set(output_directory ${PROJECT_BINARY_DIR}/${CMAKE_BUILD_TYPE})

    if(NOT cct_TARGET)
        set(cct_TARGET code.coverage-${runner})
    endif()

    set(based_traceinfo ${output_directory}/${runner}-trace.info.based)
    set(build_traceinfo ${output_directory}/${runner}-trace.info.build)
    set(total_traceinfo ${output_directory}/${runner}-trace.info.total)
    set(clean_traceinfo ${output_directory}/${runner}-trace.info.clean)

    # Generating the INFO/HTML report
    set(html_report ${cct_TARGET}/index.html)
    set(info_report ${CMAKE_BUILD_TYPE}/${runner}-trace.info.build)

    # Setup target
    add_custom_target(${cct_TARGET}
        DEPENDS ${cct_DEPENDENCIES}
        WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
        COMMENT "Processing code coverage counters and generating report."

        # Cleanup lcov
        COMMAND ${LCOV_PROG} ${cct_LCOV_ARGS} --gcov-tool ${GCOV_PROG}
            --directory . --zerocounters
        # Create baseline to make sure untouched files show up in the report
        COMMAND ${LCOV_PROG} ${cct_LCOV_ARGS} --gcov-tool ${GCOV_PROG}
            --capture --initial --directory . --output-file ${based_traceinfo}
        # Run coverage tests
        COMMAND ${cct_EXECUTABLE} ${cct_EXECUTABLE_ARGS}
        # Capturing lcov counters for generating report
        COMMAND ${LCOV_PROG} ${cct_LCOV_ARGS} --gcov-tool ${GCOV_PROG}
            --directory . --capture --output-file ${build_traceinfo}
        # Merget baseline & runners
        COMMAND ${LCOV_PROG} ${cct_LCOV_ARGS} --gcov-tool ${GCOV_PROG}
            --add-tracefile ${based_traceinfo}
            --add-tracefile ${build_traceinfo}
            --output-file ${total_traceinfo}
        # Prepare for cleanup
        COMMAND ${CMAKE_COMMAND} -E copy ${total_traceinfo} ${clean_traceinfo}
        # cleanup
        COMMAND ${CMAKE_COMMAND} -E remove ${based_traceinfo}
    )

    # Exclude the system ones by default
    list(APPEND SKIP_ITEMS ${CMAKE_C_IMPLICIT_INCLUDE_DIRECTORIES})
    list(APPEND SKIP_ITEMS ${CMAKE_CXX_IMPLICIT_INCLUDE_DIRECTORIES})
    list(APPEND SKIP_ITEMS ${CMAKE_PLATFORM_IMPLICIT_INCLUDE_DIRECTORIES})
    foreach(item ${SKIP_ITEMS})
        add_custom_command(TARGET ${cct_TARGET}
            COMMENT "Remove System Counters from HTML report: ${item}"
            POST_BUILD COMMAND ${LCOV_PROG} ${cct_LCOV_ARGS} --gcov-tool ${GCOV_PROG}
                --remove ${clean_traceinfo} '${item}*'
                --output-file ${clean_traceinfo}
        )
    endforeach()
    # Exclude the user given patterns
    foreach(item ${cct_LCOV_EXCLUDES})
        add_custom_command(TARGET ${cct_TARGET}
            COMMENT "Ignore User Counters from HTML report: ${item}"
            POST_BUILD COMMAND ${LCOV_PROG} ${cct_LCOV_ARGS} --gcov-tool ${GCOV_PROG}
                --remove ${clean_traceinfo} '${item}*'
                --output-file ${clean_traceinfo}
        )
    endforeach()

    # Show where to find the lcov info report
    add_custom_command(TARGET ${cct_TARGET}
        POST_BUILD COMMAND ;
        COMMENT "Lcov code coverage INFO report: ${info_report}"
    )
    # Show info where to find the report
    add_custom_command(TARGET ${cct_TARGET}
        COMMENT "Lcov code coverage HTML report: ${html_report}"
        POST_BUILD COMMAND ${GENHTML_PROG} ${cct_GENHTML_ARGS}
            -o ${cct_TARGET} ${clean_traceinfo}
    )
endfunction()

# Defines a target for running and collection code coverage information.
# Builds dependencies first, runs the given executable and outputs reports.
#
# NOTE! The executable should always have a ZERO as exit code otherwise
# the coverage generation will not complete.
#
# - TARGET              Target name, if not set auto set to *.code.coverage
# - EXECUTABLE          Executable to run
# - EXECUTABLE_ARGS     Executable arguments
# - DEPENDENCIES        Dependencies to build first
#
# - LCOV_ARGS           Extra arguments for lcov
# - GENHTML_ARGS        Extra arguments for genhtml
# - LCOV_EXCLUDES       Exclude patterns from the report
#
# CodeCoverageGcovrXml(
#     TARGET ctest_coverage
#     EXECUTABLE ctest -j ${PROCESSOR_COUNT} # Executable in PROJECT_BINARY_DIR
#     DEPENDENCIES executable_target         # Dependencies to build first
# )
function(CodeCoverageGcovrXml)
    cmake_parse_arguments(cct
        ""
        "TARGET"
        "EXECUTABLE;EXECUTABLE_ARGS;DEPENDENCIES;GCOVR_EXCLUDES"
        ${ARGN}
    )

    if(NOT cct_EXECUTABLE)
        message(FATAL_ERROR "Must set EXECUTABLE for code coverage.")
    endif()

    get_filename_component(runner ${cct_EXECUTABLE} NAME)
    set(output_directory ${PROJECT_BINARY_DIR}/${CMAKE_BUILD_TYPE})

    if(NOT cct_TARGET)
        set(cct_TARGET code.coverage-${runner})
    endif()

    # Combine excludes to several -e arguments
    set(gcovr_excludes "")
    foreach(item ${cct_GCOVR_EXCLUDES})
        list(APPEND gcovr_excludes "-e" "${item}")
    endforeach()

    add_custom_target(${cct_TARGET}
        # Clean old coverage data
        COMMAND find ${PROJECT_BINARY_DIR} -type f -iname '*.gcno' -delete

        # Run tests
        COMMAND ${Coverage_EXECUTABLE} ${Coverage_EXECUTABLE_ARGS}

        # Running gcovr
        COMMAND ${GCOVR_PROG} --xml
            -r ${PROJECT_SOURCE_DIR} ${GCOVR_EXCLUDES}
            --object-directory=${PROJECT_BINARY_DIR}
            -o ${cct_TARGET}.xml
        WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
        DEPENDS ${Coverage_DEPENDENCIES}
        COMMENT "Running gcovr to produce Cobertura code coverage report."
    )

    # Show info where to find the report
    add_custom_command(TARGET ${cct_TARGET} POST_BUILD
        COMMAND ;
        COMMENT "Cobertura code coverage report saved in ${cct_TARGET}.xml."
    )
endfunction()

# Defines a target for running and collection code coverage information
# Builds dependencies, runs the given executable and outputs reports.
# NOTE! The executable should always have a ZERO as exit code otherwise
# the coverage generation will not complete.
#
# SETUP_TARGET_FOR_COVERAGE_GCOVR_HTML(
#     NAME ctest_coverage                    # New target name
#     EXECUTABLE ctest -j ${PROCESSOR_COUNT} # Executable in PROJECT_BINARY_DIR
#     DEPENDENCIES executable_target         # Dependencies to build first
# )
function(SETUP_TARGET_FOR_COVERAGE_GCOVR_HTML)

    set(options NONE)
    set(oneValueArgs NAME)
    set(multiValueArgs EXECUTABLE EXECUTABLE_ARGS DEPENDENCIES)
    cmake_parse_arguments(Coverage "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

    # Combine excludes to several -e arguments
    set(GCOVR_EXCLUDES "")
    foreach(EXCLUDE ${COVERAGE_GCOVR_EXCLUDES})
        list(APPEND GCOVR_EXCLUDES "-e")
        list(APPEND GCOVR_EXCLUDES "${EXCLUDE}")
    endforeach()

    add_custom_target(${Coverage_NAME}
        # Clean old coverage data
        COMMAND find ${PROJECT_BINARY_DIR} -type f -iname '*.gcno' -delete

        # Run tests
        COMMAND ${Coverage_EXECUTABLE} ${Coverage_EXECUTABLE_ARGS}

        # Create folder
        COMMAND ${CMAKE_COMMAND} -E make_directory ${PROJECT_BINARY_DIR}/${Coverage_NAME}

        # Running gcovr
        COMMAND ${GCOVR_PROG} --html --html-details
            -r ${PROJECT_SOURCE_DIR} ${GCOVR_EXCLUDES}
            --object-directory=${PROJECT_BINARY_DIR}
            -o ${Coverage_NAME}/index.html
        WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
        DEPENDS ${Coverage_DEPENDENCIES}
        COMMENT "Running gcovr to produce HTML code coverage report."
    )

    # Show info where to find the report
    add_custom_command(TARGET ${Coverage_NAME} POST_BUILD
        COMMAND ;
        COMMENT "Open ./${Coverage_NAME}/index.html in your browser to view the coverage report."
    )

endfunction()

# Defines a target for running and collection code coverage information
# Builds dependencies, runs the given executable and outputs reports.
# NOTE! The executable should always have a ZERO as exit code otherwise
# the coverage generation will not complete.
#
# SETUP_TARGET_FOR_COVERAGE_GCOVR_TEXT(
#     NAME ctest_coverage                    # New target name
#     EXECUTABLE ctest -j ${PROCESSOR_COUNT} # Executable in PROJECT_BINARY_DIR
#     DEPENDENCIES executable_target         # Dependencies to build first
# )
function(SETUP_TARGET_FOR_COVERAGE_GCOVR_TEXT)

    set(options NONE)
    set(oneValueArgs NAME)
    set(multiValueArgs EXECUTABLE EXECUTABLE_ARGS DEPENDENCIES)
    cmake_parse_arguments(Coverage "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

    # Combine excludes to several -e arguments
    set(GCOVR_EXCLUDES "")
    foreach(EXCLUDE ${COVERAGE_GCOVR_EXCLUDES})
        list(APPEND GCOVR_EXCLUDES "-e")
        list(APPEND GCOVR_EXCLUDES "${EXCLUDE}")
    endforeach()

    add_custom_target(${Coverage_NAME}
        # Clean old coverage data
        COMMAND find ${PROJECT_BINARY_DIR} -type f -iname '*.gcno' -delete

        # Run tests
        COMMAND ${Coverage_EXECUTABLE} ${Coverage_EXECUTABLE_ARGS}

        # Create folder
        COMMAND ${CMAKE_COMMAND} -E make_directory ${PROJECT_BINARY_DIR}/${Coverage_NAME}

        # Running gcovr
        COMMAND ${GCOVR_PROG}
            -r ${PROJECT_SOURCE_DIR} ${GCOVR_EXCLUDES}
            --object-directory=${PROJECT_BINARY_DIR}
        WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
        DEPENDS ${Coverage_DEPENDENCIES}
        COMMENT "Running gcovr to produce HTML code coverage report."
    )

endfunction()

function(CodeCoverageFlagsAppend)
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${CODE_COVERAGE_FLAGS}" PARENT_SCOPE)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${CODE_COVERAGE_FLAGS}" PARENT_SCOPE)
    message(STATUS "Code coverage compiler flags: ${CODE_COVERAGE_FLAGS}")
endfunction()
