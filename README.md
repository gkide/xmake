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

1. Download the [xmake.init.mk](xmake.init.mk)
2. Create directory **cmake** at project root and put **xmake.init.mk** there
3. Create a **Makefile** for the project and add two lines to the top

``` makefile
# This is for local configuration, not necessary
-include local.mk
# Include the xmake init makefile
-include cmake/xmake.init.mk
...
```

4. Create a **CmakeLists.txt** and add two lines to the top

``` cmake
...
list(APPEND CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake")
include(xmake) # xmake should include in the top CMakeLists.txt
...
```

5. That's all, just type `make`

Using **xmake** is much simple(only `CMakeLists.txt`):

1. Download the [xmake.init.cmake](xmake.init.cmake)
2. Create directory **cmake** at project root and put **xmake.init.cmake** there
3. Create a **CmakeLists.txt** and add two lines to the top

``` cmake
...
list(APPEND CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake")
include(xmake.init) # xmake should include in the top CMakeLists.txt
...
```

4. Create a build directory, and do `cd build && cmake ..`, That's all!
