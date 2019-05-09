if(NOT XDEMO_ENABLE_GTEST OR NOT BUILD_TESTING)
    return()
endif()

add_compile_options(-std=c++11)

aux_source_directory(. GTEST_SRCS)

add_executable(gtest-demo ${GTEST_SRCS})
target_link_libraries(gtest-demo ${XDEMO_GTEST_LIBRARIES})
