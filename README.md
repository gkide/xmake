# xmake

cmake & make template for quick project creation! The `xdemo` is demo pro to
show how to use xmake cmake & make template for new project, the `xmake` should
include in the top CMakeLists.txt

- [Host Info Auto Detect Support](#host-status-for-project-xdemo)
  * [MacOS](#macos)
  * [Linux](#linux-likes)
  * Windows: [Msys](#windowsmsys), [MinGW32](#windowsmingw32),
    [MinGW64](#windowsmingw64), [Cygwin](#windowscygwin)

- [Qt5 Static/Shared Link Support](#qt5-support)
- [Cmake Install Helper for Convenience](#installhelper)
- [External Deps Download/Build/Install](#external-project-download-build-and-install)
  * [BuildDepsRepo](#builddepsreponame)
  * [BuildDepsTarBall](#builddepstarballname)
  * [PrebuildInstall](#prebuildinstallname)

- [Code Coverage Support](#code-coverage-support)

# Predefined Cmake Variables

**XMAKE** variable will auto set to `${PROJECT_NAME}` of uppercase, project
name should consist of [A-Za-z0-9_-], and the min-cmake version is v2.8.12

- **${XMAKE}**`_ENABLE_ASSERTION` enable assertion, default is **OFF**
- **${XMAKE}**`_XMAKE_VERBOSE` show verbose xmake message, default is **OFF**
- **${XMAKE}**`_DISABLE_CCACHE` enable **ccache** for linux by default.
- **${XMAKE}**`_ENABLE_CI` disable continuous integration build by default,
  like [Travis](https://github.com/marketplace/travis-ci).

- **${XMAKE}**`_AUTO_SOURCES`, xmake auto generated source files if any.
- **${XMAKE}**`_AUTO_LIBRARIES`, xmake auto collection libraries for linking.

- **${XMAKE}**`_DEBUG_BUILD`, which depends on `CMAKE_BUILD_TYPE`:
  * if one of `Dev`, `Debug`, `Coverage`, then it will be true.
  * otherwise, it will be set to false.

- **${XMAKE}**`_SKIP_RPATH_ORIGIN`
  * if **OFF**(default), **RPATH** will be set to `$ORIGIN/../lib`
  * if **ON**, executables & shared libraries rpath will be set to empty.

# Host Status for project `xdemo`

- The demo project **xdemo** result in **XMAKE** set to `XDEMO`

- **${XMAKE}**`_EXPORT_AS_COMPILER_ARGS`
  * if **ON**, export the variables as CC command line arguments
  * if **OFF**(default), do not export to CC, use cmake `configure_file()`

## Semantic Version Support for `XDEMO` Project

- **XDEMO**`_VERSION_MAJOR` the project major version, must be consist of `[0-9]`
- **XDEMO**`_VERSION_MINOR` the project minor version, must be consist of `[0-9]`
- **XDEMO**`_VERSION_PATCH` the project patch version, must be consist of `[0-9]`
- **XDEMO**`_VERSION_TWEAK` which is build time auto update tweak-version string

**NOTE**: by doing this, the final version string is like:

`v1.0.0-dev.20190425+4ad12f8dfb`

- compatible with [semver spec 2.0](https://semver.org/spec/v2.0.0.html) & [npm-semver](https://docs.npmjs.com/misc/semver)
- a unique ID for each build with repo-hash, build date, etc.

- `v1.0.0` is the basic part, major/minor/patch
- `dev` is the text part, which set to one of those make sense:
  * `dev`, `pre`, `nightly`, `alpha`, `beta`, `rc`, `lts`, `stable`, `release`, `eol`
  * The auto stuff [repo-hooks](https://github.com/gkide/repo-hooks/blob/master/scripts/sync-release)
- `20190425` is **YYYYMMDD** which will auto update to the build time
- `4ad12f8dfb` is the repo SHA1 numbers auto update to the build commit's value

## MacOS

- HOST_LINUX
- HOST_MACOS
- HOST_ARCH_64               : little endian
- HOST_NAME                  : charlie
- HOST_USER                  : BlackMacOS.local
- HOST_ARCH                  : x86_64
- HOST_SYSTEM_NAME           : macos
- HOST_SYSTEM_VERSION        : 15.0.0
- HOST_OS_DIST_NAME          : Mac OS X
- HOST_OS_DIST_VERSION       : 10.11.1-15B42
- **XDEMO**_VERSION_MAJOR    : 1
- **XDEMO**_VERSION_MINOR    : 0
- **XDEMO**_VERSION_PATCH    : 0
- **XDEMO**_VERSION_TWEAK    : release
- **XDEMO**_RELEASE_TYPE     : Debug
- **XDEMO**_RELEASE_VERSION  : v1.0.0-release~20190411@c13ea86
- **XDEMO**_RELEASE_TIMESTAMP: 2019-04-10 21:26:52 +0800

## Linux & Likes

- HOST_LINUX
- HOST_ARCH_64               : little endian
- HOST_NAME                  : charlie
- HOST_USER                  : ThinkPad
- HOST_ARCH                  : x86_64
- HOST_SYSTEM_NAME           : linux
- HOST_SYSTEM_VERSION        : 3.16.0-30-generic
- HOST_OS_DIST_NAME          : Ubuntu
- HOST_OS_DIST_VERSION       : 14.04
- **XDEMO**_VERSION_MAJOR    : 1
- **XDEMO**_VERSION_MINOR    : 0
- **XDEMO**_VERSION_PATCH    : 0
- **XDEMO**_VERSION_TWEAK    : release
- **XDEMO**_RELEASE_TYPE     : Debug
- **XDEMO**_RELEASE_VERSION  : v1.0.0-release~20190411@a419980
- **XDEMO**_RELEASE_TIMESTAMP: 2019-04-10 21:50:38 +0800

## Windows/Msys

- HOST_LINUX
- HOST_WINDOWS
- HOST_WINDOWS_MSYS
- HOST_ARCH_64               : little endian
- HOST_NAME                  : 书生
- HOST_USER                  : ThinkPad
- HOST_ARCH                  : x86_64
- HOST_SYSTEM_NAME           : windows/msys
- HOST_SYSTEM_VERSION        : 2.8.2(0.313/5/3)
- HOST_OS_DIST_NAME          : Windows 7
- HOST_OS_DIST_VERSION       : 6.1.7601
- **XDEMO**_VERSION_MAJOR    : 1
- **XDEMO**_VERSION_MINOR    : 0
- **XDEMO**_VERSION_PATCH    : 0
- **XDEMO**_VERSION_TWEAK    : release
- **XDEMO**_RELEASE_TYPE     : Debug
- **XDEMO**_RELEASE_VERSION  : v1.0.0-release~20190411@bf3c447
- **XDEMO**_RELEASE_TIMESTAMP: 2019-04-10 21:26:52 +0800

## Windows/MinGW32

- HOST_WINDOWS
- HOST_WINDOWS_MINGW
- HOST_ARCH_32               : little endian
- HOST_NAME                  : 书生
- HOST_USER                  : ThinkPad
- HOST_ARCH                  : x86
- HOST_SYSTEM_NAME           : windows/mingw
- HOST_SYSTEM_VERSION        : 6.1.7601
- HOST_OS_DIST_NAME          : Windows 7
- HOST_OS_DIST_VERSION       : 6.1.7601
- **XDEMO**_VERSION_MAJOR    : 1
- **XDEMO**_VERSION_MINOR    : 0
- **XDEMO**_VERSION_PATCH    : 0
- **XDEMO**_VERSION_TWEAK    : release
- **XDEMO**_RELEASE_TYPE     : Debug
- **XDEMO**_RELEASE_VERSION  : v1.0.0-release~20190411@bf3c447
- **XDEMO**_RELEASE_TIMESTAMP: 2019-04-10 21:57:53

## Windows/MinGW64

- HOST_WINDOWS
- HOST_WINDOWS_MINGW
- HOST_ARCH_64               : little endian
- HOST_NAME                  : 书生
- HOST_USER                  : ThinkPad
- HOST_ARCH                  : x86_64
- HOST_SYSTEM_NAME           : windows/mingw
- HOST_SYSTEM_VERSION        : 6.1.7601
- HOST_OS_DIST_NAME          : Windows 7
- HOST_OS_DIST_VERSION       : 6.1.7601
- **XDEMO**_VERSION_MAJOR    : 1
- **XDEMO**_VERSION_MINOR    : 0
- **XDEMO**_VERSION_PATCH    : 0
- **XDEMO**_VERSION_TWEAK    : release
- **XDEMO**_RELEASE_TYPE     : Debug
- **XDEMO**_RELEASE_VERSION  : v1.0.0-release~20190411@bf3c447
- **XDEMO**_RELEASE_TIMESTAMP: 2019-04-10 21:02:43

## Windows/Cygwin

- HOST_LINUX
- HOST_WINDOWS
- HOST_WINDOWS_CYGWIN
- HOST_ARCH_64               : little endian
- HOST_NAME                  : 书生
- HOST_USER                  : ThinkPad
- HOST_ARCH                  : x86_64
- HOST_SYSTEM_NAME           : windows/cygwin
- HOST_SYSTEM_VERSION        : 3.0.6(0.338/5/3)
- HOST_OS_DIST_NAME          : Windows 7
- HOST_OS_DIST_VERSION       : 6.1.7601
- **XDEMO**_VERSION_MAJOR    : 1
- **XDEMO**_VERSION_MINOR    : 0
- **XDEMO**_VERSION_PATCH    : 0
- **XDEMO**_VERSION_TWEAK    : release
- **XDEMO**_RELEASE_TYPE     : Debug
- **XDEMO**_RELEASE_VERSION  : v1.0.0-release
- **XDEMO**_RELEASE_TIMESTAMP: 2019-04-10 21:40:14 +0800

# Qt5 Support

- `QT5_AUTOMATIC`
  * if set `QT5_STATIC_PREFIX`, support static Qt5
  * if set `QT5_SHARED_PREFIX`, support shared Qt5
  * if both not set, try to find Qt5 from the system wide

- `QT5_STATIC_PREFIX` static build of Qt5 install path
- `QT5_SHARED_PREFIX` shared build of Qt5 install path

- NOTE: static Qt5 need those two auto defined variables
  * **${XMAKE}**`_AUTO_SOURCES`, xmake auto generated source file if need.
  * **${XMAKE}**`_AUTO_LIBRARIES`, xmake auto collection libraries to link against.

# `InstallHelper`

- `InstallHelper` is cmake install helper for convenience

* `${XMAKE}_INSTALL_DIR` => `${CMAKE_INSTALL_PREFIX}`, install root
* `${XMAKE}_INSTALL_BIN_DIR` => `${CMAKE_INSTALL_PREFIX}/bin`, executable
* `${XMAKE}_INSTALL_ETC_DIR` => `${CMAKE_INSTALL_PREFIX}/etc`, configuration
* `${XMAKE}_INSTALL_DOC_DIR` => `${CMAKE_INSTALL_PREFIX}/doc`, documentation
* `${XMAKE}_INSTALL_LIB_DIR` => `${CMAKE_INSTALL_PREFIX}/lib`, C/C++ library
* `${XMAKE}_INSTALL_SHA_DIR` => `${CMAKE_INSTALL_PREFIX}/share`, share data
* `${XMAKE}_INSTALL_PLG_DIR` => `${CMAKE_INSTALL_PREFIX}/plugin`, plugin data
* `${XMAKE}_INSTALL_INC_DIR` => `${CMAKE_INSTALL_PREFIX}/include`, C/C++ header

- `TARGETS` of cmake will be installed into `${${XMAKE}_INSTALL_BIN_DIR}` or `${${XMAKE}_INSTALL_LIB_DIR}`
  * cmake targets: **executables**, **static**/**shared**/**module**/**import** libraries
  * The executable resources will be installed into `${${XMAKE}_INSTALL_SHA_DIR}/resource` if NOT **MacOS**

- installs contents of `DIRECTORY` into `DESTINATION` with optional permissions
  * if not set `FILE_PERMISSIONS`, the default value is **rw-r--r--**,
  * if not set `DIRECTORY_PERMISSIONS` the default value is **rwxr-xr-x**

- install `FILES` into `DESTINATION` with optional `FILE_PERMISSIONS`
  * if not set, the default value is **rw-r--r--**, rename if set `RENAME`

- install `PROGRAMS` into `DESTINATION` with optional `FILE_PERMISSIONS`
  * if not set, the default value is **rwxr-xr-x**, rename if set `RENAME`

# External Project Download, Build and Install

- **${XMAKE}**`_ENABLE_DEPENDENCY` enable external deps support or not, default is **OFF**

## The following values can be set by user if need

- `DEPS_ROOT_DIR`, Download & build directory, default is **.deps/**
- `DEPS_BUILD_TYPE`, External project build type, default is **Release**

- `MAKE_PROG`, The GNU make progame used for external project building.
  * If NOT set, it will auto detected by cmake from **PATH**, can not missing!

- `GIT_PROG`, The git programe used for clone external project.
  * If NOT set, it will auto detected by cmake from **PATH**, can missing!

## The following values do not recommend to change

- `DEPS_DOWNLOAD_DIR`, Download root directory, default is **.deps/downloads**
- `DEPS_BUILD_DIR`, External project build directory, default is **.deps/build**
- `DEPS_INSTALL_DIR`, External project install perfix, default is **.deps/usr**
- `DEPS_BIN_DIR`, External project binary install directory, default is **.deps/usr/bin**
- `DEPS_LIB_DIR`, External project library install directory, default is **.deps/usr/lib**
- `DEPS_INCLUDE_DIR`, External project header install directory, default is **.deps/usr/include**

## `BuildDepsRepo(NAME ...)`

which is used for building external repo project(git clone & build)

- `NAME` The external project name, will be cmake top target, can not missing
- `REPO_URL`, The git project repo URL to clone, can not missing
- `PATCH_CMD`, The project patch command, can be missing
- `CONFIG_CMD`, The project config command, can be missing
- `BUILD_CMD`, The project build command, can be missing
- `INSTALL_CMD`, The project install command, can be missing

## `BuildDepsTarBall(NAME ...)`

which is used for building external project(download tarball & build)

- `NAME` The external project name, will be cmake top target, can not missing
- `VERSION`, The project version, can not missing
- `URL`, The project tarball URL to download, can not missing
- `SHA256`, The tarball SHA256 for tarball checking, can not missing
- `PATCH_CMD`, The project patch command, can be missing
- `CONFIG_CMD`, The project config command, can be missing
- `BUILD_CMD`, The project build command, can be missing
- `INSTALL_CMD`, The project install command, can be missing

## `PrebuildInstall(NAME ...)`

which is used for prebuild binary download & install

- `NAME` The prebuild binary name, will be cmake top target, can not missing
- `SKIP`, Skip prebuild binary download & install if true
- `REPO`,  Download prebuild binary repo, patch and install
- `TARBALL`, Download prebuild binary tarball, extract, patch and install
- `URL`, The prebuild binary tarball or repo URL to download, can NOT missing
- `PATCH_CMD`, The prebuild binary patch command, can be missing
- `INSTALL_CMD`, The prebuild binary install command, can NOT missing
- `VERSION`, The prebuild binary version, can not missing
- `SHA256`, The prebuild binary SHA256 for tarball checking, can not missing

# Code Coverage Support

- **${XMAKE}**`_ENABLE_GCOV` enable gcov or not, default is **OFF**

## `CodeCoverageLcovHtml(...)`

Defines a target for running and collection code coverage information.
Builds dependencies if any, runs the given executable and outputs reports.

NOTE! The executable should always have a ZERO as exit code otherwise
the coverage generation will not complete, but this can be skipped by
given `EXECUTABLE_FORCE_SUCCESS`

- `TARGET`, Target name, if not set auto set to `code.coverage-`**name**
- `EXECUTABLE`, Executable to run, can not missing
- `EXECUTABLE_ARGS`, Executable arguments, can be missing
- `DEPENDENCIES`, Dependencies to build first, can be missing
- `LCOV_ARGS`, Extra arguments for lcov, can be missing
- `LCOV_EXCLUDES`, Report exclude patterns, can be missing, auto remove system
- `GENHTML_ARGS`, Extra arguments for genhtml, can be missing
- `EXECUTABLE_FORCE_SUCCESS`, Executable force success if set

## `CodeCoverageLcovTrace(...)` and `CodeCoverageLcovTraceReport(...)`

Running executable with different args and collection code coverage information.
Builds dependencies if any, runs the given executable and outputs reports.

NOTE! The executable should always have a ZERO as exit code otherwise
the coverage generation will not complete, but this can be skipped by
given `EXECUTABLE_FORCE_SUCCESS`

- `TARGET`, Target name for `CodeCoverageLcovTraceReport`
- `TEST_NAME`, Test name for executable to run with given args for `CodeCoverageLcovTrace`

- `EXECUTABLE`, Executable to run, can not missing
- `EXECUTABLE_ARGS`, Executable arguments, can be missing
- `DEPENDENCIES`, Dependencies to build first, can be missing
- `LCOV_ARGS`, Extra arguments for lcov, can be missing
- `LCOV_EXCLUDES`, Report exclude patterns, can be missing, auto remove system
- `GENHTML_ARGS`, Extra arguments for genhtml, can be missing
- `EXECUTABLE_FORCE_SUCCESS`, Executable force success if set

## `CodeCoverageGcovrXml(...)`, `CodeCoverageGcovrHtml(...)` and `CodeCoverageGcovrText(...)`

- `TARGET`, Target name, if not set auto set to `code.coverage-`**name**
- `EXECUTABLE`, Executable to run, can not missing
- `EXECUTABLE_ARGS`, Executable arguments, can be missing
- `DEPENDENCIES`, Dependencies to build first, can be missing
- `GCOVR_ARGS`, Extra arguments for gcovr, can be missing
- `GCOVR_EXCLUDES`, Extra arguments for gcovr, can be missing, auto remove system
- `EXECUTABLE_FORCE_SUCCESS`, Executable force success if set

## `CodeCoverageAppendFlags()`

Append C/C++ compiler flags for code coverage.
