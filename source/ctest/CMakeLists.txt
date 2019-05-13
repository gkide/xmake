aux_source_directory(. CCR_SRCS)
aux_source_directory(methods CCR_LIBS)

include_directories(${CMAKE_CURRENT_LIST_DIR})
add_executable(ccr ${CCR_SRCS} ${CCR_LIBS})

if(XDEMO_ENABLE_CTEST AND BUILD_TESTING)
    add_test(NAME ctest-ccr-args-none
        COMMAND ccr
        WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
    )
    #set_tests_properties(ctest-ccr-args-none)
    add_test(NAME ctest-ccr-args-2_to_2000
        COMMAND ccr 2 2000
        WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
    )
    # This test should be failed
    add_test(NAME ctest-ccr-args-0_to_100000
        COMMAND ccr 0 100000
        WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
    )
endif()

# Code Coverage Report: Lcov HTML Report
CodeCoverageLcovTrace(
    EXECUTABLE ccr
    TEST_NAME "ccr_args_none"
)

CodeCoverageLcovTrace(
    EXECUTABLE ccr
    EXECUTABLE_ARGS "2 2000"
    TEST_NAME "ccr_args_2_to_2000"
)

CodeCoverageLcovTrace(
    EXECUTABLE ccr
    EXECUTABLE_ARGS 0 100000
    EXECUTABLE_FORCE_SUCCESS
    TEST_NAME "ccr_args_overflow"
)

CodeCoverageLcovTraceReport(
    EXECUTABLE ccr
    TARGET "ccr_html_report"
    GENHTML_ARGS
        --title "Basic example"
)

# Code Coverage Report: Lcov HTML Report
CodeCoverageLcovHtml(
    TARGET lcov-html
    EXECUTABLE hostinfo
    LCOV_EXCLUDES
        ${QT5_STATIC_PREFIX}
        ${QT5_SHARED_PREFIX}
        ${XDEMO_AUTO_QT5_SOURCES}
        ${CMAKE_SOURCE_DIR}/source/qt5
        ${CMAKE_SOURCE_DIR}/source/ctest
        ${CMAKE_SOURCE_DIR}/source/gtest
        ${CMAKE_SOURCE_DIR}/source/hostinfo.cpp
    GENHTML_ARGS
        --title "hostinfo"
)

# Code Coverage Report: Gcovr XML Report
CodeCoverageGcovrXml(
    TARGET gcovr-xml
    EXECUTABLE check
)

# Code Coverage Report: Gcovr HTML Report
CodeCoverageGcovrHtml(
    TARGET gcovr-html
    EXECUTABLE awesome
    GCOVR_ARGS --html-title "CCR - awesome"
)

# Code Coverage Report: Gcovr TEXT Report
CodeCoverageGcovrText(
    TARGET gcovr-text
    EXECUTABLE xtest
)
