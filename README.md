# xmake

cmake & make template for quick project creation! The `xdemo` is demo pro to
show how to use xmake template for new project, the `xmake` should be include
in the top CMakeLists.txt

- [Host Repo Info](docs/help.md#host-repo-info)
- [Qt5 Static/Shared Support](docs/help.md#qt5support)
- [Convenience Install Helper](docs/help.md#xmakeinstallhelper)
- [Deps Download/Build/Install](docs/help.md#external-project-support)
- [Code Coverage](docs/help.md#code-coverage-support)
- [Package and Release](docs/help.md#package-and-release)

# How Do I Use `xmake`

Using **xmake** is much simple(`Makefile` and `CMakeLists.txt`):

1. Download the [xmake.init.mk](xmake.init.mk) and [xmake.init.cmake](xmake.init.cmake)
2. Create directory **cmake** at project root and put them there
3. Create a **Makefile** for the project and add two lines to the top

``` makefile
# This is for local configuration, not necessary
-include local.mk
# Include the xmake init makefile
include cmake/xmake.init.mk

...
```

4. Create a **CmakeLists.txt** and add following lines to the top

``` cmake
...
cmake_minimum_required(VERSION 2.8.12)
project(abc) # abc project

set(ABC_VERSION_MAJOR 1)
set(ABC_VERSION_MINOR 0)
set(ABC_VERSION_PATCH 0)
set(ABC_VERSION_TWEAK "") # date & HASH auto update at build time

# THIS IS THE CRITAL CODE FOR XMAKE
#############################################################
list(APPEND CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake")
include(xmake.init) # This should be in the top CMakeLists.txt
XmakeInit(${XMAKE_VERSION} ${XMAKE_TARBALL_SHA256})
#############################################################

message(STATUS "XMAKE=${XMAKE}")
message(STATUS "PKG_VERSION=${PKG_VERSION}")

...
```

5. That's all, just type `make`, more configurations see [local.mk](docs/local.mk).

# xmake API Manual

xmake API usage manual are [here](docs/help.md).
