# xbuild

cmake & make template for quick project creation!

- `XBUILD`
  `XBUILD` variable will auto set to `${PROJECT_NAME}` of uppercase

- `XBUILD_SKIP_RPATH_ORIGIN`
  If **ON**, **RPATH** will be set to `$ORIGIN/../lib`,
  if **OFF**(default), **RPATH** will be set to empty

- `XBUILD_VERBOSE_MESSAGE`
  If **ON**, do not show verbose xbuild cmake message,
  if **OFF**(default), show verbose xbuild cmake message

# Host Support Status for project `xbuild`

- use cmake `configure_file()` command to get following configurations
- `XBUILD_EXPORT_AS_COMPILER_ARGS` if **ON**, also export as CC cmd args
- `XBUILD_EXPORT_AS_COMPILER_ARGS` if **OFF**(default), do not export to CC

## MacOS

- HOST_LINUX
- HOST_MACOS
- HOST_ARCH_64		      : little endian
- HOST_NAME               : charlie
- HOST_USER               : BlackMacOS.local
- HOST_ARCH               : x86_64
- HOST_SYSTEM_NAME        : macos
- HOST_SYSTEM_VERSION     : 15.0.0
- HOST_OS_DIST_NAME       : Mac OS X
- HOST_OS_DIST_VERSION    : 10.11.1-15B42
- **${XBUILD}**_VERSION_MAJOR    : 1
- **${XBUILD}**_VERSION_MINOR    : 0
- **${XBUILD}**_VERSION_PATCH    : 0
- **${XBUILD}**_VERSION_TWEAK    : release
- **${XBUILD}**_RELEASE_TYPE     : Debug
- **${XBUILD}**_RELEASE_VERSION  : v1.0.0-release~20190411@c13ea86
- **${XBUILD}**_RELEASE_TIMESTAMP: 2019-04-10 21:26:52 +0800

## Linux & Likes

- HOST_LINUX
- HOST_ARCH_64            : little endian
- HOST_NAME               : charlie
- HOST_USER               : ThinkPad
- HOST_ARCH               : x86_64
- HOST_SYSTEM_NAME        : linux
- HOST_SYSTEM_VERSION     : 3.16.0-30-generic
- HOST_OS_DIST_NAME       : Ubuntu
- HOST_OS_DIST_VERSION    : 14.04
- **${XBUILD}**_VERSION_MAJOR    : 1
- **${XBUILD}**_VERSION_MINOR    : 0
- **${XBUILD}**_VERSION_PATCH    : 0
- **${XBUILD}**_VERSION_TWEAK    : release
- **${XBUILD}**_RELEASE_TYPE     : Debug
- **${XBUILD}**_RELEASE_VERSION  : v1.0.0-release~20190411@a419980
- **${XBUILD}**_RELEASE_TIMESTAMP: 2019-04-10 21:50:38 +0800

## Windows/Msys

- HOST_LINUX
- HOST_WINDOWS
- HOST_WINDOWS_MSYS
- HOST_ARCH_64            : little endian
- HOST_NAME               : 书生
- HOST_USER               : ThinkPad
- HOST_ARCH               : x86_64
- HOST_SYSTEM_NAME        : windows/msys
- HOST_SYSTEM_VERSION     : 2.8.2(0.313/5/3)
- HOST_OS_DIST_NAME       : Windows 7
- HOST_OS_DIST_VERSION    : 6.1.7601
- **${XBUILD}**_VERSION_MAJOR    : 1
- **${XBUILD}**_VERSION_MINOR    : 0
- **${XBUILD}**_VERSION_PATCH    : 0
- **${XBUILD}**_VERSION_TWEAK    : release
- **${XBUILD}**_RELEASE_TYPE     : Debug
- **${XBUILD}**_RELEASE_VERSION  : v1.0.0-release~20190411@bf3c447
- **${XBUILD}**_RELEASE_TIMESTAMP: 2019-04-10 21:26:52 +0800

## Windows/MinGW32

- HOST_WINDOWS
- HOST_WINDOWS_MINGW
- HOST_ARCH_32            : little endian
- HOST_NAME               : 书生
- HOST_USER               : ThinkPad
- HOST_ARCH               : x86
- HOST_SYSTEM_NAME        : windows/mingw
- HOST_SYSTEM_VERSION     : 6.1.7601
- HOST_OS_DIST_NAME       : Windows 7
- HOST_OS_DIST_VERSION    : 6.1.7601
- **${XBUILD}**_VERSION_MAJOR    : 1
- **${XBUILD}**_VERSION_MINOR    : 0
- **${XBUILD}**_VERSION_PATCH    : 0
- **${XBUILD}**_VERSION_TWEAK    : release
- **${XBUILD}**_RELEASE_TYPE     : Debug
- **${XBUILD}**_RELEASE_VERSION  : v1.0.0-release~20190411@bf3c447
- **${XBUILD}**_RELEASE_TIMESTAMP: 2019-04-10 21:57:53

## Windows/MinGW64

- HOST_WINDOWS
- HOST_WINDOWS_MINGW
- HOST_ARCH_64            : little endian
- HOST_NAME               : 书生
- HOST_USER               : ThinkPad
- HOST_ARCH               : x86_64
- HOST_SYSTEM_NAME        : windows/mingw
- HOST_SYSTEM_VERSION     : 6.1.7601
- HOST_OS_DIST_NAME       : Windows 7
- HOST_OS_DIST_VERSION    : 6.1.7601
- **${XBUILD}**_VERSION_MAJOR    : 1
- **${XBUILD}**_VERSION_MINOR    : 0
- **${XBUILD}**_VERSION_PATCH    : 0
- **${XBUILD}**_VERSION_TWEAK    : release
- **${XBUILD}**_RELEASE_TYPE     : Debug
- **${XBUILD}**_RELEASE_VERSION  : v1.0.0-release~20190411@bf3c447
- **${XBUILD}**_RELEASE_TIMESTAMP: 2019-04-10 21:02:43

