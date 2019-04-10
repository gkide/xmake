# xbuild

cmake & make template for quick project creation!

# Support
- MacOS
- Linux & likes
- Windows/Msys
- WIndows/MinGW
- Windows/Cygwin

# Support External Project Build

## The following values can be set by user if need

- `DEPS_ROOT_DIR`, Download & build directory, default is **.deps/**
- `DEPS_BUILD_TYPE`, External project build type, default is **Release**

- `MAKE_PROGRAM`, The GNU make progame used for external project building. If
   NOT set, then it will auto detected by cmake from **PATH**, can not missing!
   Set `GNU_MAKE` if found for user to be used!
- `GIT_PROGRAM`, The git programe used for clone external project. If NOT set
   then it will auto detected by cmake from **PATH**, can missing!
   Set `GIT_PROG` if found for user to be used!

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