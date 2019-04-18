#!/usr/bin/env bash

host_os="Unknown"

os_type=$(uname -a | grep '[L|l]inux')
if [ "${os_type}" != "" ]; then
    host_os="Linux"
fi

os_type=$(uname -a | grep '[D|d]arwin')
if [ "${os_type}" != "" ]; then
    host_os="MacOS"
fi

os_type=$(uname -a | grep '^MSYS_NT-*')
if [ "${os_type}" != "" ]; then
    host_os="Windows MSYS shell"
fi

os_type=$(uname -a | grep '^MINGW[3|6][2|4]_NT*')
if [ "${os_type}" != "" ]; then
    host_os="Windows MinGW shell"
fi

os_type=$(uname -a | grep '^CYGWIN_NT*')
if [ "${os_type}" != "" ]; then
    host_os="Windows Cygwin shell"
fi

if [ "${host_os}" = "Unknown" ]; then
    echo -e "\033[31mError\033[0m: Host System Unknown!"
    exit 1
fi

echo -e "Host System: \033[33m${host_os}\033[0m"

bash --version | head -n1 | cut -d" " -f2-4

prog=$(readlink -f /bin/sh)
echo -e "Found: \033[32m/bin/sh\033[0m => ${prog}"

prog=$(which gcc 2> /dev/null)
if [ "${prog}" = "" ]; then
    echo -e "Not Found: \033[31mgcc\033[0m"
else
    echo -e "Found: \033[32m${prog}\033[0m =>" $(gcc --version 2> /dev/null | head -n1)
fi

prog=$(which g++ 2> /dev/null)
if [ "${prog}" = "" ]; then
    echo -e "Not Found: \033[31mg++\033[0m"
else
    echo -e "Found: \033[32m${prog}\033[0m =>" $(g++ --version 2> /dev/null | head -n1)
fi

prog=$(which ldd 2> /dev/null)
if [ "${prog}" = "" ]; then
    echo -e "Not Found: \033[31mldd\033[0m"
else
    echo -e "Found: \033[32m${prog}\033[0m =>" $(ldd --version 2> /dev/null | head -n1 | cut -d" " -f2-)
fi

prog=$(which clang 2> /dev/null)
if [ "${prog}" = "" ]; then
    echo -e "Not Found: \033[31mclang\033[0m"
else
    echo -e "Found: \033[32m${prog}\033[0m =>" $(clang --version 2> /dev/null | head -n1)
fi

prog=$(which clang++ 2> /dev/null)
if [ "${prog}" = "" ]; then
    echo -e "Not Found: \033[31mclang++\033[0m"
else
    echo -e "Found: \033[32m${prog}\033[0m =>" $(clang++ --version 2> /dev/null | head -n1)
fi

prog=$(which otool 2> /dev/null)
if [ "${prog}" = "" ]; then
    echo -e "Not Found: \033[31motool\033[0m"
else
    echo -e "Found: \033[32m${prog}\033[0m =>" $(otool --version 2> /dev/null | head -n1 | cut -d" " -f2-)
fi

prog=$(which i686-w64-mingw32-gcc 2> /dev/null)
if [ "${prog}" = "" ]; then
    echo -e "Not Found: \033[31mi686-w64-mingw32-gcc\033[0m"
else
    echo -e "Found: \033[32m${prog}\033[0m =>" $(i686-w64-mingw32-gcc --version 2> /dev/null | head -n1)
fi

prog=$(which i686-w64-mingw32-g++ 2> /dev/null)
if [ "${prog}" = "" ]; then
    echo -e "Not Found: \033[31mi686-w64-mingw32-g++\033[0m"
else
    echo -e "Found: \033[32m${prog}\033[0m =>" $(i686-w64-mingw32-g++ --version 2> /dev/null | head -n1)
fi

prog=$(which x86_64-w64-mingw32-gcc 2> /dev/null)
if [ "${prog}" = "" ]; then
    echo -e "Not Found: \033[31mx86_64-w64-mingw32-gcc\033[0m"
else
    echo -e "Found: \033[32m${prog}\033[0m =>" $(x86_64-w64-mingw32-gcc --version 2> /dev/null | head -n1)
fi

prog=$(which x86_64-w64-mingw32-g++ 2> /dev/null)
if [ "${prog}" = "" ]; then
    echo -e "Not Found: \033[31mx86_64-w64-mingw32-g++\033[0m"
else
    echo -e "Found: \033[32m${prog}\033[0m =>" $(x86_64-w64-mingw32-g++ --version 2> /dev/null | head -n1)
