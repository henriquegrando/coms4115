#include <stdlib.h>
#include <stdio.h>
#include "dampltup.h"

Tuple dampl_tup_new (int size){
	int i;

	Tuple tup = malloc(sizeof(Tuple*));
	tup->size = size;

	tup->values = malloc(size*sizeof(String*));

	for(i = 0; i < size; i++){
		tup->values[i] = dampl_str_copy("");
	}

	return tup;
}

/* Tuple insertion method */

int dampl_tup_set__int(Tuple tup, int index, int data){
	char str[11];

	sprintf(str, "%d", data);

	tup->values[index] = dampl_str_copy(str);

	return data;
}

float dampl_tup_set__float(Tuple tup, int index, float data){
	char str[64];

	sprintf(str, "%f", data);

	tup->values[index] = dampl_str_copy(str);

	return data;
}

String dampl_tup_set__str(Tuple tup, int index, String data){
	tup->values[index] = dampl_str_copy(data);

	return data;
}


int dampl_tup_get__int(Tuple tup, int index){
	char *str;
	char *eptr;
    long result;

    str = tup->values[index];

    /* Convert the provided value to a decimal long long */
    result = strtol(str, &eptr, 10);

    return (int)result;
}

float dampl_tup_get__float(Tuple tup, int index){
	char *str;
	char *eptr;
    double result;

    str = tup->values[index];

    /* Convert the provided value to a double*/
    result = strtod(str, &eptr);

    return (float)result;	
}

String dampl_tup_get__str(Tuple tup, int index){
	return tup->values[index];
}