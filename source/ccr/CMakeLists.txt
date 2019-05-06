aux_source_directory(. CCR_SRCS)
aux_source_directory(methods CCR_LIBS)

add_executable(ccr ${CCR_SRCS} ${CCR_LIBS})

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
