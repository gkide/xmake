# Xmake Manual

- Cmake [APIs](#cmake-apis)
- Project [Options](#project-options)
- Cmake [Configurations](#cmake-configurations)
- Host and Repo [Info](#host-repo-info)
  <img src="os/apple.svg" width=25 height=25 />
  <img src="os/linux.png" width=25 height=25 />
  <img src="os/windows.png" width=25 height=25 />

NOTE:
- min-cmake version is v2.8.12
- project name should consist of [A-Za-z0-9_-]
- **XMAKE** variable will auto set to `${PROJECT_NAME}` of uppercase
- The following **XXX** represent the uppercase of project name

# Host Repo Info

The following cmake variables will auto defined to idenify the host and project:

- `HOST_LINUX`, `HOST_MACOS`, `HOST_WINDOWS`
- `HOST_WINDOWS_MSYS`, `HOST_WINDOWS_MINGW`, `HOST_WINDOWS_CYGWIN`

- `HOST_ARCH_32`, `HOST_ARCH_64`

- `HOST_NAME`, `HOST_USER`, `HOST_ARCH`
- `HOST_SYSTEM_NAME`, `HOST_SYSTEM_VERSION`
- `HOST_OS_DIST_NAME`, `HOST_OS_DIST_VERSION`

- `HOST_BIG_ENDIAN`

- **XXX**`_VERSION_MAJOR`, number, like **1**
- **XXX**`_VERSION_MINOR`, number, like **2**
- **XXX**`_VERSION_PATCH`, number, like **3**
- **XXX**`_VERSION_TWEAK`, string, like **dev**
- **XXX**`_VERSION_NUMBER`

- **XXX**`_RELEASE_TYPE`, string, like **Debug**
- **XXX**`_RELEASE_VERSION`, string, like **v1.2.3-dev.20190515+73ebb13b0e**
- **XXX**`_RELEASE_TIMESTAMP`, string, like **2019-05-15 19:10:13 +0800**

- **XXX**`_RELEASE_YEAR`, string, like **2019**
- **XXX**`_RELEASE_MONTH`, string, like **05**
- **XXX**`_RELEASE_DAY`, string, like **15**

- **XXX**`_COMMIT_ZONE`, string, like **+0800**
- **XXX**`_COMMIT_TIME`, string, like **07:29:01**
- **XXX**`_COMMIT_DATE`, string, like **2019-05-12**
- **XXX**`_COMMIT_HASH`, string, like **73ebb13b0e**
- **XXX**`_COMMIT_MDTZ`, string, like **2019-05-15 07:29:01 +0800**

- **XXX**`_LOG_LEVEL`, number, like **0**
- **XXX**`_LOG_TYPE`, string, like **DEV**


# Project Options

## Project Semantic Version

- **XXX**`_VERSION_MAJOR` project major version, must be consist of `[0-9]`
- **XXX**`_VERSION_MINOR` project minor version, must be consist of `[0-9]`
- **XXX**`_VERSION_PATCH` project patch version, must be consist of `[0-9]`
- **XXX**`_VERSION_TWEAK` project tweak version, date & hash auto update

For example:

``` cmake
set(XDEMO_VERSION_MAJOR 1)
set(XDEMO_VERSION_MINOR 0)
set(XDEMO_VERSION_PATCH 0)
set(XDEMO_VERSION_TWEAK "dev") # date & HASH auto update at build time
```

result in the version: `v1.0.0-dev.20190425+4ad12f8dfb`

- compatible with [semver spec 2.0](https://semver.org/spec/v2.0.0.html) & [npm-semver](https://docs.npmjs.com/misc/semver)
- a unique ID for each build with repo-hash, build date, etc.

- `v1.0.0` is the basic part: major, minor, patch
- `dev` is the text part, which set to one of those [make sense](https://github.com/gkide/repo-hooks/blob/master/scripts/sync-release):
  * `dev`, `pre`, `nightly`, `alpha`, `beta`, `rc`, `lts`, `stable`, `release`, `eol`
- `20190425` is **YYYYMMDD** which will auto update to the build time
- `4ad12f8dfb` is the repo SHA1 numbers auto update to the build commit

## Project Building

- **XXX**`_EXPORT_AS_COMPILER_ARGS`, export predefined args as CC args, default **OFF**
- **XXX**`_ENABLE_ASSERTION`, enable assertion, default is **OFF**
- **XXX**`_XMAKE_VERBOSE`, show verbose xmake message, default is **OFF**
- **XXX**`_DISABLE_CCACHE`, enable **ccache** for linux by default.
- **XXX**`_ENABLE_CI`, disable continuous integration build by default,
  like [Travis](https://github.com/marketplace/travis-ci).

[ctest]: https://cmake.org/cmake/help/latest/module/CTest.html
- **XXX**`_ENABLE_CTEST`, enable CMake [ctest](ctest), disable by default.

  * **XXX**`_BUILD_CTEST` can be use to control build the tests or not, default is ON.

[gtest]: https://github.com/google/googletest
- **XXX**`_ENABLE_GTEST`, enable Google [gtest](gtest), disable by default.

  * **XXX**`_GTEST_LIBRARIES` will auto set to the need libraries for linking.
  * **XXX**`_BUILD_GTEST` can be use to control build the tests or not, default is ON.

- **XXX**`_DEBUG_BUILD`, project is debug build or not

which depends on `CMAKE_BUILD_TYPE`, if it is one of `Dev`,
`Debug`, `Coverage`, then it will be true, otherwise false.

- **XXX**`_SKIP_RPATH_ORIGIN`, default is **OFF**

  * if **OFF**, **RPATH** will be set to `$ORIGIN/../lib`;
  * if **ON**, executables & shared libraries rpath will be set to empty.

- **XXX**`_GTEST_LIBRARIES`

  * The collections of link libraries for **XXX**`_ENABLE_GTEST`

## Qt5 Support

- **XXX**`_AUTO_QT5_SOURCES`, auto generated source files for Qt5 if any.
- **XXX**`_AUTO_QT5_LIBRARIES`, auto collection libraries for linking for Qt5 if any.
- **XXX**`_AUTO_QT5_SOURCES`, for details see [XmakeQt5SupportSetup](#xmakeqt5supportsetup)
- **XXX**`_AUTO_QT5_LIBRARIES`, for details see [XmakeQt5SupportSetup](#xmakeqt5supportsetup)

## Code Coverage Support

- **XXX**`_ENABLE_GCOV`, enable gcov or not, default is **OFF**

  [XmakeCCRLcovHtml](#xmakeccrlcovhtml),
  [XmakeCCRLcovTrace](#xmakeccrlcovtrace),
  [XmakeCCRLcovTraceReport](#xmakeccrlcovtracereport),
  [XmakeCCRGcovrXml](#xmakeccrgcovrxml)
  [XmakeCCRGcovrHtml](#xmakeccrgcovrhtml),
  [XmakeCCRGcovrText](#xmakeccrgcovrtext)

- **XXX**`_ENABLE_DEPENDENCY`, external deps project support enable or not, default **OFF**

  [XmakeDepRepoBuild](#xmakedeprepobuild),
  [XmakeDepTarballBuild](#xmakedeptarballbuild),
  [XmakeDepBinaryInstall](#xmakedepbinaryinstall)

## Package and Release

- `PKG_NAME`, auto set to lower case of `${PROJECT_NAME}` if not set
- `PKG_VENDOR`, name of the package vendor, empty if not set
- `PKG_BRIEF_SUMMARY`, project short description, empty if not set
- `PKG_VERSION`, auto set to project's **major.minor.patch** if not set

- `PKG_MANUAL_DIR`, user manual directory, like API manual by doxygen.
  * it will auto set to `${CMAKE_BINARY_DIR}` if not set

- `PKG_REPO`, the repo upstream URL, empty if not set
- `PKG_BUG_REPORT`, bug report URL, empty if not set
- `PKG_MAINTAINER_EMAIL`, maintainer and email, empty if not set

- `PKG_LOGO`, project logo, empty if not set
- `PKG_INSTALLER_LOGO`, GUI installer INSTALL logo, empty if not set
- `PKG_UNINSTALLER_LOGO`, GUI installer UNINSTALL logo, empty if not set

- `PKG_TYPE_GUI`, set to true if the project is GUI

- `PKG_DOXYGEN_SOURCE`, list of project source files or directories
  * if not set, do the following checking, use the first one founded:
    - `${CMAKE_SOURCE_DIR}/src`
    - `${CMAKE_SOURCE_DIR}/source`
    - `${CMAKE_SOURCE_DIR}`

- `PKG_DOXYGEN_EXCLUDES`, doxygen input files exclude pattren, empty if not set

- `PKG_PACKAGE_EXCLUDES`, only used by cpack to package source tarballs.

    By default, the following will ignored from the source tarballs:
    - Version control files
      * `.svn/`
      * `.git/`
      * `.github/`
      * `.gitignore`
      * `.hooks-config`
      * `.gitattributes`
    - Generated temp files
      * `.swp`
      * `.swap`

    - Local log/config/debug files
      * `.log`
      * `local.mk`
      * `.standard-release`
      * `CMakeLists.txt.user`

    - Build and external-deps directory
      * `.deps/`
      * `build/`

    - Extra common regular temporary files
      * `tmp/`
      * `temp/`
      * `todo/`

    - Extra ignore files set by user
      * `${PKG_PACKAGE_EXCLUDES}`

## External Project Support

- `DEPS_ROOT_DIR`, download & build directory, default **.deps/**

- `DEPS_BUILD_TYPE`, external project build type, default **Release**

- `MAKE_PROG`, GNU make progame used for external project building.

  * If NOT set, it will auto detected by cmake from **PATH**.

- `GIT_PROG`, git programe used for clone external project.

  * If NOT set, it will auto detected by cmake from **PATH**.

- `DEPS_DOWNLOAD_DIR`, download root directory, default **.deps/downloads**
- `DEPS_BUILD_DIR`, deps build directory, default **.deps/build**
- `DEPS_INSTALL_DIR`, deps install perfix, default **.deps/usr**
- `DEPS_BIN_DIR`, deps binary install directory, default **.deps/usr/bin**
- `DEPS_LIB_DIR`, deps library install directory, default **.deps/usr/lib**
- `DEPS_INCLUDE_DIR`, deps header install directory, default **.deps/usr/include**

# Cmake APIs

- [XmakeQt5SupportSetup](#xmakeqt5supportsetup)
- [XmakeDepRepoBuild](#xmakedeprepobuild)
- [XmakeDepTarballBuild](#xmakedeptarballbuild)
- [XmakeDepBinaryInstall](#xmakedepbinaryinstall)
- [XmakeCCRLcovHtml](#xmakeccrlcovhtml)
- [XmakeCCRLcovTrace](#xmakeccrlcovtrace)
- [XmakeCCRLcovTraceReport](#xmakeccrlcovtracereport)
- [XmakeCCRGcovrXml](#xmakeccrgcovrxml)
- [XmakeCCRGcovrHtml](#xmakeccrgcovrhtml)
- [XmakeCCRGcovrText](#xmakeccrgcovrtext)
- [XmakeInstallHelper](#xmakeinstallhelper)
- [XmakeGetInstallBinaries](#xmakegetinstallbinaries)

## XmakeQt5SupportSetup

- `AUTOMATIC` try to find Qt5 from the system wide
- `STATIC_PREFIX` static build of Qt5 install path
- `SHARED_PREFIX` shared build of Qt5 install path

NOTE: static Qt5 need following two auto defined variables
- **XXX**`_AUTO_QT5_SOURCES`, xmake auto generated source files for statci qt5.
- **XXX**`_AUTO_QT5_LIBRARIES`, xmake auto collection libraries to link against.

## XmakeDepRepoBuild

This is used for building external repo project: clone, build and install.

- `NAME`, The external project name, will be cmake top target
- `REPO_URL`, The git project repo URL to clone
- `PATCH_CMD`, The project patch commands
- `CONFIG_CMD`, The project config commands
- `BUILD_CMD`, The project build commands
- `INSTALL_CMD`, The project install commands

## XmakeDepTarballBuild

This is used for building external project: download, build and install.

- `NAME`, The external project name, will be cmake top target
- `VERSION`, The project version
- `URL`, The project tarball URL to download
- `SHA256`, The tarball SHA256 for tarball checking
- `PATCH_CMD`, The project patch command
- `CONFIG_CMD`, The project config command
- `BUILD_CMD`, The project build command
- `INSTALL_CMD`, The project install command

## XmakeDepBinaryInstall

This is used for prebuild binary: download and install.

- `NAME`, The prebuild binary name, will be cmake top target
- `SKIP`, Skip prebuild binary download and install if true
- `REPO`, Download prebuild binary repo, patch and install
- `TARBALL`, Download prebuild binary tarball, extract, patch and install
- `URL`, The prebuild binary tarball or repo URL to download
- `PATCH_CMD`, The prebuild binary patch commands
- `INSTALL_CMD`, The prebuild binary install commands
- `VERSION`, The prebuild binary version
- `SHA256`, The prebuild binary SHA256 for tarball checking

## XmakeCCRLcovHtml

Defines a target for running and collection code coverage information.
Builds dependencies if any, runs the given executable and outputs reports.

NOTE! The executable should always have a ZERO as exit code otherwise
the coverage generation will not complete, but this can be skipped by
given `EXECUTABLE_FORCE_SUCCESS`.

- `TARGET`, Target name, if not set auto set to `code.coverage-`**name**
- `EXECUTABLE`, Executable to run
- `EXECUTABLE_ARGS`, Executable arguments
- `DEPENDENCIES`, Dependencies to build first
- `LCOV_ARGS`, Extra arguments for lcov
- `LCOV_EXCLUDES`, Report exclude patterns, auto remove system ones
- `GENHTML_ARGS`, Extra arguments for genhtml
- `EXECUTABLE_FORCE_SUCCESS`, Executable force success if set

## XmakeCCRLcovTrace

Running executable with different args and collection code coverage information.
Builds dependencies if any, runs the given executable and outputs reports.

NOTE! The executable should always have a ZERO as exit code otherwise
the coverage generation will not complete, but this can be skipped by
given `EXECUTABLE_FORCE_SUCCESS`.

- `TEST_NAME`, Test name for executable to run with given args for `CodeCoverageLcovTrace`
- `EXECUTABLE`, Executable to run
- `EXECUTABLE_ARGS`, Executable arguments
- `DEPENDENCIES`, Dependencies to build first
- `LCOV_ARGS`, Extra arguments for lcov
- `LCOV_EXCLUDES`, Report exclude patterns, auto remove system
- `EXECUTABLE_FORCE_SUCCESS`, Executable force success if set

## XmakeCCRLcovTraceReport

- `TARGET`, Target name to create
- `EXECUTABLE`, Executable to run
- `DEPENDENCIES`, Dependencies to build first
- `LCOV_ARGS`, Extra arguments for lcov
- `GENHTML_ARGS`, Extra arguments for genhtml
- `LCOV_EXCLUDES`, Report exclude patterns, auto remove system

## XmakeCCRGcovrXml

- `TARGET`, Target name, if not set auto set to `code.coverage-`**name**
- `EXECUTABLE`, Executable to run
- `EXECUTABLE_ARGS`, Executable arguments
- `DEPENDENCIES`, Dependencies to build first
- `GCOVR_ARGS`, Extra arguments for gcovr
- `GCOVR_EXCLUDES`, Extra arguments for gcovr, auto remove system
- `EXECUTABLE_FORCE_SUCCESS`, Executable force success if set

## XmakeCCRGcovrHtml

- `TARGET`, Target name, if not set auto set to `code.coverage-`**name**
- `EXECUTABLE`, Executable to run
- `EXECUTABLE_ARGS`, Executable arguments
- `DEPENDENCIES`, Dependencies to build first
- `GCOVR_ARGS`, Extra arguments for gcovr
- `GCOVR_EXCLUDES`, Extra arguments for gcovr, auto remove system
- `EXECUTABLE_FORCE_SUCCESS`, Executable force success if set

## XmakeCCRGcovrText

- `TARGET`, Target name, if not set auto set to `code.coverage-`**name**
- `EXECUTABLE`, Executable to run
- `EXECUTABLE_ARGS`, Executable arguments
- `DEPENDENCIES`, Dependencies to build first
- `GCOVR_ARGS`, Extra arguments for gcovr
- `GCOVR_EXCLUDES`, Extra arguments for gcovr, auto remove system
- `EXECUTABLE_FORCE_SUCCESS`, Executable force success if set

## XmakeCCRAppendFlags

Append C/C++ compiler flags for code coverage.

## XmakeInstallHelper

This is a `cmake` **install** wrapper for convenience,
the following variables will auto defined by xmake.

- **XXX**`_INSTALL_DIR`     => `${CMAKE_INSTALL_PREFIX}`
- **XXX**`_INSTALL_BIN_DIR` => `${CMAKE_INSTALL_PREFIX}/bin`
- **XXX**`_INSTALL_ETC_DIR` => `${CMAKE_INSTALL_PREFIX}/etc`
- **XXX**`_INSTALL_DOC_DIR` => `${CMAKE_INSTALL_PREFIX}/doc`
- **XXX**`_INSTALL_LIB_DIR` => `${CMAKE_INSTALL_PREFIX}/lib`
- **XXX**`_INSTALL_SHA_DIR` => `${CMAKE_INSTALL_PREFIX}/share`
- **XXX**`_INSTALL_PLG_DIR` => `${CMAKE_INSTALL_PREFIX}/plugin`
- **XXX**`_INSTALL_INC_DIR` => `${CMAKE_INSTALL_PREFIX}/include`

The default install directory layout is as following:

    ├─ bin/             binaries
    ├─ etc/             configurations
    ├─ doc/             documentations
    ├─ lib/             static/shared libraries
    ├─ include/         header files
    │  ├─ foo/          header files in subdir
    │  └─ ...
    ├─ share/           common share resources
    │  ├─ resource/     like the app icos
    │  ├─ bar/          and more
    │  └─ ...
    ├─ awesome/         this is also possible
    └─ plugin/          plugins

The install prefix can be set by `CMAKE_INSTALL_PREFIX`, the default is:
- Linux likes: **/opt**`/${PKG_NAME}-${PKG_VERSION}`
- Windows: **$ENV{PROGRAMFILES}**`\${PKG_NAME}-${PKG_VERSION}`

NOTE!
- `PKG_NAME` will be set to the lower case of `${PROJECT_NAME}` if not set.
- `PKG_VERSION` will be set to the project's **major.minor.patch** if not set.

If it is called with only cmake targets, that is executable(s) and/or libraries,
all executables will be installed into **bin/**, all libraries will be installed
into **lib/**, but for windows, the DLLS will be installed into **bin/**.

Note that the executables/libraries can have extra resource associated to install,
for executables have `RESOURCE` property, the files will be installed into
**share/resource**; for library that has `PUBLIC_HEADER` property, the public
headers will be installed into `include/`; for library that has `PUBLIC_HEADER`
property, the private headers will be installed into `include/private/`

If **DOMAIN** arguments is given, for example `DOMAIN xyz`, keep the above, but
related files will be put into the given domain subdirectory, that is executables
will be installed into **bin/xyz**, the libraries will be installed into **lib/xyz**,
the header files will be installed into **include/xyz**, and the executable resource
will be installed into **share/xyz/resource**

If **DESTINATION** is given, just get rid of the install layout above, install
file any where as you want to, can be used combie with **DOMAIN**, and the
**DOMAIN** argument has the same effect.

- **TARGETS** a list of `cmake` targets for installation
  if **FILE_PERMISSIONS** do not set, the executables permission default set
  to **rwxr-xr-x**, the other files permission default set to **rw-r--r--**

- **PROGRAMS** a list of executable files which are not cmake target
  if **FILE_PERMISSIONS** do not set, permissions default set to **rwxr-xr-x**

- **FILES** a list of normal files
  if **FILE_PERMISSIONS** do not set, permissions default set to **rw-r--r--**,

- **RENAME** can be use to rename a install file
  it only works for **PROGRAMS** or **FILES** with only one argument

- **DIRECTORY** install all the contents of given directory

- **DOMAIN** the domain string value, default value is empty

- **DESTINATION** the install destination
  for **TARGETS**, this arg can be missing, result in to use default value,
  but for others, this arg can not be missing

- **DIRECTORY_PERMISSIONS** set the directory permissions
  * if not set, the default value is **rwxr-xr-x**
  * user:   `OWNER_READ`, `OWNER_WRITE`, `OWNER_EXECUTE`
  * group:  `GROUP_READ`, `GROUP_WRITE`, `GROUP_EXECUTE`
  * others: `WORLD_READ`, `WORLD_WRITE`, `WORLD_EXECUTE`

- **FILE_PERMISSIONS** set the directory permissions
  * if not set, the default value is **rw-r--r--**
  * user:   `OWNER_READ`, `OWNER_WRITE`, `OWNER_EXECUTE`
  * group:  `GROUP_READ`, `GROUP_WRITE`, `GROUP_EXECUTE`
  * others: `WORLD_READ`, `WORLD_WRITE`, `WORLD_EXECUTE`

- installs contents of `DIRECTORY` into `DESTINATION` with optional permissions
  * if not set `FILE_PERMISSIONS`, the default value is **rw-r--r--**,
  * if not set `DIRECTORY_PERMISSIONS` the default value is **rwxr-xr-x**

- install `FILES` into `DESTINATION` with optional `FILE_PERMISSIONS`
  * if not set, the default value is **rw-r--r--**, rename if set `RENAME`

- install `PROGRAMS` into `DESTINATION` with optional `FILE_PERMISSIONS`
  * if not set, the default value is **rwxr-xr-x**, rename if set `RENAME`


## XmakeGetInstallBinaries

Get all the binary targets(executable, library) of [XmakeInstallHelper](#xmakeinstallhelper)

NOTE! This may not work if the `XmakeGetInstallBinaries`
is not a sub-scope of the XmakeInstallHelper called.

``` cmake
XmakeGetInstallBinaries(binaries)
foreach(item ${binaries})
    message(STATUS "Install: ${item}")
endforeach()
```