fi

prog=$(which git 2> /dev/null)
if [ "${prog}" = "" ]; then
    echo -e "Not Found: \033[31mgit\033[0m"
else
    echo -e "Found: \033[32m${prog}\033[0m =>" $(git --version 2> /dev/null | head -n1)
fi

prog=$(which cmake 2> /dev/null)
if [ "${prog}" = "" ]; then
    echo -e "Not Found: \033[31mcmake\033[0m"
else
    echo -e "Found: \033[32m${prog}\033[0m =>" $(cmake --version 2> /dev/null | head -n1)
fi

prog=$(which curl 2> /dev/null)
if [ "${prog}" = "" ]; then
    echo -e "Not Found: \033[31mcurl\033[0m"
else
    echo -e "Found: \033[32m${prog}\033[0m =>" $(curl --version 2> /dev/null | head -n1 | cut -d" " -f1-3)
fi

prog=$(which libtool 2> /dev/null)
if [ "${prog}" = "" ]; then
    echo -e "Not Found: \033[31mlibtool\033[0m"
else
    echo -e "Found: \033[32m${prog}\033[0m =>" $(libtool --version | head -n1)
fi

prog=$(which autoconf 2> /dev/null)
if [ "${prog}" = "" ]; then
    echo -e "Not Found: \033[31mautoconf\033[0m"
else
    echo -e "Found: \033[32m${prog}\033[0m =>" $(autoconf --version 2> /dev/null | head -n1)
fi

prog=$(which automake 2> /dev/null)
if [ "${prog}" = "" ]; then
    echo -e "Not Found: \033[31mautomake\033[0m"
else
    echo -e "Found: \033[32m${prog}\033[0m =>" $(automake --version 2> /dev/null | head -n1)
fi

prog=$(which m4 2> /dev/null)
if [ "${prog}" = "" ]; then
    prog=$(which gm4 2> /dev/null)
    if [ "${prog}" = "" ]; then
        prog=$(which gnum4 2> /dev/null)
        if [ "${prog}" = "" ]; then
            echo -e "Not Found: \033[31mm4  gm4  gnum4\033[0m"
        else
            echo -e "Found: \033[32m${prog}\033[0m =>" $(gnum4 --version 2> /dev/null | head -n1)
        fi
    else
        echo -e "Found: \033[32m${prog}\033[0m =>" $(gm4 --version 2> /dev/null | head -n1)
    fi
else
    echo -e "Found: \033[32m${prog}\033[0m =>" $(m4 --version 2> /dev/null | head -n1)
fi

prog=$(which unzip 2> /dev/null)
if [ "${prog}" = "" ]; then
    echo -e "Not Found: \033[31munzip\033[0m"
else
    echo -e "Found: \033[32m${prog}\033[0m =>" $(unzip -v 2>&1 | head -n1)
fi

prog=$(which bzip2 2> /dev/null)
if [ "${prog}" = "" ]; then
    check_status="false"
    echo -e "Not Found: \033[31mbzip2\033[0m"
else
    echo -e "Found: \033[32m${prog}\033[0m"
fi

prog=$(which grep 2> /dev/null)
if [ "${prog}" = "" ]; then
    echo -e "Not Found: \033[31mgrep\033[0m"
else
    echo -e "Found: \033[32m${prog}\033[0m =>" $(grep --version | head -n1)
fi

prog=$(which python 2> /dev/null)
if [ "${prog}" = "" ]; then
    echo -e "Not Found: \033[31mpython\033[0m"
else
    echo -e "Found: \033[32m${prog}\033[0m =>" $(python --version 2>&1)
fi

prog=$(which node 2> /dev/null)
if [ "${prog}" = "" ]; then
    echo -e "Not Found: \033[31mnode\033[0m"
else
    echo -e "Found: \033[32m${prog}\033[0m =>" $(node --version | head -n1)
fi

prog=$(which npm 2> /dev/null)
if [ "${prog}" = "" ]; then
    echo -e "Not Found: \033[31mnpm\033[0m"
else
    echo -e "Found: \033[32m${prog}\033[0m =>" $(npm --version | head -n1)
fi

prog=$(which standard-release 2> /dev/null)
if [ "${prog}" = "" ]; then
    echo -e "Not Found: \033[31mstandard-release\033[0m"
else
    echo -e "Found: \033[32m${prog}\033[0m =>" $(standard-release --version | head -n1)
fi
