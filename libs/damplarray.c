#include "dampllib.h"
#include <stdio.h>

/* Array constructor for every type */

Array dampl_arr_new__arr ()
{
    Array arr;

    arr.a = (Array *) calloc(INITIAL_SIZE, sizeof(Array));
    arr.size = INITIAL_SIZE;
    arr.add = &dampl_arr_add__arr;
    arr.insert = &dampl_arr_insert__arr;
    arr.set = &dampl_arr_set__arr;
    arr.get = &dampl_arr_get__arr;

    return arr;
}

Array dampl_arr_new__int ()
{
    Array arr;

    arr.a = (int *) calloc(INITIAL_SIZE, sizeof(int));
    arr.size = INITIAL_SIZE;
    arr.add = &dampl_arr_add__int;
    arr.insert = &dampl_arr_insert__int;
    arr.set = &dampl_arr_set__int;
    arr.get = &dampl_arr_get__int;

    return arr;

}


Array dampl_arr_new__float ()
{
    Array arr;

    arr.a = (float *) calloc(INITIAL_SIZE, sizeof(float));
    arr.size = INITIAL_SIZE;
    arr.add = &dampl_arr_add__float;
    arr.insert = &dampl_arr_insert__float;
    arr.set = &dampl_arr_set__float;
    arr.get = &dampl_arr_get__float;

    return arr;
}

Array dampl_arr_new__str ()
{
    Array arr;

    arr.a = (String *) calloc(INITIAL_SIZE, sizeof(String));
    arr.size = INITIAL_SIZE;
    arr.add = &dampl_arr_add__str;
    arr.insert = &dampl_arr_insert__str;
    arr.set = &dampl_arr_set__str;
    arr.get = &dampl_arr_get__str;

    return arr;
}

//Array dampl_arr_new__tup ();