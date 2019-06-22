# How to Create Qt Plugins
# https://doc.qt.io/qt-5/plugins-howto.html

# From: https://github.com/OlivierLDff/QtStaticCMake
# https://forum.qt.io/topic/103463/cmake-script-to-generate-q_import_plugin-to-link-against-static-qt
cmake_minimum_required(VERSION 3.0)

# Qt5 all static plugins libraries names
xmakeI_getQt5HostPluginNames(Qt5ValidPluginNames)

include(CMakeParseArguments)

# qt_generate_qml_plugin_import(YourApp
#   QML_DIR "/path/to/qtsdk"
#   QML_SRC "/path/to/yourApp/qml"
#   OUTPUT "YourApp_qml_plugin_import.cpp"
#   OUTPUT_DIR "/path/to/generate"
#   VERBOSE
# )
MACRO(qt_generate_qml_plugin_import TARGET)
    set(optionArgs VERBOSE)
    set(oneValueArgs QML_DIR QML_SRC OUTPUT OUTPUT_DIR)
    set(multiValueArgs)

    # parse the macro arguments
    CMAKE_PARSE_ARGUMENTS(ARGSTATIC
        "${optionArgs}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN}
    )

    # Copy arg variables to local variables
    set(QT_STATIC_TARGET ${TARGET})
    set(QT_STATIC_QML_DIR ${ARGSTATIC_QML_DIR})
    set(QT_STATIC_QML_SRC ${ARGSTATIC_QML_SRC})
    set(QT_STATIC_OUTPUT ${ARGSTATIC_OUTPUT})
    set(QT_STATIC_OUTPUT_DIR ${ARGSTATIC_OUTPUT_DIR})
    set(QT_STATIC_VERBOSE ${ARGSTATIC_VERBOSE})

    # Default to QtSdk/qml
    if(NOT QT_STATIC_QML_DIR)
        set(QT_STATIC_QML_DIR "${Qt5_SDK_ROOT_DIR}/qml")
        if(QT_STATIC_VERBOSE)
            message(STATUS "QML_DIR not set, default to ${QT_STATIC_QML_DIR}")
        endif(QT_STATIC_VERBOSE)
    endif(NOT QT_STATIC_QML_DIR)

    # Default to ${QT_STATIC_TARGET}_qml_plugin_import.cpp
    if(NOT QT_STATIC_OUTPUT)
        set(QT_STATIC_OUTPUT ${QT_STATIC_TARGET}_qml_plugin_import.cpp)
        if(QT_STATIC_VERBOSE)
            message(STATUS "OUTPUT not set, default to ${QT_STATIC_OUTPUT}")
        endif(QT_STATIC_VERBOSE)
    endif(NOT QT_STATIC_OUTPUT)

    # Default to project build directory
    IF(NOT QT_STATIC_OUTPUT_DIR)
        SET(QT_STATIC_OUTPUT_DIR ${PROJECT_BINARY_DIR})
        IF(QT_STATIC_VERBOSE)
        MESSAGE(STATUS "OUTPUT not specified, default to ${QT_STATIC_OUTPUT_DIR}")
        ENDIF(QT_STATIC_VERBOSE)
    ENDIF(NOT QT_STATIC_OUTPUT_DIR)

    # Print config
    IF(QT_STATIC_VERBOSE)
        MESSAGE(STATUS "------ QtStaticCMake Qml Generate Configuration ------")
        MESSAGE(STATUS "TARGET      : ${QT_STATIC_TARGET}")
        MESSAGE(STATUS "QML_DIR     : ${QT_STATIC_QML_DIR}")
        MESSAGE(STATUS "QML_SRC     : ${QT_STATIC_QML_SRC}")
        MESSAGE(STATUS "OUTPUT      : ${QT_STATIC_OUTPUT}")
        MESSAGE(STATUS "OUTPUT_DIR  : ${QT_STATIC_OUTPUT_DIR}")
        MESSAGE(STATUS "------ QtStaticCMake Qml Generate End Configuration ------")
    ENDIF(QT_STATIC_VERBOSE)

    IF(QT_STATIC_QML_SRC)
        # Debug
        IF(QT_STATIC_VERBOSE)
        MESSAGE(STATUS "Get Qml Plugin dependencies for ${QT_STATIC_TARGET}. qmlimportscanner path is ${Qt5_SDK_ROOT_DIR}/bin/qmlimportscanner. RootPath is ${QT_STATIC_QML_SRC} and importPath is ${QT_STATIC_QML_DIR}.")
        ENDIF(QT_STATIC_VERBOSE)

        # Get Qml Plugin dependencies
        EXECUTE_PROCESS(
            COMMAND ${Qt5_SDK_ROOT_DIR}/bin/qmlimportscanner -rootPath ${QT_STATIC_QML_SRC} -importPath ${QT_STATIC_QML_DIR}
            WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}
            OUTPUT_VARIABLE QT_STATIC_QML_DEPENDENCIES_JSON
            OUTPUT_STRIP_TRAILING_WHITESPACE
        )

        # Dump Json File for debug
        #MESSAGE(STATUS ${QT_STATIC_QML_DEPENDENCIES_JSON})

        # match all classname: (QtPluginStuff)
        STRING(REGEX MATCHALL "\"classname\"\\: \"([a-zA-Z0-9]*)\""
           QT_STATIC_QML_DEPENDENCIES_JSON_MATCH ${QT_STATIC_QML_DEPENDENCIES_JSON})

        # Show regex match for debug
        #MESSAGE(STATUS "match : ${QT_STATIC_QML_DEPENDENCIES_JSON_MATCH}")

        # Loop over each match to extract plugin name
        FOREACH(MATCH ${QT_STATIC_QML_DEPENDENCIES_JSON_MATCH})
            # Debug output
            #MESSAGE(STATUS "MATCH : ${MATCH}")
            # Extract plugin name
            STRING(REGEX MATCH "\"classname\"\\: \"([a-zA-Z0-9]*)\"" MATCH_OUT ${MATCH})
            # Debug output
            #MESSAGE(STATUS "CMAKE_MATCH_1 : ${CMAKE_MATCH_1}")
            # Check plugin isn't present in the list QT_STATIC_QML_DEPENDENCIES_PLUGINS
            LIST(FIND QT_STATIC_QML_DEPENDENCIES_PLUGINS ${CMAKE_MATCH_1} _PLUGIN_INDEX)
            IF(_PLUGIN_INDEX EQUAL -1)
                LIST(APPEND QT_STATIC_QML_DEPENDENCIES_PLUGINS ${CMAKE_MATCH_1})
            ENDIF(_PLUGIN_INDEX EQUAL -1)
        ENDFOREACH()

        # Print dependencies
        IF(QT_STATIC_VERBOSE)
        MESSAGE(STATUS "${QT_STATIC_TARGET} qml plugin dependencies:")
        FOREACH(PLUGIN ${QT_STATIC_QML_DEPENDENCIES_PLUGINS})
            MESSAGE(STATUS "${PLUGIN}")
        ENDFOREACH()
        ENDIF(QT_STATIC_VERBOSE)

        IF(QT_STATIC_VERBOSE)
        MESSAGE(STATUS "Generate ${QT_STATIC_OUTPUT} in ${QT_STATIC_OUTPUT_DIR}")
        ENDIF(QT_STATIC_VERBOSE)

        # Build file path
        SET(QT_STATIC_QML_PLUGIN_SRC_FILE "${QT_STATIC_OUTPUT_DIR}/${QT_STATIC_OUTPUT}")

        # Write file header
        FILE(WRITE ${QT_STATIC_QML_PLUGIN_SRC_FILE} "// File Generated via CMake script during build time.\n"
            "// The purpose of this file is to force the static load of qml plugin during static build\n"
            "// Please rerun CMake to update this file.\n"
            "// File will be overwrite at each CMake run.\n"
            "\n#include <QtPlugin>\n\n")

        # Write Q_IMPORT_PLUGIN for each plugin
        FOREACH(PLUGIN ${QT_STATIC_QML_DEPENDENCIES_PLUGINS})
            FILE(APPEND ${QT_STATIC_QML_PLUGIN_SRC_FILE} "Q_IMPORT_PLUGIN(${PLUGIN});\n")
        ENDFOREACH()

        # Add the file to the target sources
        IF(QT_STATIC_VERBOSE)
        MESSAGE(STATUS "Add ${QT_STATIC_QML_PLUGIN_SRC_FILE} to ${QT_STATIC_TARGET} sources")
        ENDIF(QT_STATIC_VERBOSE)
        target_sources(${QT_STATIC_TARGET} PRIVATE ${QT_STATIC_QML_PLUGIN_SRC_FILE})
    ELSE(QT_STATIC_QML_SRC)
        MESSAGE(WARNING "QT_STATIC_QML_SRC not specified. Can't generate Q_IMPORT_PLUGIN for qml plugin")
    ENDIF(QT_STATIC_QML_SRC)
