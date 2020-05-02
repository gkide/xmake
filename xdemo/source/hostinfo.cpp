#include <stdint.h>
#include <stdio.h>

#ifdef XDEMO_EXPORT_AS_CONFIG_FILE
    #include "config.generated.h"
#endif

#include "macros.h"

#include "bar.h"

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

#ifdef HOST_LINUX
    printf("HOST_LINUX\n");
#endif

#ifdef HOST_MACOS
    printf("HOST_MACOS\n");
#endif

#ifdef HOST_WINDOWS
    printf("HOST_WINDOWS\n");
#endif

#ifdef HOST_WINDOWS_MSYS
    printf("HOST_WINDOWS_MSYS\n");
#endif

#ifdef HOST_WINDOWS_MINGW
    printf("HOST_WINDOWS_MINGW\n");
#endif

#ifdef HOST_WINDOWS_CYGWIN
    printf("HOST_WINDOWS_CYGWIN\n");
#endif

#ifdef HOST_ARCH_32
    printf("HOST_ARCH_32\t\t: %s endian\n", is_big_endian() ? "big" : "little");
#endif

#ifdef HOST_ARCH_64
    printf("HOST_ARCH_64\t\t: %s endian\n", is_big_endian() ? "big" : "little");
#endif

#ifdef HOST_BIG_ENDIAN
    printf("HOST_BIG_ENDIAN\n");
#endif

    printf("HOST_NAME               : %s\n", HOST_NAME);
    printf("HOST_USER               : %s\n", HOST_USER);
    printf("HOST_ARCH               : %s\n", HOST_ARCH);

    printf("HOST_SYSTEM_NAME        : %s\n", HOST_SYSTEM_NAME);
    printf("HOST_SYSTEM_VERSION     : %s\n", HOST_SYSTEM_VERSION);
    printf("HOST_OS_DIST_NAME       : %s\n", HOST_OS_DIST_NAME);
    printf("HOST_OS_DIST_VERSION    : %s\n", HOST_OS_DIST_VERSION);

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

    return 0;
}
