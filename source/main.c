#include <stdint.h>
#include <stdio.h>

#ifdef XMAKE_EXPORT_AS_CONFIG_FILE
    #include "config.generated.h"
#endif

#include "library.h"

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
    library();

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
    printf("XMAKE_VERSION_MAJOR     : %d\n", XMAKE_VERSION_MAJOR);
    printf("XMAKE_VERSION_MINOR     : %d\n", XMAKE_VERSION_MINOR);
    printf("XMAKE_VERSION_PATCH     : %d\n", XMAKE_VERSION_PATCH);
    printf("XMAKE_VERSION_TWEAK     : %s\n", XMAKE_VERSION_TWEAK);
    printf("XMAKE_RELEASE_TYPE      : %s\n", XMAKE_RELEASE_TYPE);
    printf("XMAKE_RELEASE_VERSION   : %s\n", XMAKE_RELEASE_VERSION);
    printf("XMAKE_RELEASE_TIMESTAMP : %s\n", XMAKE_RELEASE_TIMESTAMP);

    return 0;
}
