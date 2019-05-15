# Download & install pre-build binaries
include(InstallAstyle)
# Download, extrac, build, install external project
include(BuildLibok)
set(XIHD_SRC ${CMAKE_SOURCE_DIR}/source)

# foo static/shared library
add_library(foostatic STATIC ${XIHD_SRC}/foo.c)
set_target_properties(foostatic PROPERTIES
    PUBLIC_HEADER "${XIHD_SRC}/foo.h"
)

add_library(fooshared SHARED ${XIHD_SRC}/foo.c)
set_target_properties(fooshared PROPERTIES
    PUBLIC_HEADER "${XIHD_SRC}/foo.h"
)

# bar static/shared library
list(APPEND BAR_PUBLIC_HEADERS ${XIHD_SRC}/bar.h)
list(APPEND BAR_PUBLIC_HEADERS ${XIHD_SRC}/bar2.h)
list(APPEND BAR_PRIVATE_HEADERS ${XIHD_SRC}/bar-private.h)
list(APPEND BAR_PRIVATE_HEADERS ${XIHD_SRC}/bar-private2.h)
add_library(barstatic SHARED ${XIHD_SRC}/bar.c ${XIHD_SRC}/bar-private.c)
set_target_properties(barstatic PROPERTIES
    PUBLIC_HEADER "${BAR_PUBLIC_HEADERS}"
    PRIVATE_HEADER "${BAR_PRIVATE_HEADERS}"
)

add_library(barshared SHARED ${XIHD_SRC}/bar.c ${XIHD_SRC}/bar-private.c)
set_target_properties(barshared PROPERTIES
    PUBLIC_HEADER "${BAR_PUBLIC_HEADERS}"
    PRIVATE_HEADER "${BAR_PRIVATE_HEADERS}"
)

# foobar static library
add_library(foobar STATIC ${XIHD_SRC}/foobar.c)
set_target_properties(foobar PROPERTIES
    PUBLIC_HEADER
        ${XIHD_SRC}/foobar.h
)

# barfoo shared library
add_library(barfoo SHARED ${XIHD_SRC}/foobar.c)
set_target_properties(barfoo PROPERTIES
    PUBLIC_HEADER
        ${XIHD_SRC}/foobar.h
)

# xtext executable => shared link to 'fooshared'
add_executable(xtest ${XTEST_RC} ${XIHD_SRC}/hostinfo.c)
target_link_libraries(xtest fooshared)

# xtext-static executable => static link to 'foostatic'
add_executable(xtest-static ${XTEST_RC} ${XIHD_SRC}/hostinfo.c)
target_link_libraries(xtest-static foostatic)

# another executable => shared link to 'fooshared', set RPATH some value
add_executable(another ${XIHD_SRC}/hostinfo.c)
target_link_libraries(another fooshared)
# show link detail command for target another
set_target_properties(another PROPERTIES
    # Shared library search path overwrite the default value
    INSTALL_RPATH $ANY/lib/anywhere
)

# xtestxx executable => shared link to 'barshared'
add_executable(xtestxx ${XIHD_SRC}/hostinfo.cpp)
target_link_libraries(xtestxx barshared)

# xtestxx-static executable => static link to 'barstatic'
add_executable(xtestxx-static ${XIHD_SRC}/hostinfo.cpp)
target_link_libraries(xtestxx-static barstatic)

# check executable => shared link to 'barshared', set RPATH to empty
add_executable(check ${XIHD_SRC}/hostinfo.cpp)
target_link_libraries(check barshared)
set_target_properties(check PROPERTIES
    # make shared linked test programes only work in the build directory
    INSTALL_RPATH ""
)

# bundle executable => static link to 'barstatic', with extra resources
add_executable(bundle ${XIHD_SRC}/hostinfo.cpp)
target_link_libraries(bundle barstatic)
set(bundle_RESOURCES
        ${CMAKE_SOURCE_DIR}/docs/res/install.ico
        ${CMAKE_SOURCE_DIR}/docs/res/uninstall.ico
)
set_target_properties(bundle PROPERTIES
#   MACOSX_BUNDLE TRUE
    RESOURCE "${bundle_RESOURCES}"
)
# bundle depends on libok, external project, which will
# download, build and install, see 'cmake/BuildLibok.cmake'
add_dependencies(bundle libok)

# awesome executable => link to 'barstatic' and 'fooshared'
add_executable(awesome ${XIHD_SRC}/awesome.c)
target_link_libraries(awesome barstatic fooshared)
add_dependencies(awesome astyle)
