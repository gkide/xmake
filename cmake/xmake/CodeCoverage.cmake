include(CMakeParseArguments)

# Check prereqs
find_program(GCOV_PROG gcov)
find_program(GCOVR_PROG gcovr)
find_program(PYTHON_PROG python)
find_program(LCOV_PROG NAMES lcov lcov.bat lcov.exe lcov.perl)
find_program(GENHTML_PROG NAMES genhtml genhtml.perl genhtml.bat)

if("${CMAKE_CXX_COMPILER_ID}" MATCHES "(Apple)?[Cc]lang"
   AND "${CMAKE_CXX_COMPILER_VERSION}" VERSION_LESS 3)
    message(WARNING "Clang version must be 3.0.0 or greater, code coverage skip ...")
    return()
elseif(NOT CMAKE_COMPILER_IS_GNUCXX)
    message(WARNING "Compiler is not GNU GCC, code coverage skip ...")
    return()
endif()

if(NOT ${XMAKE}_DEBUG_BUILD)
    message(WARNING "Code coverage results of optimised build may be misleading!")
endif()

message(STATUS "Enable code coverage measurements")
set(code_coverage_flags "-g -O0 --coverage -fprofile-arcs -ftest-coverage"
    CACHE INTERNAL "")

set(CMAKE_C_FLAGS_${buildType} ${code_coverage_flags}
    CACHE STRING "The C compiler flags for code coverage." FORCE)
set(CMAKE_CXX_FLAGS_${buildType} ${code_coverage_flags}
    CACHE STRING "The C++ compiler flags for code coverage." FORCE)
set(CMAKE_EXE_LINKER_FLAGS_${buildType} ""
    CACHE STRING "The binaries linking flags for code coverage." FORCE)
set(CMAKE_SHARED_LINKER_FLAGS_${buildType} ""
    CACHE STRING "The shared libraries linking flags for code coverage." FORCE)

if(CMAKE_C_COMPILER_ID STREQUAL "GNU")
    link_libraries(gcov) # For all targets
else()
    set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} --coverage")
endif()

# Append C/C++ compiler flags for code coverage
function(CodeCoverageAppendFlags)
    set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${code_coverage_flags}" PARENT_SCOPE)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${code_coverage_flags}" PARENT_SCOPE)
    message(STATUS "Code coverage compiler flags: ${code_coverage_flags}")
endfunction()

# code coverage report root directory
set(ccrd ${CMAKE_BINARY_DIR}/${CMAKE_BUILD_TYPE}/code.coverage)

# Exclude the system wide include headers for code coverage by default
list(APPEND SYSTEM_EXCLUDES ${CMAKE_C_IMPLICIT_INCLUDE_DIRECTORIES})
list(APPEND SYSTEM_EXCLUDES ${CMAKE_CXX_IMPLICIT_INCLUDE_DIRECTORIES})
list(APPEND SYSTEM_EXCLUDES ${CMAKE_PLATFORM_IMPLICIT_INCLUDE_DIRECTORIES})

