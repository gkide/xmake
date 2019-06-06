# https://cmake.org/cmake/help/latest/module/CMakePackageConfigHelpers.html
include(CMakePackageConfigHelpers)

set(LIBRARY_INSTALL_DIR lib)
set(INCLUDE_INSTALL_DIR include)
set(pkgconfig_DIR ${CMAKE_CURRENT_LIST_DIR}/pkgconfig)

function(XmakePackageConfig)
    set(options)
    set(oneValueArgs NAME DOMAIN)
    set(multiValueArgs)

    cmake_parse_arguments(pkg
        "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN}
    )

    if(NOT pkg_NAME)
        message(FATAL_ERROR "Must set NAME for package")
    endif()

    set(pkg_CMAKE_DEST lib/cmake/${pkg_NAME})

    string(REPLACE "v" "" pkg_VERSION "${PKG_VERSION}")
    string(REPLACE "V" "" pkg_VERSION "${pkg_VERSION}")

    # export library information for CMake project
    install(EXPORT "${pkg_NAME}" DESTINATION "${pkg_CMAKE_DEST}")

    configure_package_config_file(${pkgconfig_DIR}/Config.cmake.in
        ${CMAKE_CURRENT_BINARY_DIR}/pkgconfig/${pkg_NAME}Config.cmake
        INSTALL_DESTINATION "${pkg_CMAKE_DEST}"
        PATH_VARS INCLUDE_INSTALL_DIR LIBRARY_INSTALL_DIR
    )

    write_basic_package_version_file(
        ${CMAKE_CURRENT_BINARY_DIR}/pkgconfig/${pkg_NAME}ConfigVersion.cmake
        VERSION ${pkg_VERSION} COMPATIBILITY AnyNewerVersion
    )

    install(FILES
        ${CMAKE_CURRENT_BINARY_DIR}/pkgconfig/${pkg_NAME}Config.cmake
        ${CMAKE_CURRENT_BINARY_DIR}/pkgconfig/${pkg_NAME}ConfigVersion.cmake
        DESTINATION "${pkg_CMAKE_DEST}"
    )

    set(pkg_LIBRARY_DIR ${CMAKE_INSTALL_PREFIX}/lib)
    set(pkg_INCLUDE_DIR ${CMAKE_INSTALL_PREFIX}/include)
    if(pkg_DOMAIN)
        set(pkg_LIBRARY_DIR ${pkg_LIBRARY_DIR}/${pkg_DOMAIN})
    endif()

    set(pkg_EXTRA_LIBS)
    foreach(item ${pkg_UNPARSED_ARGUMENTS})
        set(pkg_EXTRA_LIBS "${pkg_EXTRA_LIBS} -l${item}")
    endforeach()

    # export library information for pkgconfig
    configure_file(${pkgconfig_DIR}/pkgconfig.pc.in
        ${CMAKE_CURRENT_BINARY_DIR}/pkgconfig/lib${pkg_NAME}.pc @ONLY
    )

    set(pkg_PKGCONFIG_DEST lib/pkgconfig)
    install(FILES
        ${CMAKE_CURRENT_BINARY_DIR}/pkgconfig/lib${pkg_NAME}.pc
        DESTINATION "${pkg_PKGCONFIG_DEST}"
    )
endfunction()
