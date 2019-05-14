# xmake cmake APIs

- [XmakeInstallHelper](xmakeinstallhelper)
- [XmakeGetInstallBinaries](xmakegetinstallbinaries)

## XmakeInstallHelper

This is a `cmake` **install** wrapper for convenience, here **XXX** the project
name of upper case, the following variables will auto defined by xmake.

- **XXX**`_INSTALL_DIR`     => `${CMAKE_INSTALL_PREFIX}`
- **XXX**`_INSTALL_BIN_DIR` => `${CMAKE_INSTALL_PREFIX}/bin`
- **XXX**`_INSTALL_ETC_DIR` => `${CMAKE_INSTALL_PREFIX}/etc`
- **XXX**`_INSTALL_DOC_DIR` => `${CMAKE_INSTALL_PREFIX}/doc`
- **XXX**`_INSTALL_LIB_DIR` => `${CMAKE_INSTALL_PREFIX}/lib`
- **XXX**`_INSTALL_SHA_DIR` => `${CMAKE_INSTALL_PREFIX}/share`
- **XXX**`_INSTALL_PLG_DIR` => `${CMAKE_INSTALL_PREFIX}/plugin`
- **XXX**`_INSTALL_INC_DIR` => `${CMAKE_INSTALL_PREFIX}/include`

The install directory layout is as following:

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

Get all the binary targets(executable, library) of `XmakeInstallHelper`

``` cmake
XmakeGetInstallBinaries(binaries)
foreach(item ${binaries})
    message(STATUS "Install: ${item}")
endforeach()
```