# Defines a target for running and collection code coverage information.
# Builds dependencies first, runs the given executable and outputs reports.
#
# NOTE! The executable should always have a ZERO as exit code otherwise
# the coverage generation will not complete.
#
# - TARGET              Target name, if not set auto set to code.coverage-*
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
    if(NOT cct_TARGET)
        set(cct_TARGET code.coverage-${runner})
    endif()

    # code coverage INFO/HTML report directory
    set(report_dir ${ccrd}/${runner})

    set(based_traceinfo ${report_dir}/${runner}-trace.info.based)
    set(build_traceinfo ${report_dir}/${runner}-trace.info.build)
    set(total_traceinfo ${report_dir}/${runner}-trace.info.total)
    set(clean_traceinfo ${report_dir}/${runner}-trace.info.clean)

    # Setup target
    add_custom_target(${cct_TARGET}
        # Cleanup lcov
        COMMAND ${LCOV_PROG} ${cct_LCOV_ARGS} --gcov-tool ${GCOV_PROG}
            --directory . --zerocounters
        # Create HTML output folder
        COMMAND ${CMAKE_COMMAND} -E make_directory ${report_dir}
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
        DEPENDS ${cct_DEPENDENCIES}
        WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
        COMMENT "Processing code coverage counters and generating report."
    )

    # Exclude the system ones by default
    foreach(item ${SYSTEM_EXCLUDES})
        add_custom_command(TARGET ${cct_TARGET}
            COMMENT "Ignore SYS Sources for HTML report: ${item}"
            POST_BUILD COMMAND ${LCOV_PROG} ${cct_LCOV_ARGS} --gcov-tool ${GCOV_PROG}
                --remove ${clean_traceinfo} '${item}*'
                --output-file ${clean_traceinfo}
        )
    endforeach()
    # Exclude the user given patterns
    foreach(item ${cct_LCOV_EXCLUDES})
        add_custom_command(TARGET ${cct_TARGET}
            COMMENT "Ignore USR Sources for HTML report: ${item}"
            POST_BUILD COMMAND ${LCOV_PROG} ${cct_LCOV_ARGS} --gcov-tool ${GCOV_PROG}
                --remove ${clean_traceinfo} '${item}*'
                --output-file ${clean_traceinfo}
        )
    endforeach()

    string(REPLACE "${CMAKE_BINARY_DIR}/" "" rccrd "${ccrd}")
    set(html_report ${rccrd}/${runner}/index.html)
    set(info_report ${rccrd}/${runner}/${runner}-trace.info.build)

    # Show where to find the lcov INFO report
    add_custom_command(TARGET ${cct_TARGET}
        POST_BUILD COMMAND ;
        COMMENT "Lcov INFO code coverage report: ${info_report}"
    )
    # Show info where to find the HTML report
    add_custom_command(TARGET ${cct_TARGET}
        COMMENT "Lcov HTML code coverage report: ${html_report}"
        POST_BUILD COMMAND ${GENHTML_PROG} ${cct_GENHTML_ARGS}
            --output-directory ${report_dir} ${clean_traceinfo}
    )
endfunction()

# Defines a target for running and collection code coverage information.
# Builds dependencies first, runs the given executable and outputs reports.
#
# NOTE! The executable should always have a ZERO as exit code otherwise
# the coverage generation will not complete.
#
# - TARGET              Target name, if not set auto set to code.coverage-*
# - EXECUTABLE          Executable to run
# - EXECUTABLE_ARGS     Executable arguments
# - DEPENDENCIES        Dependencies to build first
#
# - GCOVR_ARGS          Extra arguments for gcovr
# - GCOVR_EXCLUDES      Extra arguments for gcovr
#
# CodeCoverageGcovrXml(
#     TARGET runner_coverage
#     EXECUTABLE runner -j ${PROCESSOR_COUNT}
#     DEPENDENCIES runner-deps
# )
function(CodeCoverageGcovrXml)
    cmake_parse_arguments(cct
        ""
        "TARGET"
        "EXECUTABLE;EXECUTABLE_ARGS;DEPENDENCIES;GCOVR_ARGS;GCOVR_EXCLUDES"
        ${ARGN}
    )

    if(NOT GCOVR_PROG)
        message(WARNING "NOT found gcovr, code coverage skip ...")
        return()
    endif()

    if(NOT PYTHON_PROG)
        message(WARNING "NOT found python, code coverage skip ...")
        return()
    endif()

    if(NOT cct_EXECUTABLE)
        message(FATAL_ERROR "Must set EXECUTABLE for code coverage.")
    endif()

    get_filename_component(runner ${cct_EXECUTABLE} NAME)

    if(NOT cct_TARGET)
        set(cct_TARGET code.coverage-${runner})
    endif()

    # Generating the XML report
    set(report_dir ${ccrd}/${runner})
    set(xml_report ${report_dir}/${runner}.xml)

    # Combine excludes to several -e arguments
    set(gcovr_excludes "")
    foreach(item ${SKIP_ITEMS})
        list(APPEND gcovr_excludes "--exclude" "${item}")
    endforeach()
    # Exclude the user given patterns
    foreach(item ${cct_GCOVR_EXCLUDES})
        list(APPEND gcovr_excludes "--exclude" "${item}")
    endforeach()

    add_custom_target(${cct_TARGET}
        # Clean old coverage data
        COMMAND find ${CMAKE_BINARY_DIR} -type f -iname '*.gcda' -delete
        # Run test executable
        COMMAND ${cct_EXECUTABLE} ${cct_EXECUTABLE_ARGS}
        # Create XML output folder
        COMMAND ${CMAKE_COMMAND} -E make_directory ${report_dir}
        # Running gcovr
        COMMAND ${GCOVR_PROG} --xml --xml-pretty ${cct_GCOVR_ARGS}
            --root ${CMAKE_SOURCE_DIR} ${gcovr_excludes}
            --object-directory=${CMAKE_BINARY_DIR}
            --output ${xml_report}
        WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
        DEPENDS ${cct_DEPENDENCIES}
        COMMENT "Running gcovr to produce XML code coverage report."
    )

    # Exclude the system ones by default
    foreach(item ${SYSTEM_EXCLUDES})
        add_custom_command(TARGET ${cct_TARGET} POST_BUILD
            COMMAND ;
            COMMENT "Ignore SYS Sources for XML report: ${item}"
        )
    endforeach()
    # Exclude the user given patterns
    foreach(item ${cct_GCOVR_EXCLUDES})
        add_custom_command(TARGET ${cct_TARGET} POST_BUILD
            COMMAND ;
            COMMENT "Ignore USR Sources for XML report: ${item}"
        )
    endforeach()

    string(REPLACE "${CMAKE_BINARY_DIR}/" "" xml_report "${xml_report}")
    # Show info where to find the report
    add_custom_command(TARGET ${cct_TARGET} POST_BUILD
        COMMAND ;
        COMMENT "Gcovr XML code coverage report: ${xml_report}"
    )
