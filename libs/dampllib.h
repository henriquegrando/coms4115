#ifndef _DAMPL_LIB_
#define _DAMPL_LIB_

#include "damplio.h"
#include "damplstr.h"
#include "damplarray.h"
#include "dampltup.h"


String dampl_str__str (String string);

String dampl_str__float (float f);

String dampl_str__int (int i);

String dampl_str__bool (int);


String dampl_str_arr__int (Array, int);

String dampl_str_arr__float (Array, int);

String dampl_str_arr__str (Array, int);

String dampl_str_arr__tup (Array, int);

String dampl_str__tup (Tuple);

Array build_args_array(String*);


void dampl_die__(void);

#endif