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

void dampl_print__bool (int);

/* Prints array */

void dampl_print_arr__int (Array, int);

void dampl_print_arr__float (Array, int);

void dampl_print_arr__str (Array, int);

void dampl_print_arr__tup (Array, int);


/* Prints Tuple */
void dampl_print__tup (Tuple);


Array dampl_strsplit__str_str (String, String);

String dampl_readfile__str (String);

void dampl_writefile__str_str (String, String);


void dampl_file_constructor();

int dampl_open__str_str(String, String);

void dampl_close__int(int);

String dampl_readline__int(int);

void dampl_writeline__int_String(int, String);

#endif