#!/bin/env bash

# Windows MSYS2

SysArch=$1
IsStaticQt5=$2

if [ "${SysArch}" = "x86" ]; then
    pkgPrefix="mingw-w64-i686"
elif [ "${SysArch}" = "x86_64" ]; then
    pkgPrefix="mingw-w64-x86_64"
else
    echo "$0 x86/x86_64 [static]"
    echo "- x86        install for mingw32"
    echo "- x86_64     install for mingw64"
    echo "- x86        install static Qt5 or not"
    exit 0
fi

pkgSuffix=
if [ "${IsStaticQt5}" = "static" ]; then
    pkgSuffix="-static"
fi

# install tools
pacman -S gperf
pacman -S unzip
pacman -S git
pacman -S curl
pacman -S cmake
pacman -S libtool
pacman -S libtool-bin
pacman -S automake
pacman -S pkg-config
pacman -S gettext
pacman -S openssl
pacman -S python
pacman -S cppcheck

pacman -S ${pkgPrefix}-git
pacman -S ${pkgPrefix}-gcc
pacman -S ${pkgPrefix}-libtool
pacman -S ${pkgPrefix}-make
pacman -S ${pkgPrefix}-pkg-config
pacman -S ${pkgPrefix}-unibilium
pacman -S ${pkgPrefix}-cmake
pacman -S ${pkgPrefix}-perl
pacman -S ${pkgPrefix}-python2 
pacman -S ${pkgPrefix}-jasper
pacman -S ${pkgPrefix}-libssh

pacman -S ${pkgPrefix}-qt5${pkgSuffix}

# git commit style configurations
echo "https://github.com/gkide/repo-hooks"