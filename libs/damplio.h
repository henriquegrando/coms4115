#ifndef _DAMPL_IO_
#define _DAMPL_IO_

#include "damplstr.h"
#include "damplarray.h"

/*
 * Receives a string as parameter to be printed.
 */
void dampl_print__str (String string);

void dampl_print__float (float f);

void dampl_print__int (int i);

Array dampl_strsplit__str (String);

String dampl_readfile__str (String);

void dampl_writefile__str_str (String, String);

#endif