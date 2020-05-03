# Search Static Qt5 Libraries
# - Link sequence is much more important
# - https://doc.qt.io/qt-5/cmake-manual.html
# - https://doc.qt.io/qt-5/linux-requirements.html

macro(xmakeI_AppendQt5Lib qt5_library)
    if(qt5_library STREQUAL "")
        return()
    endif()
    set(${XMAKE}_QT5_LIBRARIES
        ${${XMAKE}_QT5_LIBRARIES}
        ${qt5_library} PARENT_SCOPE
    )
endmacro()

function(xmakeI_Qt5StaticLibFind name qt5_libs_search_path)
    set(libName ${CMAKE_STATIC_LIBRARY_PREFIX}${name}${CMAKE_STATIC_LIBRARY_SUFFIX})
    find_library(qt5StaticLibrary_${name}
        NAMES ${libName} NAMES_PER_DIR
        PATHS ${qt5_libs_search_path}
        NO_CMAKE_PATH
        NO_DEFAULT_PATH
        NO_CMAKE_ENVIRONMENT_PATH
        NO_SYSTEM_ENVIRONMENT_PATH
        NO_CMAKE_SYSTEM_PATH
    )
    mark_as_advanced(qt5StaticLibrary_${name})
    # message(STATUS "${libName} => ${qt5StaticLibrary_${name}}")
    if(EXISTS ${qt5StaticLibrary_${name}})
        xmakeI_AppendQt5Lib(${qt5StaticLibrary_${name}})
    endif()
endfunction()

####################################
# Qt5 Static Library Search Prefix #
####################################
set(Qt5SLSPrefix ${xmakeI_QT5_STATIC_PREFIX})
mark_as_advanced(Qt5SLSPrefix)

# Static Qt5 Library: lib/libQt5XcbQpa.a
xmakeI_Qt5StaticLibFind(Qt5XcbQpa ${Qt5SLSPrefix}/lib)
# Static Qt5 Library: lib/libQt5ServiceSupport.a
xmakeI_Qt5StaticLibFind(Qt5ServiceSupport ${Qt5SLSPrefix}/lib)
# Static Qt5 Library: lib/libQt5ThemeSupport.a
xmakeI_Qt5StaticLibFind(Qt5ThemeSupport ${Qt5SLSPrefix}/lib)
# Static Qt5 Library: lib/libQt5DBus.a
xmakeI_Qt5StaticLibFind(Qt5DBus ${Qt5SLSPrefix}/lib)
# Static Qt5 Library: lib/libQt5EventDispatcherSupport.a
xmakeI_Qt5StaticLibFind(Qt5EventDispatcherSupport ${Qt5SLSPrefix}/lib)
# Static Qt5 Library: lib/libQt5FontDatabaseSupport.a
xmakeI_Qt5StaticLibFind(Qt5FontDatabaseSupport ${Qt5SLSPrefix}/lib)

# For Qt 5.12.3
xmakeI_Qt5StaticLibFind(Qt5EdidSupport ${Qt5SLSPrefix}/lib)

# Static Qt5 Library: lib/libQt5Core.a
find_package(Qt5Core CONFIG REQUIRED)
mark_as_advanced(Qt5Core_DIR)
get_target_property(Qt5StaticLibrary Qt5::Core LOCATION)
list(APPEND ${XMAKE}_QT5_LIBRARIES ${Qt5StaticLibrary})

# Static Qt5 Library: lib/libQt5Gui.a
find_package(Qt5Gui CONFIG)
if(Qt5Gui_FOUND)
    get_target_property(Qt5StaticLibrary Qt5::Gui LOCATION)
    list(APPEND ${XMAKE}_QT5_LIBRARIES ${Qt5StaticLibrary})
    foreach(plugin ${Qt5Gui_PLUGINS})
        get_target_property(location ${plugin} LOCATION)
        list(APPEND ${XMAKE}_QT5_LIBRARIES ${Qt5StaticLibrary})
        # message("Qt5Gui Plugin: ${plugin} => ${location}")
    endforeach()
endif()

# Static Qt5 Library: lib/libQt5Sql.a
find_package(Qt5Sql CONFIG)
if(Qt5Sql_FOUND)
    get_target_property(Qt5StaticLibrary Qt5::Sql LOCATION)
    list(APPEND ${XMAKE}_QT5_LIBRARIES ${Qt5StaticLibrary})
    foreach(plugin ${Qt5Sql_PLUGINS})
        get_target_property(location ${plugin} LOCATION)
        list(APPEND ${XMAKE}_QT5_LIBRARIES ${Qt5StaticLibrary})
        # message("Qt5Sql Plugin: ${plugin} => ${location}")
    endforeach()
endif()

