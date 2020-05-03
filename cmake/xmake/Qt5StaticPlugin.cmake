# How to Create Qt Plugins
# https://doc.qt.io/qt-5/plugins-howto.html

# From: https://github.com/OlivierLDff/QtStaticCMake
# https://forum.qt.io/topic/103463/cmake-script-to-generate-q_import_plugin-to-link-against-static-qt
cmake_minimum_required(VERSION 3.0)

# Qt5 all static plugins libraries names
xmakeI_getQt5HostPluginNames(Qt5ValidPluginNames)

include(CMakeParseArguments)

# XmakeQt5StaticPluginSrcAdd(YourApp
#     OUTPUT_SRC "/path/to/generate/plugin_import.cpp"
#     VERBOSE
# )
function(XmakeQt5StaticPluginSrcAdd TARGET)
    set(optionArgs VERBOSE)
    set(oneValueArgs OUTPUT_SRC)
    set(multiValueArgs)

    if(NOT TARGET)
        message(FATAL_ERROR "TARGET must be set, STOP!")
    endif()

    # parse the macro arguments
    cmake_parse_arguments(plg # ARGSTATIC
        "${optionArgs}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN}
    )

    if(NOT plg_OUTPUT_SRC)
        set(plg_OUTPUT_SRC
            "${${XMAKE}_GENERATED_DIR}/${TARGET}_plugin.generated.cpp"
        )
    endif()

    if(plg_VERBOSE)
        message(STATUS "Generate Qt5 static plugin source ${plg_OUTPUT_SRC}")
    endif()

    # Write the plugin file header
    file(WRITE ${plg_OUTPUT_SRC}
        "// File Generated via CMake script during build time. The purpose of\n"
        "// this file is to force the static load of Qt5 plugin during static\n"
        "// build. It will be overwrite at each CMake run.\n\n"
        "#include <QtPlugin>\n\n"
    )

    # Comment for help dubugging
    file(APPEND ${plg_OUTPUT_SRC} "// platform\n")
    if(HOST_WINDOWS)
        file(APPEND ${plg_OUTPUT_SRC} "Q_IMPORT_PLUGIN(QWindowsIntegrationPlugin);\n")
    else()
        file(APPEND ${plg_OUTPUT_SRC} "Q_IMPORT_PLUGIN(QXcbIntegrationPlugin);\n")
    endif()

    # Get all available Qt5 modules
    file(GLOB available_QT5_MODULES
        LIST_DIRECTORIES true
        RELATIVE
            ${Qt5_SDK_ROOT_DIR}/lib/cmake
            ${Qt5_SDK_ROOT_DIR}/lib/cmake/Qt5*
    )

    foreach(module ${available_QT5_MODULES})
        set(plugin_DIR ${${module}_DIR})
        if(NOT plugin_DIR)
            continue()
        endif()
        # Skip if there has none plugins
        set(plugin_CONTENTS ${${module}_PLUGINS})
        if(NOT plugin_CONTENTS)
            continue()
        endif()

        # Comment for help dubugging
        file(APPEND ${plg_OUTPUT_SRC} "\n// ${module}\n")
        # Parse Plugin to append to the list only if unique
        foreach(plugin_INFO ${plugin_CONTENTS})
            # List form is Qt5::NameOfPlugin, we just need NameOfPlugin
            string(REGEX MATCH ".*\\:\\:(.*)" PLUGIN_MATCH ${plugin_INFO})
            set(plugin_NAME ${CMAKE_MATCH_1})
            if(plugin_NAME) # Should be NameOfPlugin
                # Keep track to only write once each plugin
                list(FIND processed_QT5_PLUGINS ${plugin_NAME} plugin_INDEX)
                # Only Write/Keep track if the plugin isn't already present
                if(plugin_INDEX EQUAL -1)
                    list(APPEND processed_QT5_PLUGINS ${plugin_NAME})
                    foreach(plglib_NAME ${Qt5ValidPluginNames})
                        string(TOLOWER ${plglib_NAME} plglib_NAME)
                        string(TOLOWER ${plugin_NAME} plgimp_NAME)
                        if("${plgimp_NAME}" MATCHES "${plglib_NAME}")
                            file(APPEND ${plg_OUTPUT_SRC}
                                "Q_IMPORT_PLUGIN(${plugin_NAME});\n"
                            )
                        endif()
                    endforeach()
                endif()
            endif()
        endforeach()
    endforeach()

    # Print dependencies
    if(plg_VERBOSE)
        message(STATUS "Qt5 v${Qt5_SDK_VERSION} plugin dependencies:")
        foreach(plugin ${processed_QT5_PLUGINS})
            MESSAGE(STATUS "-> ${plugin}")
        endforeach()
    endif()

    target_sources(${TARGET} PRIVATE ${plg_OUTPUT_SRC})
    target_link_libraries(${TARGET} ${${XMAKE}_QT5_LIBRARIES})
    target_link_libraries(${TARGET} "-u _qt_registerPlatformPlugin")
endfunction()
