#include "damplarray.h"
#include <stdio.h>
#include <limits.h>


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

/* Set */

Array dampl_arr_set__arr (Array this, int index, Array value)
{
    /* Check border conditions */

    if (index >= this->size || index < 0)
    {
        fprintf(stderr, "Array out of bounds exception\n");
        exit(1);
    }

    return ((Array *) this->a)[index] = value;
}

int dampl_arr_set__int (Array this, int index, int value)
{
    /* Check border conditions */

    if (index >= this->size || index < 0)
    {
        fprintf(stderr, "Array out of bounds exception\n");
        exit(1);
    }

    return ((int *) this->a)[index] = value;
}

float dampl_arr_set__float (Array this, int index, float value)
{
    /* Check border conditions */

    if (index >= this->size || index < 0)
    {
        fprintf(stderr, "Array out of bounds exception\n");
        exit(1);
    }

    return ((float *) this->a)[index] = value;
}

String dampl_arr_set__str (Array this, int index, String value)
{
    /* Check border conditions */

    if (index >= this->size || index < 0)
    {
        fprintf(stderr, "Array out of bounds exception\n");
        exit(1);
    }

    return ((String *) this->a)[index] = value;
} 

Tuple dampl_arr_set__tup (Array this, int index, Tuple value)
{
    /* Check border conditions */

    if (index >= this->size || index < 0)
    {
        fprintf(stderr, "Array out of bounds exception\n");
        exit(1);
    }

    return ((Tuple *) this->a)[index] = value;
} 

/* Get */

Array dampl_arr_get__arr (Array this, int index)
{
    /* Check border conditions */

    if (index >= this->size || index < 0)
    {
        fprintf(stderr, "Array out of bounds exception\n");
        exit(1);
    }

    return ((Array *) this->a)[index];
}

int dampl_arr_get__int (Array this, int index)
{
    /* Check border conditions */

    if (index >= this->size || index < 0)
    {
        fprintf(stderr, "Array out of bounds exception\n");
        exit(1);
    }

    return ((int *) this->a)[index];
}

float dampl_arr_get__float (Array this, int index)
{
    /* Check border conditions */

    if (index >= this->size || index < 0)
    {
        fprintf(stderr, "Array out of bounds exception\n");
        exit(1);
    }

    return ((float *) this->a)[index];
}

String dampl_arr_get__str (Array this, int index)
{
    /* Check border conditions */

    if (index >= this->size || index < 0)
    {
        fprintf(stderr, "Array out of bounds exception\n");
        exit(1);
    }

    return ((String *) this->a)[index];
}

Tuple dampl_arr_get__tup (Array this, int index)
{
    /* Check border conditions */

    if (index >= this->size || index < 0)
    {
        fprintf(stderr, "Array out of bounds exception\n");
        exit(1);
    }

    return ((Tuple *) this->a)[index];
}



/* Extract attribute from table (array of tuples) */

Array dampl_arr_extract_attr__int(Array table, int column){
    int i, data;

    Array arr = (Array) malloc (sizeof(Array*));
    arr->a = malloc(table->size*(sizeof(int)));
    arr->size = 0;
    arr->capacity = table->size;

    for(i = 0; i < table->size; i++){
        data = dampl_tup_get__int(dampl_arr_get__tup(table,i), column);
        dampl_arr_append__int(arr, data);
    }

    return arr;
}


Array dampl_arr_extract_attr__float(Array table, int column){
    int i;
    float data;

    Array arr = (Array) malloc (sizeof(Array*));
    arr->a = malloc(table->size*(sizeof(float)));
    arr->size = 0;
    arr->capacity = table->size;

    for(i = 0; i < table->size; i++){
        data = dampl_tup_get__float(dampl_arr_get__tup(table,i), column);
        dampl_arr_append__float(arr, data);
    }

    return arr;
}

Array dampl_arr_extract_attr__str(Array table, int column){
    int i;
    String data;

    Array arr = (Array) malloc (sizeof(Array*));
    arr->a = malloc(table->size*(sizeof(String)));
    arr->size = 0;
    arr->capacity = table->size;

    for(i = 0; i < table->size; i++){
        data = dampl_tup_get__str(dampl_arr_get__tup(table,i), column);
        dampl_arr_append__str(arr, data);
    }

    return arr;
}


/* Set attribute of table (array of tuples)
    Checks if array containing values are of
            same size as table */

