#ifndef _DAMPL_ARRAY_
#define _DAMPL_ARRAY_

/* Array structure */

typedef struct
{
    void * a;
    int size;
    void (*insert) (Array *, int, void *);
    void (*append) (Array *, void *);
    void (*get) (Array, int);
}Array;

/* Array constructor for every type*/

Array dampl_arr_new__arr (Array *);

Array dampl_arr_new__int (int *);

Array dampl_arr_new__float (float *);

Array dampl_arr_new__str (String *);

//Array dampl_arr_new__tup (Tuple * a);

/* Array insertion method */

void dampl_arr_insert__arr (Array *, int, Array);

void dampl_arr_insert__int (Array *, int, int);

void dampl_arr_insert__float (Array *, int, float);

void dampl_arr_insert__str (Array *, int, String);

//void dampl_arr_insert__tup (Array *, int, Tuple *);

/* Array append method */

void dampl_arr_append__arr (Array *, Array);

void dampl_arr_append__int (Array *, int); 

void dampl_arr_append__float (Array *, float); 

void dampl_arr_append__str (Array *, String); 

//void dampl_arr_append__tup (Array *, Tuple *); 

/* Array get method */

Array dampl_arr_get__arr (Array, int);

int dampl_arr_get__int (Array, int);

float dampl_arr_get__float (Array, int);

String dampl_arr_get__str (Array, int);

//Tuple dampl_arr_get__tup (Array, int);

#endif