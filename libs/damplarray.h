#ifndef _DAMPL_ARRAY_
#define _DAMPL_ARRAY_

#include "damplstr.h"
#include "dampltup.h"
#include <stdlib.h>

/* Array structure */

typedef struct
{
    void * a;
    int size;
    int capacity;
} * Array;

/* Array constructor for every type */

Array dampl_arr_new();

/* Length function */

int dampl_arr_len(Array);

/* Array add method 
   Appends an element in the end of the array */

void dampl_arr_append__arr (Array, Array);

int dampl_arr_append__int (Array, int);

float dampl_arr_append__float (Array, float);

String dampl_arr_append__str (Array, String);

Tuple dampl_arr_append__tup (Array, Tuple);


/* Array insertion method 
   Insert an element in a given position, shifting all elements after it */

Array dampl_arr_insert__arr (Array, int, Array);

int dampl_arr_insert__int (Array, int, int);

float dampl_arr_insert__float (Array, int, float);

String dampl_arr_insert__str (Array, int, String);

Tuple dampl_arr_insert__tup (Array, int, Tuple);

/* Array set method
   Set a given position in an array to the value passed by the user */

Array dampl_arr_set__arr (Array, int, Array);

int dampl_arr_set__int (Array, int, int); 

float dampl_arr_set__float (Array, int, float); 

String dampl_arr_set__str (Array, int, String); 

Tuple dampl_arr_set__tup (Array, int, Tuple); 

/* Array get method 
   Returns an element in a given position */

Array dampl_arr_get__arr (Array, int);

int dampl_arr_get__int (Array, int);

float dampl_arr_get__float (Array, int);

String dampl_arr_get__str (Array, int);

Tuple dampl_arr_get__tup (Array, int);


/* Extract attribute from table (array of tuples) */

Array dampl_arr_extract_attr__int(Array, int);

Array dampl_arr_extract_attr__float(Array, int);

Array dampl_arr_extract_attr__str(Array, int);

/* Set attribute of table (array of tuples)
	Checks if array containing values are of
			same size as table */

Array dampl_arr_set_attr__int(Array, int, Array);

Array dampl_arr_set_attr__float(Array, int, Array);

Array dampl_arr_set_attr__str(Array, int, Array);

/* Array ensure capacity method */

void dampl_arr_ensure_cap__arr (Array, int);

void dampl_arr_ensure_cap__int (Array, int);

void dampl_arr_ensure_cap__float (Array, int);

void dampl_arr_ensure_cap__str (Array, int);

void dampl_arr_ensure_cap__tup (Array, int);


/* Concatenates arrays */

Array dampl_arr_concat__arr (Array, Array);

Array dampl_arr_concat__int (Array, Array);

Array dampl_arr_concat__float (Array, Array);

Array dampl_arr_concat__str (Array, Array);

Array dampl_arr_concat__tup (Array, Array);


/* Set Range Functions */

Array dampl_arr_set_range__arr (Array, int, int, Array);

Array dampl_arr_set_range__int (Array, int, int, Array);

Array dampl_arr_set_range__float (Array, int, int, Array);

Array dampl_arr_set_range__str (Array, int, int, Array);

Array dampl_arr_set_range__tup (Array, int, int, Array);


/* Get Range Functions */

Array dampl_arr_get_range__arr (Array, int, int);

Array dampl_arr_get_range__int (Array, int, int);

Array dampl_arr_get_range__float (Array, int, int);

Array dampl_arr_get_range__str (Array, int, int);

Array dampl_arr_get_range__tup (Array, int, int);


Tuple dampl_tup_convert(Array, int, type_map);


#endif