#include <stdint.h>
#include <stdio.h>

#include "bar/bar.h"
#include "macros.h"
#include "generated/config.h"

static int is_big_endian(void)
{
    union
    {
        uint32_t i;
        char c[sizeof(uint32_t)];
    } test;
    test.i = 1;
    return test.c[0] == 0;
}

int main(int argc, char **argv)
{
    UNUSED_ARG(argc);
    UNUSED_ARG(argv);

    bar();

    printf("*********************************************************\n");

#ifdef UNIX
    printf("UNIX\n");
#endif

#ifdef APPLE
    printf("APPLE\n");
#endif

#ifdef WIN32
    printf("WIN32\n");
#endif

#ifdef MSYS
    printf("MSYS\n");
#endif

#ifdef MINGW
    printf("MINGW\n");
#endif

#ifdef CYGWIN
    printf("CYGWIN\n");
#endif

#ifdef ARCH_32
    printf("ARCH_32\t\t: %s endian\n", is_big_endian() ? "big" : "little");
#endif

#ifdef ARCH_64
    printf("ARCH_64\t\t: %s endian\n", is_big_endian() ? "big" : "little");
#endif

#ifdef IS_BIG_ENDIAN
    printf("IS_BIG_ENDIAN\n");
#endif

    printf("HOST_NAME               : %s\n", HOST_NAME);
    printf("HOST_USER               : %s\n", HOST_USER);

    printf("HOST_OS_INFO            : %s\n", HOST_OS_INFO);
    printf("HOST_SYSTEM_VERSION     : %s\n", HOST_SYSTEM_VERSION);
    printf("HOST_DIST_NAME          : %s\n", HOST_DIST_NAME);
    printf("HOST_DIST_VERSION       : %s\n", HOST_DIST_VERSION);

    printf("*********************************************************\n");

    printf("XDEMO_VERSION_MAJOR     : %d\n", XDEMO_VERSION_MAJOR);
    printf("XDEMO_VERSION_MINOR     : %d\n", XDEMO_VERSION_MINOR);
    printf("XDEMO_VERSION_PATCH     : %d\n", XDEMO_VERSION_PATCH);
    printf("XDEMO_VERSION_TWEAK     : %s\n", XDEMO_VERSION_TWEAK);

    printf("XDEMO_RELEASE_TYPE      : %s\n", XDEMO_RELEASE_TYPE);
    printf("XDEMO_RELEASE_VERSION   : %s\n", XDEMO_RELEASE_VERSION);
    printf("XDEMO_RELEASE_TIMESTAMP : %s\n", XDEMO_RELEASE_TIMESTAMP);

    printf("XDEMO_COMMIT_ZONE       : %s\n", XDEMO_COMMIT_ZONE);
    printf("XDEMO_COMMIT_TIME       : %s\n", XDEMO_COMMIT_TIME);
    printf("XDEMO_COMMIT_DATE       : %s\n", XDEMO_COMMIT_DATE);
    printf("XDEMO_COMMIT_HASH       : %s\n", XDEMO_COMMIT_HASH);
    printf("XDEMO_COMMIT_MDTZ       : %s\n", XDEMO_COMMIT_MDTZ);

    printf("*********************************************************\n");

    return 0;
}
