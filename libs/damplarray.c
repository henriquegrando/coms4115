#include "dampllib.h"
#include <stdio.h>

void dampl_print__str (char *string)
{
    printf("%s", string);
}

void dampl_print__float (float f)
{
    printf("%.2f", f);
}

void dampl_print__int (int i)
{
    printf("%d", i);
}