Array dampl_arr_set_attr__int(Array table, int column, Array arr){
    int i;

    if(table->size != arr->size){
        fprintf(stderr, "Arrays with different sizes\n");
        exit(1);
    }

    for(i = 0; i < table->size; i++){
        dampl_tup_set__int(dampl_arr_get__tup(table,i), column, dampl_arr_get__int(arr,i));
    }

    return table;
}


Array dampl_arr_set_attr__float(Array table, int column, Array arr){
    int i;

    if(table->size != arr->size){
        fprintf(stderr, "Arrays with different sizes\n");
        exit(1);
    }

    for(i = 0; i < table->size; i++){
        dampl_tup_set__float(dampl_arr_get__tup(table,i), column, dampl_arr_get__float(arr,i));
    }

    return table;
}


Array dampl_arr_set_attr__str(Array table, int column, Array arr){
    int i;

    if(table->size != arr->size){
        fprintf(stderr, "Arrays with different sizes\n");
        exit(1);
    }

    for(i = 0; i < table->size; i++){
        dampl_tup_set__str(dampl_arr_get__tup(table,i), column, dampl_arr_get__str(arr,i));
    }

    return table;
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


/* Concatenates arrays */

Array dampl_arr_concat__arr (Array arr1, Array arr2){
    int i;

    Array arr = dampl_arr_new();

    for(i = 0; i < arr1->size; i++){
        dampl_arr_append__arr (arr, dampl_arr_get__arr (arr1, i));
    }

    for(i = 0; i < arr2->size; i++){
        dampl_arr_append__arr (arr, dampl_arr_get__arr (arr2, i));
    }

    return arr;
}

Array dampl_arr_concat__int (Array arr1, Array arr2){
    int i;

    Array arr = dampl_arr_new();

    for(i = 0; i < arr1->size; i++){
        dampl_arr_append__int (arr, dampl_arr_get__int (arr1, i));
    }

    for(i = 0; i < arr2->size; i++){
        dampl_arr_append__int (arr, dampl_arr_get__int (arr2, i));
    }


    return arr;
}


Array dampl_arr_concat__float (Array arr1, Array arr2){
    int i;

    Array arr = dampl_arr_new();

    for(i = 0; i < arr1->size; i++){
        dampl_arr_append__float (arr, dampl_arr_get__float (arr1, i));
    }

    for(i = 0; i < arr2->size; i++){
        dampl_arr_append__float (arr, dampl_arr_get__float (arr2, i));
    }


    return arr;
}

Array dampl_arr_concat__str (Array arr1, Array arr2){
    int i;

    Array arr = dampl_arr_new();

    for(i = 0; i < arr1->size; i++){
        dampl_arr_append__str (arr, dampl_arr_get__str (arr1, i));
    }

    for(i = 0; i < arr2->size; i++){
        dampl_arr_append__str (arr, dampl_arr_get__str (arr2, i));
    }

    return arr;
}

Array dampl_arr_concat__tup (Array arr1, Array arr2){
    int i;

    Array arr = dampl_arr_new();

    for(i = 0; i < arr1->size; i++){
        dampl_arr_append__tup (arr, dampl_arr_get__tup (arr1, i));
    }

    for(i = 0; i < arr2->size; i++){
        dampl_arr_append__tup (arr, dampl_arr_get__tup (arr2, i));
    }

    return arr;
}



/* Set Range Functions */

int get_begin(int index1,int size){
    int begin;

    if(index1 == INT_MIN){
        begin = 0;
    }
    else if(index1 >= size){
        begin = size;
    }
    else if (index1 < 0){
        fprintf(stderr, "Array out of bounds exception\n");
        exit(1);
    }
    else{
        begin = index1;
    }

    return begin;
}

int get_end(int index2, int size){
    int end;

    if((index2 >= size) || (index2 == INT_MIN)){
        end = size;
    }
    else if (index2 < 0){
        fprintf(stderr, "Array out of bounds exception\n");
        exit(1);
    }
    else{
        end = index2;
    }

    return end;
}

Array dampl_arr_set_range__arr (Array this, int index1, int index2, Array other){
    int i;
    int begin, end;

    begin = get_begin(index1, this->size);
    end = get_end(index2, this->size);

    if(end < begin){
        end = begin;
    }

    /**************************************/
    Array arr = dampl_arr_new();
    /* or */
    //int new_size = this->size - (end - begin) + other->size;
    //Array arr = (Array) malloc (sizeof(Array*));
    //arr->size = new_size;
    //arr->capacity = new_size;
    //arr->a = malloc(new_size*(sizeof(Array)));
    /**************************************/

    for(i = 0; i < begin; i++){
        dampl_arr_append__arr (arr, dampl_arr_get__arr (this, i));
    }

    for(i = 0; i < other->size; i++){
        dampl_arr_append__arr (arr, dampl_arr_get__arr (other, i));
    }

    for(i = end; i < this->size; i++){
        dampl_arr_append__arr (arr, dampl_arr_get__arr (this, i));
    }

    this->a = arr->a;
    this->size = arr->size;
    this->capacity = arr->capacity;

    return this;
}

Array dampl_arr_set_range__int (Array this, int index1, int index2, Array other){
    int i;
    int begin, end;

    begin = get_begin(index1, this->size);

    end = get_end(index2, this->size);

    if(end < begin){
        end = begin;
    }

    /**************************************/
    Array arr = dampl_arr_new();
    /* or */
    //int new_size = this->size - (end - begin) + other->size;
    //Array arr = (Array) malloc (sizeof(Array*));
    //arr->size = new_size;
    //arr->capacity = new_size;
    //arr->a = malloc(new_size*(sizeof(int)));
    /**************************************/

    for(i = 0; i < begin; i++){
        dampl_arr_append__int (arr, dampl_arr_get__int (this, i));
    }

    for(i = 0; i < other->size; i++){
        dampl_arr_append__int (arr, dampl_arr_get__int (other, i));
    }

    for(i = end; i < this->size; i++){
        dampl_arr_append__int (arr, dampl_arr_get__int (this, i));
    }

    this->a = arr->a;
    this->size = arr->size;
    this->capacity = arr->capacity;

    return this;
}

Array dampl_arr_set_range__float (Array this, int index1, int index2, Array other){
    int i;
    int begin, end;

    begin = get_begin(index1, this->size);
    end = get_end(index2, this->size);

    if(end < begin){
        end = begin;
    }

    /**************************************/
    Array arr = dampl_arr_new();
    /* or */
    //int new_size = this->size - (end - begin) + other->size;
    //Array arr = (Array) malloc (sizeof(Array*));
    //arr->size = new_size;
    //arr->capacity = new_size;
    //arr->a = malloc(new_size*(sizeof(Float)));
    /**************************************/

    for(i = 0; i < begin; i++){
        dampl_arr_append__float (arr, dampl_arr_get__float (this, i));
    }

    for(i = 0; i < other->size; i++){
        dampl_arr_append__float (arr, dampl_arr_get__float (other, i));
    }

    for(i = end; i < this->size; i++){
        dampl_arr_append__float (arr, dampl_arr_get__float (this, i));
    }

        
    this->a = arr->a;
    this->size = arr->size;
    this->capacity = arr->capacity;

    return this;
}

Array dampl_arr_set_range__str (Array this, int index1, int index2, Array other){
    int i;
    int begin, end;

    begin = get_begin(index1, this->size);
    end = get_end(index2, this->size);

    if(end < begin){
        end = begin;
    }

    /**************************************/
    Array arr = dampl_arr_new();
    /* or */
    //int new_size = this->size - (end - begin) + other->size;
    //Array arr = (Array) malloc (sizeof(Array*));
    //arr->size = new_size;
    //arr->capacity = new_size;
    //arr->a = malloc(new_size*(sizeof(String)));
    /**************************************/

    for(i = 0; i < begin; i++){
        dampl_arr_append__str (arr, dampl_arr_get__str (this, i));
    }

    for(i = 0; i < other->size; i++){
        dampl_arr_append__str (arr, dampl_arr_get__str (other, i));
    }

    for(i = end; i < this->size; i++){
        dampl_arr_append__str (arr, dampl_arr_get__str (this, i));
    }

        
    this->a = arr->a;
    this->size = arr->size;
    this->capacity = arr->capacity;

    return this;
}

Array dampl_arr_set_range__tup (Array this, int index1, int index2, Array other){
    int i;
    int begin, end;

    begin = get_begin(index1, this->size);
    end = get_end(index2, this->size);

    if(end < begin){
        end = begin;
    }

    /**************************************/
    Array arr = dampl_arr_new();
    /* or */
    //int new_size = this->size - (end - begin) + other->size;
    //Array arr = (Array) malloc (sizeof(Array*));
    //arr->size = new_size;
    //arr->capacity = new_size;
    //arr->a = malloc(new_size*(sizeof(Tuple)));
    /**************************************/

    for(i = 0; i < begin; i++){
        dampl_arr_append__tup (arr, dampl_arr_get__tup (this, i));
    }

    for(i = 0; i < other->size; i++){
        dampl_arr_append__tup (arr, dampl_arr_get__tup (other, i));
    }

    for(i = end; i < this->size; i++){
        dampl_arr_append__tup (arr, dampl_arr_get__tup (this, i));
    }

        
    this->a = arr->a;
    this->size = arr->size;
    this->capacity = arr->capacity;

    return this;
}


/* Get Range Functions */

Array dampl_arr_get_range__arr (Array this, int index1, int index2){
    int i;
    int begin, end;

    begin = get_begin(index1, this->size);
    end = get_end(index2, this->size);

    if(end < begin){
        end = begin;
    }

    /**************************************/
    Array arr = dampl_arr_new();
    /* or */
    //int new_size = this->size - (end - begin) + other->size;
    //Array arr = (Array) malloc (sizeof(Array*));
    //arr->size = new_size;
    //arr->capacity = new_size;
    //arr->a = malloc(new_size*(sizeof(Array)));
    /**************************************/

    for(i = begin; i < end; i++){
        dampl_arr_append__arr (arr, dampl_arr_get__arr (this, i));
    }

    return arr;
}

Array dampl_arr_get_range__int (Array this, int index1, int index2){
    int i;
    int begin, end;

    begin = get_begin(index1, this->size);
    end = get_end(index2, this->size);

    if(end < begin){
        end = begin;
    }

    /**************************************/
    Array arr = dampl_arr_new();
    /* or */
    //int new_size = this->size - (end - begin) + other->size;
    //Array arr = (Array) malloc (sizeof(Array*));
    //arr->size = new_size;
    //arr->capacity = new_size;
    //arr->a = malloc(new_size*(sizeof(int)));
    /**************************************/

    for(i = begin; i < end; i++){
        dampl_arr_append__int (arr, dampl_arr_get__int (this, i));
    }

    return arr;
}

Array dampl_arr_get_range__float (Array this, int index1, int index2){
    int i;
    int begin, end;

    begin = get_begin(index1, this->size);
    end = get_end(index2, this->size);

    if(end < begin){
        end = begin;
    }

    /**************************************/
    Array arr = dampl_arr_new();
    /* or */
    //int new_size = this->size - (end - begin) + other->size;
    //Array arr = (Array) malloc (sizeof(Array*));
    //arr->size = new_size;
    //arr->capacity = new_size;
    //arr->a = malloc(new_size*(sizeof(Float)));
    /**************************************/

    for(i = begin; i < end; i++){
        dampl_arr_append__float (arr, dampl_arr_get__float (this, i));
    }

    return arr;
}

Array dampl_arr_get_range__str (Array this, int index1, int index2){
    int i;
    int begin, end;

    begin = get_begin(index1, this->size);
    end = get_end(index2, this->size);

    if(end < begin){
        end = begin;
    }

    /**************************************/
    Array arr = dampl_arr_new();
    /* or */
    //int new_size = this->size - (end - begin) + other->size;
    //Array arr = (Array) malloc (sizeof(Array*));
    //arr->size = new_size;
    //arr->capacity = new_size;
    //arr->a = malloc(new_size*(sizeof(String)));
    /**************************************/

    for(i = begin; i < end; i++){
        dampl_arr_append__str (arr, dampl_arr_get__str (this, i));
    }

    return arr;
}

Array dampl_arr_get_range__tup (Array this, int index1, int index2){
    int i;
    int begin, end;

    begin = get_begin(index1, this->size);
    end = get_end(index2, this->size);

    if(end < begin){
        end = begin;
    }

    /**************************************/
    Array arr = dampl_arr_new();
    /* or */
    //int new_size = this->size - (end - begin) + other->size;
    //Array arr = (Array) malloc (sizeof(Array*));
    //arr->size = new_size;
    //arr->capacity = new_size;
    //arr->a = malloc(new_size*(sizeof(Tuple)));
    /**************************************/

    for(i = begin; i < end; i++){
        dampl_arr_append__tup (arr, dampl_arr_get__tup (this, i));
    }

    return arr;
}

/*
Tuple dampl_tup_convert(Array arr, int size, type_map type){
    int i;

    if(arr->size != size){
        fprintf(stderr, "Incompatible sizes for array and tuple\n");
        exit(1);   
    }

    Tuple tup = dampl_tup_new (size, type);

    for(i = 0; i < size; i++){
        dampl_tup_set__str(tup, i, dampl_arr_get__str (arr, i));
    }
    
    return tup;
}*/