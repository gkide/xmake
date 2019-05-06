aux_source_directory(. CCR_SRCS)
aux_source_directory(methods CCR_LIBS)

add_executable(ccr ${CCR_SRCS} ${CCR_LIBS})

CodeCoverageLcovTrace(
    EXECUTABLE ccr
    TESTNAME "ccr_args_none"
)

CodeCoverageLcovTrace(
    EXECUTABLE ccr
    EXECUTABLE_ARGS "2 2000"
    TESTNAME "ccr_args_2_to_2000"
)

CodeCoverageLcovTrace(
    EXECUTABLE ccr
    EXECUTABLE_ARGS 0 100000
    EXECUTABLE_FORCE_SUCCESS
    TESTNAME "ccr_args_overflow"
)

CodeCoverageLcovTrace(
    HTML_REPORT
    EXECUTABLE ccr
    TARGET "ccr_html_report"
    GENHTML_ARGS
        --title "Basic example"
)