# Static Qt5 Library: lib/libQt5Widgets.a
find_package(Qt5Widgets CONFIG)
if(Qt5Widgets_FOUND)
    get_target_property(Qt5StaticLibrary Qt5::Widgets LOCATION)
    list(APPEND ${XMAKE}_QT5_LIBRARIES ${Qt5StaticLibrary})
    foreach(plugin ${Qt5Widgets_PLUGINS})
        get_target_property(location ${plugin} LOCATION)
        list(APPEND ${XMAKE}_QT5_LIBRARIES ${Qt5StaticLibrary})
        # message("Qt5Widgets Plugin: ${plugin} => ${location}")
    endforeach()
endif()

# Static Qt5 Library: lib/libQt5Network.a
find_package(Qt5Network CONFIG)
if(Qt5Network_FOUND)
    get_target_property(Qt5StaticLibrary Qt5::Network LOCATION)
    list(APPEND ${XMAKE}_QT5_LIBRARIES ${Qt5StaticLibrary})
    foreach(plugin ${Qt5Network_PLUGINS})
        get_target_property(location ${plugin} LOCATION)
        list(APPEND ${XMAKE}_QT5_LIBRARIES ${Qt5StaticLibrary})
        # message("Qt5Network Plugin: ${plugin} => ${location}")
    endforeach()
endif()

#############################################
# Multi Arch Spec                           #
# - https://wiki.ubuntu.com/MultiarchSpec   #
# - https://err.no/debian/amd64-multiarch-3 #
#############################################
if(HOST_ARCH_32)
    if(HOST_WINDOWS_MINGW OR HOST_WINDOWS_MSYS)
        list(APPEND MultiArchSearchDirs "/usr/lib")
        list(APPEND MultiArchSearchDirs "/mingw32/lib")
    else()
        list(APPEND MultiArchSearchDirs "/lib32")
        list(APPEND MultiArchSearchDirs "/usr/lib32")
        list(APPEND MultiArchSearchDirs "/lib/i386-linux-gnu")
        list(APPEND MultiArchSearchDirs "/usr/lib/i386-linux-gnu")
    endif()
else()
    if(HOST_WINDOWS_MINGW OR HOST_WINDOWS_MSYS)
        list(APPEND MultiArchSearchDirs "/usr/lib")
        list(APPEND MultiArchSearchDirs "/mingw64/lib")
    else()
        list(APPEND MultiArchSearchDirs "/lib64")
        list(APPEND MultiArchSearchDirs "/usr/lib64")
        list(APPEND MultiArchSearchDirs "/lib/x86_64-linux-gnu")
        list(APPEND MultiArchSearchDirs "/usr/lib/x86_64-linux-gnu")
    endif()
endif()
mark_as_advanced(MultiArchSearchDirs)

function(xmakeI_Qt5SystemLibFind name shared_first)
    list(APPEND libNames "${name}")
    list(INSERT libNames 0
        ${CMAKE_SHARED_LIBRARY_PREFIX}${name}${CMAKE_SHARED_LIBRARY_SUFFIX})
    list(INSERT libNames 0
        ${CMAKE_STATIC_LIBRARY_PREFIX}${name}${CMAKE_STATIC_LIBRARY_SUFFIX})

    if(shared_first)
        list(REVERSE libNames) # shared libray come first
    endif()

    find_library(qt5SystemLibrary_${name}
        NAMES ${libNames} NAMES_PER_DIR
        PATHS ${MultiArchSearchDirs}
    )
    mark_as_advanced(qt5SystemLibrary_${name})
    if(EXISTS ${qt5SystemLibrary_${name}})
        xmakeI_AppendQt5Lib(${qt5SystemLibrary_${name}})
    endif()
endfunction()

#############################################
# The system widle shared or static library #
#############################################

# System Library: libfontconfig.a, libfontconfig.so
xmakeI_Qt5SystemLibFind(fontconfig OFF)
# System Library: libexpat.a, libexpat.so
xmakeI_Qt5SystemLibFind(expat OFF)
# System Library: libfreetype.a, libfreetype.so
xmakeI_Qt5SystemLibFind(freetype OFF)

# The X.Org project provides an open source implementation
# of the X Window System, which is widely used in linux system,
# so just link to the dynamic libraries.
#
# FindX11.cmake for Find X11 installation
# - X11_FOUND        True if X11 is available
# - X11_INCLUDE_DIR  Include directories to use X11
# - X11_LIBRARIES    Link against these to use X11
find_package(X11)
if(X11_FOUND) # A Sample Authorization Protocol for X
    # libXau.so: library for the X Input Extension
    list(APPEND ${XMAKE}_QT5_LIBRARIES ${X11_X11_LIB})
endif()
if(X11_Xi_FOUND)
    # libXi.so: library for the X Input Extension
    list(APPEND ${XMAKE}_QT5_LIBRARIES ${X11_Xi_LIB})
endif()

# Xlib/XCB interface library provides functions needed by
# clients which take advantage of Xlib/XCB to mix calls to
# both Xlib and XCB over the same X connection.
#
# System Library: libX11-xcb.a, libX11-xcb.so
xmakeI_Qt5SystemLibFind(X11-xcb OFF)
# Static Qt5 Library: lib/libxcb-static.a
xmakeI_Qt5StaticLibFind(xcb-static ${Qt5SLSPrefix}/lib)

