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

Using **xmake** is much simple:

1. Download the [xmake.init](xmake.init)
2. Create directory **cmake** at project root and put **xmake.init** there
3. Create a **Makefile** for the project and add two lines to the top

``` Makefile
# This is for local configuration, not necessary
-include local.mk
# Include the xmake init makefile
-include cmake/xmake.init
...
```

4. Create a **CmakeLists.txt**
5. That's all, just type `make`
