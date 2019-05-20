# Change Log

- ALL NOTABLE CHANGES WILL BE DOCUMENTED HERE.
- PROJECT VERSIONS ADHERE TO [SEMANTIC VERSIONING](http://semver.org).
- REPOSITORY COMMITS ADHERE TO [CONVENTIONAL COMMITS](https://conventionalcommits.org).


## 2019-05-20 22:12:20 +0800 Release [v1.0.0-rc](https://github.com/gkide/xmake/releases/tag/v1.0.0-rc)

[[☕](#v_Features_201905202212200800)]
[[☀](#v_Fixed_201905202212200800)]
[[⛭](#v_Changed_201905202212200800)]
[[☂](#v_Dependencies_201905202212200800)]
comparing with [v1.0.0-rc-dev](https://github.com/gkide/xmake/compare/v1.0.0-rc-dev...v1.0.0-rc)

<span id = "v_Features_201905202212200800"></span>
### ☕ Features
- **feat**(`win`): copy DLLs for windows app, more cmake API ([abe80a0](https://github.com/gkide/xmake/commit/abe80a0))
- **feat**: qt5 app hard-coded and dynamic rcc file ([5636bfa](https://github.com/gkide/xmake/commit/5636bfa))
- **feat**: init AppImage packaging ([8bf00c4](https://github.com/gkide/xmake/commit/8bf00c4))
- **feat**: get c/c++ compiler flags ([a884777](https://github.com/gkide/xmake/commit/a884777))
- **feat**: qt IFW support ([2515128](https://github.com/gkide/xmake/commit/2515128))
- **feat**: xmake cmake init ([0c65968](https://github.com/gkide/xmake/commit/0c65968))
- **feat**: xmake.init => xmake.init.mk, add xmake.init.cmake ([1e8cec9](https://github.com/gkide/xmake/commit/1e8cec9))
- **feat**: xmake.init makefile ([1c1e868](https://github.com/gkide/xmake/commit/1c1e868))

<span id = "v_Fixed_201905202212200800"></span>
### ☀ Fixed
- **fix**(`win`): remove copy app DLLs cmake warnings ([7423547](https://github.com/gkide/xmake/commit/7423547))
- **fix**: when do not have ccr tools just warning, do not as error ([86be15a](https://github.com/gkide/xmake/commit/86be15a))
- **fix**: pkg license current year ([650f1a5](https://github.com/gkide/xmake/commit/650f1a5))
- **fix**(`win`): nsis set NSIS windows build fix ([9f673f4](https://github.com/gkide/xmake/commit/9f673f4))
- **fix**: appimage icon files install into apps/ directory ([b890541](https://github.com/gkide/xmake/commit/b890541))
- **fix**: xmake init bug fix ([e5e3727](https://github.com/gkide/xmake/commit/e5e3727))
- **fix**: cpack must provided license/destcription file ([c77698d](https://github.com/gkide/xmake/commit/c77698d))

<span id = "v_Changed_201905202212200800"></span>
### ⛭ Changed
- **perf**(`win`): windows MinGW64 IFM/NSIS package ([1f67b3a](https://github.com/gkide/xmake/commit/1f67b3a))

<span id = "v_Dependencies_201905202212200800"></span>
### ☂ Dependencies
- **build**: google test use git repo ([6559a55](https://github.com/gkide/xmake/commit/6559a55))
- **build**(`win`): package NSIS do not require admin ([aac9259](https://github.com/gkide/xmake/commit/aac9259))
- **build**: xmake source package build name ([f6831ad](https://github.com/gkide/xmake/commit/f6831ad))

## 2019-05-16 03:18:49 +0800 Release [v1.0.0-rc-dev](https://github.com/gkide/xmake/releases/tag/v1.0.0-rc-dev)

[[☕](#v_Features_201905160318490800)]
[[☀](#v_Fixed_201905160318490800)]
[[⛭](#v_Changed_201905160318490800)]
[[☂](#v_Dependencies_201905160318490800)]

<span id = "v_Features_201905160318490800"></span>
### ☕ Features
- **feat**: no build binary deb package ([fe3a93e](https://github.com/gkide/xmake/commit/fe3a93e))
- **feat**: doxygen and cpack do not share the same option ([790ee90](https://github.com/gkide/xmake/commit/790ee90))
- **feat**: add options to control ctest/gtest build or not respectively ([050fe4a](https://github.com/gkide/xmake/commit/050fe4a))
- **feat**: convert semver to a number ([73ebb13](https://github.com/gkide/xmake/commit/73ebb13))
- **feat**: add API to get the binary targets prepared to install ([406638b](https://github.com/gkide/xmake/commit/406638b))
- **feat**: linux do package add debian format ([d58aa6b](https://github.com/gkide/xmake/commit/d58aa6b))
- **feat**: support package checking local license & description file ([8286c85](https://github.com/gkide/xmake/commit/8286c85))
- **feat**: doxygen enable local config by end user ([0d509e0](https://github.com/gkide/xmake/commit/0d509e0))
- **feat**: copy dlls as needed, such Qt5 dlls, can be config by user ([8f9c75f](https://github.com/gkide/xmake/commit/8f9c75f))
- **feat**: do not support MSVC checker ([bc2e69a](https://github.com/gkide/xmake/commit/bc2e69a))
- **feat**: use REPO/cmake/PkgInstaller.cmake or REPO/PkgInstaller.cmake config ([5b406c1](https://github.com/gkide/xmake/commit/5b406c1))
- **feat**: windows ICO and version info for exe ([0e2d7c9](https://github.com/gkide/xmake/commit/0e2d7c9))
- **feat**: get build timestamp year, month, day separatedly ([60ca2e1](https://github.com/gkide/xmake/commit/60ca2e1))
- **feat**: cpack NSIS custom script with extra info for the installer ([b296a0f](https://github.com/gkide/xmake/commit/b296a0f))
- **feat**: gtest demo, rename Qt5 auto source/libraries vars name ([20fd6af](https://github.com/gkide/xmake/commit/20fd6af))
- **feat**: switch for ctest/gtest, and refactor to Qt5SupportSetup(...) ([36907e2](https://github.com/gkide/xmake/commit/36907e2))
- **feat**: download and build gtest ([1b56d59](https://github.com/gkide/xmake/commit/1b56d59))
- **feat**: demo for cmake ctest usage ([b64d2e1](https://github.com/gkide/xmake/commit/b64d2e1))
- **feat**: valgrind tools auto detected by xmake.mk ([ee929f0](https://github.com/gkide/xmake/commit/ee929f0))
- **feat**: update for doxygen/cpack ([583e9f5](https://github.com/gkide/xmake/commit/583e9f5))
- **feat**: cpack package binary & source make tarballs ([8774fd1](https://github.com/gkide/xmake/commit/8774fd1))
- **feat**: import lcov-1.14 example ([b03f236](https://github.com/gkide/xmake/commit/b03f236))
- **feat**: add common usage macros, XMAKE_* => ${XMAKE}_* ([9317b44](https://github.com/gkide/xmake/commit/9317b44))
- **feat**: doxygen source code manual generating ([ec3fa4d](https://github.com/gkide/xmake/commit/ec3fa4d))
- **feat**: code coverage report of lcov/gcovr ([8c37b43](https://github.com/gkide/xmake/commit/8c37b43))
- **feat**: version format, release script, demo c/c++ and more ([d15ff9c](https://github.com/gkide/xmake/commit/d15ff9c))
- **feat**: init code coverage support ([4ad12f8](https://github.com/gkide/xmake/commit/4ad12f8))
- **feat**: ccache support by default ([ace87a4](https://github.com/gkide/xmake/commit/ace87a4))
- **feat**: env setup & checking ([c0d7c97](https://github.com/gkide/xmake/commit/c0d7c97))
- **feat**: support linux Qt5 static build ([fb153d9](https://github.com/gkide/xmake/commit/fb153d9))
- **feat**: init Qt5 support ([a5fe8a9](https://github.com/gkide/xmake/commit/a5fe8a9))
- **feat**: cmake warning for none normalized tweaks ([6f7819d](https://github.com/gkide/xmake/commit/6f7819d))
- **feat**: support for gcov, assertion, travis ci ([d64b4b8](https://github.com/gkide/xmake/commit/d64b4b8))
- **feat**: gcov support, XMAKE_ENABLE_GCOV ([9b64bb0](https://github.com/gkide/xmake/commit/9b64bb0))
- **feat**: auto detect system common dev tools & update ([c74893b](https://github.com/gkide/xmake/commit/c74893b))
- **feat**: make common rules to cmake/xmake.mk ([f82e0d6](https://github.com/gkide/xmake/commit/f82e0d6))
- **feat**: download & install prebuild binaries ([d0a4346](https://github.com/gkide/xmake/commit/d0a4346))
- **feat**: cmake install helper update ([2958d21](https://github.com/gkide/xmake/commit/2958d21))
- **feat**: make release feature ([e93f2ac](https://github.com/gkide/xmake/commit/e93f2ac))

<span id = "v_Fixed_201905160318490800"></span>
### ☀ Fixed
- **fix**: image size fix, make pretty ([faed5a1](https://github.com/gkide/xmake/commit/faed5a1))
- **fix**: markdown image path fix ([06f7757](https://github.com/gkide/xmake/commit/06f7757))
- **fix**: windows NSIS build version, html manual of start menue ([a639cbb](https://github.com/gkide/xmake/commit/a639cbb))
- **fix**: white space & missing _RELEASE_ ([aacdfc7](https://github.com/gkide/xmake/commit/aacdfc7))
- **fix**: set default license for windows if not set ([a76c8a4](https://github.com/gkide/xmake/commit/a76c8a4))
- **fix**: windows deps build dir depends on the build host ([57b6878](https://github.com/gkide/xmake/commit/57b6878))
- **fix**: use gtest enable none ANSI sybmbols two method(cygwin build) ([e8d741a](https://github.com/gkide/xmake/commit/e8d741a))
- **fix**: auto copy msys-2.0.dll or cygwin1.dll ([29e4c2c](https://github.com/gkide/xmake/commit/29e4c2c))
- **fix**: ignore all build*/,  no default static link for windows ([153fb65](https://github.com/gkide/xmake/commit/153fb65))
- **fix**: default install path for windows-32/windows-64 ([b3d1854](https://github.com/gkide/xmake/commit/b3d1854))
- **fix**: source package by cpcak ignore ${PKG_SOURCE_EXCLUDES} ([55b95d9](https://github.com/gkide/xmake/commit/55b95d9))
- **fix**: install top dir make sure to the name that wanted ([5d76978](https://github.com/gkide/xmake/commit/5d76978))
- **fix**: package skip for Dev/Coverage build ([fa094c2](https://github.com/gkide/xmake/commit/fa094c2))
- **fix**: package helper fix, add pre-define make target, install helper fix ([891dc59](https://github.com/gkide/xmake/commit/891dc59))
- **fix**: the pack dir Release => ReleasePackage ([e884cf8](https://github.com/gkide/xmake/commit/e884cf8))
- **fix**: lcov coverage overide the default settings ([c74608c](https://github.com/gkide/xmake/commit/c74608c))
- **fix**: linux build do not need library like msys ([0f88137](https://github.com/gkide/xmake/commit/0f88137))
- **fix**: tarball downloding & extracting ([891b380](https://github.com/gkide/xmake/commit/891b380))

<span id = "v_Changed_201905160318490800"></span>
### ⛭ Changed
- **refactor**: update doxygen input source patterns ([d500c9e](https://github.com/gkide/xmake/commit/d500c9e))
- **refactor**: rename APIs and update docs ([f08983a](https://github.com/gkide/xmake/commit/f08983a))
- **refactor**: xdemo clean up, use as xmake demo/testing ([45b5d27](https://github.com/gkide/xmake/commit/45b5d27))
- **refactor**: do not add xmake path to 'CMAKE_MODULE_PATH' ([144377a](https://github.com/gkide/xmake/commit/144377a))
- **refactor**: makefile refactor, no meaning changed ([f1485c1](https://github.com/gkide/xmake/commit/f1485c1))
- **refactor**: ${XMAKE}_YEAR/MONTH/DAY => ${XMAKE}_RELEASE_YEAR/MONTH/DAY ([0136ced](https://github.com/gkide/xmake/commit/0136ced))
- **perf**: make lcov API more easy to read and use ([a2a0505](https://github.com/gkide/xmake/commit/a2a0505))
- **perf**: code coverage more clear & performance ([3fbb4cc](https://github.com/gkide/xmake/commit/3fbb4cc))
- **perf**: do not extract deps tarball if it exists ([c559610](https://github.com/gkide/xmake/commit/c559610))

<span id = "v_Dependencies_201905160318490800"></span>
### ☂ Dependencies
- **build**: package and release update ([c63ac7b](https://github.com/gkide/xmake/commit/c63ac7b))
- **build**: binary package of NSIS ([6e04de6](https://github.com/gkide/xmake/commit/6e04de6))
- **build**: make shell script executable ([e6f6f35](https://github.com/gkide/xmake/commit/e6f6f35))
- **build**: cygwin static build ([616b39f](https://github.com/gkide/xmake/commit/616b39f))
- **build**: msys static link to libgcc & libstdc++ ([c36639f](https://github.com/gkide/xmake/commit/c36639f))
- **build**: output to separated build type directory ([9cd37ce](https://github.com/gkide/xmake/commit/9cd37ce))