# The X protocol C-language Binding (XCB) is a replacement for Xlib
# featuring a small footprint, latency hiding, direct access to the
# protocol, improved threading support, and extensibility. On Linux,
# the xcb QPA (Qt Platform Abstraction) platform plugin is used.
#
# System Library: libxcb.a, libxcb.so
xmakeI_Qt5SystemLibFind(xcb ON)

# System Library: libpng.a, libpng.so
xmakeI_Qt5SystemLibFind(png OFF)
# System Library: libpng12.a, libpng12.so
xmakeI_Qt5SystemLibFind(png12 OFF)

# Static Qt5 Library: lib/libqtharfbuzz.a
xmakeI_Qt5StaticLibFind(qtharfbuzz ${Qt5SLSPrefix}/lib)

# ICU - International Components for Unicode if use the
# static ICU, the output will get bigger nearly double size.
#
# System Library: libicui18n.a, libicui18n.so
xmakeI_Qt5SystemLibFind(icui18n ON)
# System Library: libicuuc.a, libicuuc.so
xmakeI_Qt5SystemLibFind(icuuc ON)
# System Library: libicudata.a, libicudata.so
xmakeI_Qt5SystemLibFind(icudata ON)

# System Library: libm.a, libm.so
xmakeI_Qt5SystemLibFind(m ON)

# System Library: libz.a, libz.so
xmakeI_Qt5SystemLibFind(z ON)

# System Library: libpcre2
# http://www.pcre.org/current/doc/html/index.html
# https://packages.ubuntu.com/xenial/libpcre2-dev
xmakeI_Qt5SystemLibFind(pcre2-8 ON)
xmakeI_Qt5SystemLibFind(pcre2-16 ON)
xmakeI_Qt5SystemLibFind(pcre2-32 ON)
xmakeI_Qt5SystemLibFind(pcre2-posix ON)

# Static Qt5 Library: lib/libqtpcre2.a
xmakeI_Qt5StaticLibFind(qtpcre2 ${Qt5SLSPrefix}/lib)

# System Library: libdl.a, libdl.so
xmakeI_Qt5SystemLibFind(dl ON)

# Gthread: part of Glib
# Pthread: POSIX thread standard
#
# System Library: libgthread-2.0.a, libgthread-2.0.so
xmakeI_Qt5SystemLibFind(gthread-2.0 ON)
# System Library: libiconv.a, libiconv.so
xmakeI_Qt5SystemLibFind(iconv ON)
# System Library: libcrypto.a, libcrypto.so
xmakeI_Qt5SystemLibFind(crypto ON)
# System Library: libssl.a, libssl.so
xmakeI_Qt5SystemLibFind(ssl ON)

# The GLib provides the core application building blocks
# for libraries and applications written in C.
#
# It contains low-level libraries useful for providing data
# structure handling for C, portability wrappers and interfaces
# for such runtime functionality as an event loop, threads, dynamic
# loading and an object system.
#
# System Library: libglib-2.0.a, libglib-2.0.so
xmakeI_Qt5SystemLibFind(glib-2.0 ON)

# For Qt 5.12.3
xmakeI_Qt5SystemLibFind(SM ON) # libSM-devel
xmakeI_Qt5SystemLibFind(ICE ON) # libice-dev
xmakeI_Qt5SystemLibFind(tiff ON)
xmakeI_Qt5SystemLibFind(jpeg ON)
xmakeI_Qt5SystemLibFind(jasper ON)
xmakeI_Qt5SystemLibFind(Xrender ON)
xmakeI_Qt5SystemLibFind(xkbcommon ON)
xmakeI_Qt5SystemLibFind(xcb-static ON)

###############
# Qt5 Plugins #
###############
set(Qt5StaticPluginRoot_DIR "${Qt5SLSPrefix}/plugins")
file(GLOB plugin_DIRS LIST_DIRECTORIES true ${Qt5StaticPluginRoot_DIR}/*)
foreach(plg_DIR ${plugin_DIRS})
    if(NOT IS_DIRECTORY ${plg_DIR})
        continue()
    endif()

    file(GLOB plugin_LIBS ${plg_DIR}/*.a)
    foreach(plg_LIB ${plugin_LIBS})
        get_filename_component(name ${plg_LIB} NAME_WE)
        string(SUBSTRING ${name} 3 -1 name) # skip the 'lib'
        list(APPEND ${XMAKE}_QT5_LIBRARIES ${plg_LIB})
        # just add image formats for now, skip left ones
        if("${plg_DIR}" MATCHES "imageformats")
            list(APPEND Qt5HostPluginNames ${name})
        endif()
    endforeach()
endforeach()

function(xmakeI_getQt5HostPluginNames var)
    set(${var} "${Qt5HostPluginNames}" PARENT_SCOPE)
endfunction()

mark_as_advanced(${XMAKE}_QT5_LIBRARIES)