endfunction()

# Defines a target for running and collection code coverage information.
# Builds dependencies first, runs the given executable and outputs reports.
#
# NOTE! The executable should always have a ZERO as exit code otherwise
# the coverage generation will not complete.
#
# - TARGET              Target name, if not set auto set to code.coverage-*
# - EXECUTABLE          Executable to run
# - EXECUTABLE_ARGS     Executable arguments
# - DEPENDENCIES        Dependencies to build first
#
# - GCOVR_ARGS          Extra arguments for gcovr
# - GCOVR_EXCLUDES      Extra arguments for gcovr
#
# CodeCoverageGcovrHtml(
#     TARGET runner_coverage
#     EXECUTABLE runner -j ${PROCESSOR_COUNT}
#     DEPENDENCIES runner-deps
# )
function(CodeCoverageGcovrHtml)
    cmake_parse_arguments(cct
        ""
        "TARGET"
        "EXECUTABLE;EXECUTABLE_ARGS;DEPENDENCIES;GCOVR_ARGS;GCOVR_EXCLUDES"
        ${ARGN}
    )

    if(NOT GCOVR_PROG)
        message(WARNING "NOT found gcovr, code coverage skip ...")
        return()
    endif()

    if(NOT PYTHON_PROG)
        message(WARNING "NOT found python, code coverage skip ...")
        return()
    endif()

    if(NOT cct_EXECUTABLE)
        message(FATAL_ERROR "Must set EXECUTABLE for code coverage.")
    endif()

    get_filename_component(runner ${cct_EXECUTABLE} NAME)

    if(NOT cct_TARGET)
        set(cct_TARGET code.coverage-${runner})
    endif()

    # Generating the XML report
    set(report_dir ${ccrd}/${runner})

    # Combine excludes to several -e arguments
    set(gcovr_excludes "")
    foreach(item ${SYSTEM_EXCLUDES})
        list(APPEND gcovr_excludes "--exclude" "${item}")
    endforeach()
    # Exclude the user given patterns
    foreach(item ${cct_GCOVR_EXCLUDES})
        list(APPEND gcovr_excludes "--exclude" "${item}")
    endforeach()

    add_custom_target(${cct_TARGET}
        # Clean old coverage data
        COMMAND find ${CMAKE_BINARY_DIR} -type f -iname '*.gcda' -delete
        # Run tests runner
        COMMAND ${cct_EXECUTABLE} ${cct_EXECUTABLE_ARGS}
        # Create HTML output folder
        COMMAND ${CMAKE_COMMAND} -E make_directory ${report_dir}
        # Running gcovr
        COMMAND ${GCOVR_PROG} --html --html-details ${cct_GCOVR_ARGS}
            --root ${CMAKE_SOURCE_DIR} ${gcovr_excludes}
            --object-directory=${CMAKE_BINARY_DIR}
            -o ${report_dir}/index.html
        DEPENDS ${cct_DEPENDENCIES}
        WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
        COMMENT "Running gcovr to produce HTML code coverage report."
    )

    # Exclude the system ones by default
    foreach(item ${SYSTEM_EXCLUDES})
        add_custom_command(TARGET ${cct_TARGET} POST_BUILD
            COMMAND ;
            COMMENT "Ignore SYS Sources for HTML report: ${item}"
        )
    endforeach()
    # Exclude the user given patterns
    foreach(item ${cct_GCOVR_EXCLUDES})
        add_custom_command(TARGET ${cct_TARGET} POST_BUILD
            COMMAND ;
            COMMENT "Ignore USR Sources for HTML report: ${item}"
        )
    endforeach()

    string(REPLACE "${CMAKE_BINARY_DIR}/" "" report_dir "${report_dir}")
    # Show info where to find the HTML report
    add_custom_command(TARGET ${cct_TARGET} POST_BUILD
        COMMAND ;
        COMMENT "Gcovr HTML code coverage report: ${report_dir}/index.html"
    )
