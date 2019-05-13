/// @file source/foobar.c

#include <stdio.h>

#include "bar.h"
#include "bar2.h"
#include "foobar.h"

/// This is foobar function description
void foobar(void)
{
    bar();
    bar2();
    printf("foobar\n");
}
