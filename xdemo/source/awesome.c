#include <stdint.h>
#include <stdio.h>

#ifdef XDEMO_EXPORT_AS_CONFIG_FILE
    #include "config.generated.h"
#endif

#include "macros.h"

#include "bar.h"
#include "bar2.h"
#include "foo.h"

int main(int argc, char **argv)
{
    UNUSED_ARG(argc);
    UNUSED_ARG(argv);

    bar();
    bar2();
    foo();
    foo2();
}
