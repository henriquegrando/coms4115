#include "damplarray.h"
#include <stdio.h>

/* Constructor */

Array dampl_arr_new()
{
    Array arr = (Array) malloc (sizeof(Array*));
    arr->a = NULL;
    arr->size = 0;
    arr->capacity = 0;

    return arr;
}

/* Length */

int dampl_arr_len(Array arr)
{
    return arr->size;
}

/* Append */

void dampl_arr_append__arr (Array this, Array value)
{
    dampl_arr_ensure_cap__arr (this, this->size + 1);

    ((Array *) this->a)[this->size++] = value;
}

int dampl_arr_append__int (Array this, int value)
{
    dampl_arr_ensure_cap__int (this, this->size + 1);

    return ((int *) this->a)[this->size++] = value;
}

float dampl_arr_append__float (Array this, float value)
{
    dampl_arr_ensure_cap__float (this, this->size + 1);

    return ((float *) this->a)[this->size++] = value;
}

String dampl_arr_append__str (Array this, String value)
{
    dampl_arr_ensure_cap__str (this, this->size + 1);

    return ((String *) this->a)[this->size++] = value;
}

Tuple dampl_arr_append__tup (Array this, Tuple value)
{
    dampl_arr_ensure_cap__tup (this, this->size + 1);

    return ((Tuple *) this->a)[this->size++] = value;
}

/* Insert */

Array dampl_arr_insert__arr (Array this, int index, Array value)
{
    /* Check border conditions */

    if (index >= this->size || index < 0)
    {
        fprintf(stderr, "Array out of bounds exception\n");
        exit(1);
    }

    dampl_arr_ensure_cap__arr (this, this->size + 1);

    /* Insert into array */

    int i;
    for (i = this->size++; i > index; i--)
    {
        ((Array *) this->a)[i] = ((Array *) this->a)[i - 1];
    }
    return ((Array *) this->a)[i] = value;
}

int dampl_arr_insert__int (Array this, int index, int value)
{
    /* Check border conditions */

    if (index >= this->size || index < 0)
    {
        fprintf(stderr, "Array out of bounds exception\n");
        exit(1);
    }

    dampl_arr_ensure_cap__int (this, this->size + 1);

    /* Insert into array */

    int i;
    for (i = this->size++; i > index; i--)
    {
        ((int *) this->a)[i] = ((int *) this->a)[i - 1];
    }
    return ((int *) this->a)[i] = value;

}

float dampl_arr_insert__float (Array this, int index, float value)
{
    /* Check border conditions */

    if (index >= this->size || index < 0)
    {
        fprintf(stderr, "Array out of bounds exception\n");
        exit(1);
    }

    dampl_arr_ensure_cap__float (this, this->size + 1);

    /* Insert into array */

    int i;
    for (i = this->size++; i > index; i--)
    {
        ((float *) this->a)[i] = ((float *) this->a)[i - 1];
    }
    return ((float *) this->a)[i] = value;
}

String dampl_arr_insert__str (Array this, int index, String value)
{
    /* Check border conditions */

    if (index >= this->size || index < 0)
    {
        fprintf(stderr, "Array out of bounds exception\n");
        exit(1);
    }

    dampl_arr_ensure_cap__str (this, this->size + 1);

    /* Insert into array */

    int i;
    for (i = this->size++; i > index; i--)
    {
        ((String *) this->a)[i] = ((String *) this->a)[i - 1];
    }
    return ((String *) this->a)[i] = value;
}

Tuple dampl_arr_insert__tup (Array this, int index, Tuple value)
{
    /* Check border conditions */

    if (index >= this->size || index < 0)
    {
        fprintf(stderr, "Array out of bounds exception\n");
        exit(1);
    }

    dampl_arr_ensure_cap__tup (this, this->size + 1);

    /* Insert into array */

    int i;
    for (i = this->size++; i > index; i--)
    {
        ((Tuple *) this->a)[i] = ((Tuple *) this->a)[i - 1];
    }
    return ((Tuple *) this->a)[i] = value;
}


/* Ensure capacity */

void dampl_arr_ensure_cap__arr (Array this, int sz)
{
    if (this->capacity < sz)
    {
        this->capacity = sz * 2;

        /* Create new array */

        Array *arr = (Array *) malloc (this->capacity * sizeof(Array));

        /* Copy all elements to new array */

        int i;

        for (i = 0; i < this->size; i++)
        {
            arr[i] = ((Array *) this->a)[i];
        }

        free(this->a);

        this->a = arr;
    }
}

void dampl_arr_ensure_cap__int (Array this, int sz)
{
    if (this->capacity < sz)
    {
        this->capacity = sz * 2;

        /* Create new array */

        int *arr = (int *) malloc (this->capacity * sizeof(int));

        /* Copy all elements to new array */

        int i;

        for (i = 0; i < this->size; i++)
        {
            arr[i] = ((int *) this->a)[i];
        }

        free(this->a);

        this->a = arr;
    }
}

void dampl_arr_ensure_cap__float (Array this, int sz)
{
    if (this->capacity < sz)
    {
        this->capacity = sz * 2;

        /* Create new array */

        float *arr = (float *) malloc (this->capacity * sizeof(float));

        /* Copy all elements to new array */

        int i;

        for (i = 0; i < this->size; i++)
        {
            arr[i] = ((float *) this->a)[i];
        }

        free(this->a);

        this->a = arr;
    }
}

void dampl_arr_ensure_cap__str (Array this, int sz)
{
    if (this->capacity < sz)
    {
        this->capacity = sz * 2;

        /* Create new array */

        String *arr = (String *) malloc (this->capacity * sizeof(String));

        /* Copy all elements to new array */

        int i;

        for (i = 0; i < this->size; i++)
        {
            arr[i] = ((String *) this->a)[i];
        }

        free(this->a);

        this->a = arr;
    }
}

void dampl_arr_ensure_cap__tup (Array this, int sz)
{
    if (this->capacity < sz)
    {
        this->capacity = sz * 2;

        /* Create new array */

        Tuple *arr = (Tuple *) malloc (this->capacity * sizeof(Tuple));

        /* Copy all elements to new array */

        int i;

        for (i = 0; i < this->size; i++)
        {
            arr[i] = ((Tuple *) this->a)[i];
        }

        free(this->a);

        this->a = arr;
    } 
}