## Windows/Cygwin

- HOST_LINUX
- HOST_WINDOWS
- HOST_WINDOWS_CYGWIN
- HOST_ARCH_64            : little endian
- HOST_NAME               : 书生
- HOST_USER               : ThinkPad
- HOST_ARCH               : x86_64
- HOST_SYSTEM_NAME        : windows/cygwin
- HOST_SYSTEM_VERSION     : 3.0.6(0.338/5/3)
- HOST_OS_DIST_NAME       : Windows 7
- HOST_OS_DIST_VERSION    : 6.1.7601
- **${XBUILD}**_VERSION_MAJOR    : 1
- **${XBUILD}**_VERSION_MINOR    : 0
- **${XBUILD}**_VERSION_PATCH    : 0
- **${XBUILD}**_VERSION_TWEAK    : release
- **${XBUILD}**_RELEASE_TYPE     : Debug
- **${XBUILD}**_RELEASE_VERSION  : v1.0.0-release
- **${XBUILD}**_RELEASE_TIMESTAMP: 2019-04-10 21:40:14 +0800

# `InstallHelper` is cmake install helper for convenience

* `${XBUILD}_PREFIX` => `${CMAKE_INSTALL_PREFIX}`, install root
* `${XBUILD}_BINDIR` => `${CMAKE_INSTALL_PREFIX}/bin`, executable
* `${XBUILD}_ETCDIR` => `${CMAKE_INSTALL_PREFIX}/etc`, configuration
* `${XBUILD}_DOCDIR` => `${CMAKE_INSTALL_PREFIX}/doc`, documentation
* `${XBUILD}_LIBDIR` => `${CMAKE_INSTALL_PREFIX}/lib`, C/C++ library
* `${XBUILD}_SHADIR` => `${CMAKE_INSTALL_PREFIX}/share`, share data
* `${XBUILD}_PLGDIR` => `${CMAKE_INSTALL_PREFIX}/plugin`, plugin data
* `${XBUILD}_INCDIR` => `${CMAKE_INSTALL_PREFIX}/include`, C/C++ header

- `TARGETS` of cmake **executables**, **static**/**shared**/**module**
  /**import** libraries will be installed into `${${XBUILD}_BINDIR}` or `${${XBUILD}_LIBDIR}`
  * The executable resources will be installed into `${${XBUILD}_SHADIR}/resource` if NOT **MacOS**

- installs contents of `DIRECTORY` into `DESTINATION` with optional permissions
  * if not set `FILE_PERMISSIONS`, the default value is **rw-r--r--**,
  * if not set `DIRECTORY_PERMISSIONS` the default value is **rwxr-xr-x**

- install `FILES` into `DESTINATION` with optional `FILE_PERMISSIONS`
  * if not set, the default value is **rw-r--r--**, rename if set `RENAME`

- install `PROGRAMS` into `DESTINATION` with optional `FILE_PERMISSIONS`
  * if not set, the default value is **rwxr-xr-x**, rename if set `RENAME`

# Support External Project Build

## The following values can be set by user if need

- `DEPS_ROOT_DIR`, Download & build directory, default is **.deps/**
- `DEPS_BUILD_TYPE`, External project build type, default is **Release**

- `MAKE_PROGRAM`, The GNU make progame used for external project building.
  * If NOT set, then it will auto detected by cmake from **PATH**,
    can not missing! Set `GNU_MAKE` if found for user to be used!
- `GIT_PROGRAM`, The git programe used for clone external project.
  * If NOT set then it will auto detected by cmake from **PATH**,
    can missing! Set `GIT_PROG` if found for user to be used!

## The following values do not recommend to change

- `DEPS_DOWNLOAD_DIR`, Download root directory, default is **.deps/downloads**
- `DEPS_BUILD_DIR`, External project build directory, default is **.deps/build**
- `DEPS_INSTALL_DIR`, External project install perfix, default is **.deps/usr**

- `DEPS_BIN_DIR`, External project binary install directory, default is **.deps/usr/bin**
- `DEPS_LIB_DIR`, External project library install directory, default is **.deps/usr/lib**
- `DEPS_INCLUDE_DIR`, External project header install directory, default is **.deps/usr/include**

## `BuildDepsRepo(NAME ...)`, building external repo project(git clone & build)

- `NAME` The external project name, will be cmake top target, can not missing

- `REPO_URL`, The git project repo URL to clone, can not missing
- `PATCH_CMD`, The project patch command, can be missing
- `CONFIG_CMD`, The project config command, can be missing
- `BUILD_CMD`, The project build command, can be missing
- `INSTALL_CMD`, The project install command, can be missing

## `BuildDepsTarBall(NAME ...)`, building external project(download tarball & build)

- `NAME` The external project name, will be cmake top target, can not missing

- `VERSION`, The project version, can not missing
- `URL`, The project tarball URL to download, can not missing
- `SHA256`, The tarball SHA256 for tarball checking, can not missing
- `PATCH_CMD`, The project patch command, can be missing
- `CONFIG_CMD`, The project config command, can be missing
- `BUILD_CMD`, The project build command, can be missing
- `INSTALL_CMD`, The project install command, can be missing
