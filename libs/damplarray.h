#ifndef _DAMPL_ARRAY_
#define _DAMPL_ARRAY_

#define INITIAL_SIZE 5

/* Array structure */

typedef struct
{
    void * a;
    int size;
    void (*add) (Array *, void *);
    void (*insert) (Array *, int, void *);
    void (*set) (Array *, int, void *);
    void * (*get) (Array, int);
} * Array;

/* Array constructor for every type */

Array dampl_arr_new();


//Array dampl_arr_new__tup ();

/* Array add method 
   Appends an element in the end of the array */

void dampl_arr_add__arr (Array, Array);

int dampl_arr_add__int (Array, int);

float dampl_arr_add__float (Array, float);

String dampl_arr_add__str (Array, String);

Tuple dampl_arr_add__tup (Array, Tuple);


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

Tuple dampl_arr_set__tup (Array, Tuple); 

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

/* Array ensure capacity method */

void dampl_arr_ensure_cap__arr (Array *, int);

void dampl_arr_ensure_cap__int (Array *, int);

void dampl_arr_ensure_cap__float (Array *, int);

void dampl_arr_ensure_cap__str (Array *, int);

//void dampl_arr_ensure_cap__tup (Array *, int);

#endif