endfunction()

# Defines a target for running and collection code coverage information.
# Builds dependencies first, runs the given executable and outputs reports.
#
# NOTE! The executable should always have a ZERO as exit code otherwise
# the coverage generation will not complete.
#
# - TARGET              Target name, if not set auto set to code.coverage-*
# - EXECUTABLE          Executable to run
# - EXECUTABLE_ARGS     Executable arguments
# - DEPENDENCIES        Dependencies to build first
#
# - GCOVR_ARGS          Extra arguments for gcovr
# - GCOVR_EXCLUDES      Extra arguments for gcovr
#
# CodeCoverageGcovrHtml(
#     TARGET runner_coverage
#     EXECUTABLE runner -j ${PROCESSOR_COUNT}
#     DEPENDENCIES runner-deps
# )
function(CodeCoverageGcovrText)
    cmake_parse_arguments(cct
        ""
        "TARGET"
        "EXECUTABLE;EXECUTABLE_ARGS;DEPENDENCIES;GCOVR_ARGS;GCOVR_EXCLUDES"
        ${ARGN}
    )

    if(NOT GCOVR_PROG)
        message(WARNING "NOT found gcovr, code coverage skip ...")
        return()
    endif()

    if(NOT PYTHON_PROG)
        message(WARNING "NOT found python, code coverage skip ...")
        return()
    endif()

    if(NOT cct_EXECUTABLE)
        message(FATAL_ERROR "Must set EXECUTABLE for code coverage.")
    endif()

    get_filename_component(runner ${cct_EXECUTABLE} NAME)

    if(NOT cct_TARGET)
        set(cct_TARGET code.coverage-${runner})
    endif()

    # Generating the XML report
    set(report_dir ${ccrd}/${runner})
    set(text_report ${report_dir}/${runner}.text)

    # Combine excludes to several -e arguments
    set(gcovr_excludes "")
    foreach(item ${SYSTEM_EXCLUDES})
        list(APPEND gcovr_excludes "--exclude" "${item}")
    endforeach()
    # Exclude the user given patterns
    foreach(item ${cct_GCOVR_EXCLUDES})
        list(APPEND gcovr_excludes "--exclude" "${item}")
    endforeach()

    add_custom_target(${cct_TARGET}
        # Clean old coverage data
        COMMAND find ${CMAKE_BINARY_DIR} -type f -iname '*.gcda' -delete
        # Run tests
        COMMAND ${cct_EXECUTABLE} ${cct_EXECUTABLE_ARGS}
        # Create TEXT output folder
        COMMAND ${CMAKE_COMMAND} -E make_directory ${report_dir}
        # Running gcovr
        COMMAND ${GCOVR_PROG} ${cct_GCOVR_ARGS}
            --root ${CMAKE_SOURCE_DIR} ${gcovr_excludes}
            --object-directory=${CMAKE_BINARY_DIR}
            -o ${text_report}
        WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
        DEPENDS ${cct_DEPENDENCIES}
        COMMENT "Running gcovr to produce TEXT code coverage report."
    )

    # Exclude the system ones by default
    foreach(item ${SYSTEM_EXCLUDES})
        add_custom_command(TARGET ${cct_TARGET} POST_BUILD
            COMMAND ;
            COMMENT "Ignore SYS Sources for TEXT report: ${item}"
        )
    endforeach()
    # Exclude the user given patterns
    foreach(item ${cct_GCOVR_EXCLUDES})
        add_custom_command(TARGET ${cct_TARGET} POST_BUILD
            COMMAND ;
            COMMENT "Ignore USR Sources for TEXT report: ${item}"
        )
    endforeach()

    string(REPLACE "${CMAKE_BINARY_DIR}/" "" text_report "${text_report}")
    # Show info where to find the report
    add_custom_command(TARGET ${cct_TARGET} POST_BUILD
        COMMAND ;
        COMMENT "Gcovr TEXT code coverage report: ${text_report}"
    )
endfunction()