endmacro()

# XmakeQt5StaticPluginSrcAdd(YourApp
#     PLUGIN_SRC "/path/to/generate/plugin_import.cpp"
#     VERBOSE
# )
macro(XmakeQt5StaticPluginSrcAdd TARGET)
    set(optionArgs VERBOSE)
    set(oneValueArgs PLUGIN_SRC)
    set(multiValueArgs)

    # parse the macro arguments
    cmake_parse_arguments(plg # ARGSTATIC
        "${optionArgs}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN}
    )

    if(NOT plg_PLUGIN_SRC)
        set(plg_PLUGIN_SRC
            "${${XMAKE}_GENERATED_DIR}/${TARGET}_plugin.generated.cpp"
        )
    endif()

    if(plg_VERBOSE)
        message(STATUS "Generate Qt5 static plugin source ${plg_PLUGIN_SRC}")
    endif()

    # Write the plugin file header
    file(WRITE ${plg_PLUGIN_SRC}
        "// File Generated via CMake script during build time. The purpose of\n"
        "// this file is to force the static load of Qt5 plugin during static\n"
        "// build. It will be overwrite at each CMake run.\n\n"
        "#include <QtPlugin>\n\n"
    )

    # Comment for help dubugging
    file(APPEND ${plg_PLUGIN_SRC} "// platform\n")
    if(HOST_WINDOWS)
        file(APPEND ${plg_PLUGIN_SRC} "Q_IMPORT_PLUGIN(QWindowsIntegrationPlugin);\n")
    else()
        file(APPEND ${plg_PLUGIN_SRC} "Q_IMPORT_PLUGIN(QXcbIntegrationPlugin);\n")
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
        file(APPEND ${plg_PLUGIN_SRC} "\n// ${module}\n")
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
                            file(APPEND ${plg_PLUGIN_SRC}
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

    target_sources(${TARGET} PRIVATE ${plg_PLUGIN_SRC})
    target_link_libraries(${TARGET} ${${XMAKE}_AUTO_QT5_LIBRARIES})
if(0)
    # Link to the platform library
    if(QT_STATIC_VERBOSE)
    MESSAGE(STATUS "Add -u _qt_registerPlatformPlugin linker flag to ${QT_IOS_TARGET} in order to force load qios library")
    endif()
    TARGET_LINK_LIBRARIES(${QT_STATIC_TARGET} "-u _qt_registerPlatformPlugin")
endif()
endmacro()
