# gtest use access non-ANSI symbols: fdopen, fileno, strdup
# '-std=c++11' will disable all of them, them got 'fileno'
# was not declared in this scope error
# https://stackoverflow.com/questions/18784112
#
# fix method one: add_compile_options(-std=gnu++0x)
#
# fix method two: still use -std=c++11 but modify source
add_compile_options(-std=c++11)
set_source_files_properties(
    ${CMAKE_CURRENT_LIST_DIR}/example.cpp
    PROPERTIES COMPILE_FLAGS -DENABLE_NONE_ANSI_SYMBOLS
)

include(BuildGtest)
aux_source_directory(. GTEST_SRCS)
add_executable(gtest ${GTEST_SRCS})
target_link_libraries(gtest ${GTEST_LIBRARIES})
add_dependencies(gtest libgtest)
