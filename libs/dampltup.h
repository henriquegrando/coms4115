#ifndef _DAMPL_TUP_
#define _DAMPL_TUP_

/* Array structure */

#include "damplstr.h"

typedef struct
{
    String* values;
    int size;
} * Tuple;


Tuple dampl_tup_new (int size);


/* Length function */

int dampl_tup_len(Tuple);


/* Tuple insertion method */

int dampl_tup_set__int(Tuple, int, int);

float dampl_tup_set__float(Tuple, int, float);

String dampl_tup_set__str(Tuple, int, String);


int dampl_tup_get__int(Tuple, int);

float dampl_tup_get__float(Tuple, int);

String dampl_tup_get__str(Tuple, int);



#endif