#include "damplio.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void dampl_print__str (String string)
{
    printf("%s", string);
}

void dampl_print__float (float f)
{
    printf("%.2f", f);
}

void dampl_print__int (int i)
{
    printf("%d", i);
}


void dampl_arr_print__int (Array arr, int dimensions){
    int i, size;

    size = dampl_arr_len(arr);

    printf("[ ");

    if(dimensions == 1){
      for(i = 0; i < size; i++){
        dampl_print__int (dampl_arr_get__int (arr, i));
      }
    }
    else{
      for(i = 0; i < size; i++){
        dampl_arr_print__int (dampl_arr_get__arr (arr, i), dimensions-1);
      }
    }

    printf(" ]");
}

void dampl_arr_print__float (Array arr, int dimensions){
    int i, size;

    size = dampl_arr_len(arr);

    printf("[ ");

    if(dimensions == 1){
      for(i = 0; i < size; i++){
        dampl_print__float (dampl_arr_get__float (arr, i));
      }
    }
    else{
      for(i = 0; i < size; i++){
        dampl_arr_print__float (dampl_arr_get__arr (arr, i), dimensions-1);
      }
    }

    printf(" ]");
}

void dampl_arr_print__str (Array arr, int dimensions){
    int i, size;

    size = dampl_arr_len(arr);

    printf("[ ");

    if(dimensions == 1){
      for(i = 0; i < size; i++){
        dampl_print__str (dampl_arr_get__str(arr, i));
      }
    }
    else{
      for(i = 0; i < size; i++){
        dampl_arr_print__str (dampl_arr_get__arr(arr, i), dimensions-1);
      }
    }

    printf(" ]");
}

void dampl_arr_print__tup (Array arr, int dimensions){
    int i, size;

    size = dampl_arr_len(arr);

    printf("[ ");

    if(dimensions == 1){
      for(i = 0; i < size; i++){
        dampl_print__tup (dampl_arr_get__tup(arr, i));
      }
    }
    else{
      for(i = 0; i < size; i++){
        dampl_arr_print__tup (dampl_arr_get__arr (arr, i), dimensions-1);
      }
    }

    printf(" ]");
}


void dampl_print__tup (Tuple tup){
	int i, size;

	size = dampl_tup_len(tup);

    for(i = 0; i < size; i++){
        dampl_print__str (dampl_tup_get__str (tup, i));
    }
}



Array dampl_strsplit__str (String str, String separator){
	Array arr = dampl_arr_new();

	char *token;

	/* get the first token */
	token = strtok(str, separator);
	dampl_arr_append__str (arr, token);

	/* walk through other tokens */
	while( token != NULL ) {
		token = strtok(NULL, separator);
		dampl_arr_append__str (arr, token);
	}

	return arr;
}

String dampl_readfile__str (String file_name){
	FILE *fp;
   	int i, count;
   	char c;

   	/* opening file for reading */
   	fp = fopen(file_name, "r");
   	if(fp == NULL) {
		perror("Error opening file");
      	exit(-1);
   	}

   	/* Counts the number of characters on file */
   	count = 0;
	while(fgetc(fp) != EOF){
		count++;
	}

	String file_str = (String) malloc((count+1)*sizeof(char));

	/* Goes to begining of the file */
	int err = fseek(fp, 0, SEEK_SET );
	if(err != 0) {
		perror("Error reading file");
      	exit(-1);
   	}

	for(i = 0; i < count; i++){
		c = fgetc(fp);
		file_str[i] = c;
	}

	file_str[count] = '\0';

	fclose(fp);

	return file_str;
}

void dampl_writefile__str_str (String file_name, String str){
	FILE *fp;


   	/* opening file for reading */
   	fp = fopen(file_name, "a");
   	if(fp == NULL) {
		perror("Error opening file");
      	exit(-1);
   	}

   	if(fputs(str, fp) == EOF){
   		perror("Error reading file");
      	exit(1);
    }

   	fclose(fp);
}