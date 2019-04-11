#include <stdint.h>
#include <stdio.h>

#ifdef XBUILD_EXPORT_AS_CONFIG_FILE
    #include "config.generated.h"
#endif

#include "libC.h"

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
    libC();

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
    printf("XBUILD_VERSION_MAJOR    : %d\n", XBUILD_VERSION_MAJOR);
    printf("XBUILD_VERSION_MINOR    : %d\n", XBUILD_VERSION_MINOR);
    printf("XBUILD_VERSION_PATCH    : %d\n", XBUILD_VERSION_PATCH);
    printf("XBUILD_VERSION_TWEAK    : %s\n", XBUILD_VERSION_TWEAK);
    printf("XBUILD_RELEASE_TYPE     : %s\n", XBUILD_RELEASE_TYPE);
    printf("XBUILD_RELEASE_VERSION  : %s\n", XBUILD_RELEASE_VERSION);
    printf("XBUILD_RELEASE_TIMESTAMP: %s\n", XBUILD_RELEASE_TIMESTAMP);

    return 0;
}
