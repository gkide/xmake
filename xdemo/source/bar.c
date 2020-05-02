/// @file source/bar.c

#include <stdio.h>

#include "bar.h"
#include "bar2.h"

#include "bar-private.h"
#include "bar-private2.h"

/// This is bar function description
void bar(void)
{
    bar_private();
    printf("bar\n");
}

/// This is bar2 function description
void bar2(void)
{
    bar_private2();
    printf("bar2\n");
}
