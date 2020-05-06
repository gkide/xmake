/// @file source/bar/bar.c

#include <stdio.h>

#include "bar.h"
#include "bar-private.h"

/// This is bar function description
void bar(void)
{
    bar_private();
    printf("This is bar library\n");
}
