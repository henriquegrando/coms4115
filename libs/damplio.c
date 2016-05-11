#include "damplio.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>


Array files;


void dampl_print__str (String string)
{
    printf("%s", string);
}

void dampl_print__float (float f)
{
    printf("%g", f);
}

void dampl_print__int (int i)
{
    printf("%d", i);
}

void dampl_print__bool (int b){
  if (b) printf("true");
  else printf("false");
}

void dampl_print_arr__int (Array arr, int dimensions){
    int i, size;

    size = dampl_arr_len(arr);

    printf("[ ");

    if(dimensions == 1){
      dampl_print__int (dampl_arr_get__int (arr, 0));
      for(i = 1; i < size; i++){
        printf(", ");
        dampl_print__int (dampl_arr_get__int (arr, i));
      }
    }
    else{
      for(i = 0; i < size; i++){
        dampl_print_arr__int (dampl_arr_get__arr (arr, i), dimensions-1);
      }
    }

    printf(" ]");
}

void dampl_print_arr__float (Array arr, int dimensions){
    int i, size;

    size = dampl_arr_len(arr);

    printf("[ ");

    if(dimensions == 1){
      dampl_print__float (dampl_arr_get__float (arr, 0));
      for(i = 1; i < size; i++){
        printf(", ");
        dampl_print__float (dampl_arr_get__float (arr, i));
      }
    }
    else{
      for(i = 0; i < size; i++){
        dampl_print_arr__float (dampl_arr_get__arr (arr, i), dimensions-1);
      }
    }

    printf(" ]");
}

void dampl_print_arr__str (Array arr, int dimensions){
    int i, size;

    size = dampl_arr_len(arr);

    printf("[ ");

    if(dimensions == 1){
      dampl_print__str (dampl_arr_get__str(arr, 0));
      for(i = 1; i < size; i++){
        printf(", ");
        dampl_print__str (dampl_arr_get__str(arr, i));
      }
    }
    else{
      for(i = 0; i < size; i++){
        dampl_print_arr__str (dampl_arr_get__arr(arr, i), dimensions-1);
      }
    }

    printf(" ]");
}

void dampl_print_arr__tup (Array arr, int dimensions){
    int i, size;

    size = dampl_arr_len(arr);

    printf("[ ");

    if(dimensions == 1){
      dampl_print__tup (dampl_arr_get__tup(arr, 0));
      for(i = 1; i < size; i++){
        printf(", ");
        dampl_print__tup (dampl_arr_get__tup(arr, i));
      }
    }
    else{
      for(i = 0; i < size; i++){
        dampl_print_arr__tup (dampl_arr_get__arr (arr, i), dimensions-1);
      }
    }

    printf(" ]");
}


void dampl_print__tup (Tuple tup){
	int i, size;

	size = dampl_tup_len(tup);

  printf("(");
  dampl_print__str (dampl_tup_get__str (tup, 0));
  
  for(i = 1; i < size; i++){
    printf(", ");
    dampl_print__str (dampl_tup_get__str (tup, i));
  }

  printf(")");
}


Array dampl_strsplit__str_str (String str, String separator){
	Array arr = dampl_arr_new();

	char *token;

  String new_str = dampl_str_copy(str);

	/* get the first token */
	token = strtok(new_str, separator);
	dampl_arr_append__str (arr, token);

	/* walk through other tokens */
	while((token = strtok(NULL, separator))) {
		dampl_arr_append__str (arr, token);
	}

	return arr;
}


// File Functions

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
 	fp = fopen(file_name, "w");
 	if(fp == NULL) {
	perror("Error opening file");
    	exit(-1);
 	}

 	if(fputs(str, fp) == EOF){
 		perror("Error writing file");
    exit(1);
  }

 	fclose(fp);
}

void dampl_file_constructor(){

 files = dampl_arr_new();
}

void arr_ensure_cap__file (int sz){
    if (files->capacity < sz)
    {
        files->capacity = sz * 2;

        /* Create new array */

        FILE **arr = (FILE **) malloc (files->capacity * sizeof(FILE*));
        /* Copy all elements to new array */

        int i;

        for (i = 0; i < files->size; i++){
            arr[i] = (FILE*)((FILE **) files->a)[i];
        }

        files->a = arr;
    }
}

void arr_append__file (FILE* value){

    arr_ensure_cap__file (files->size + 1);

    ((FILE**)files->a)[files->size++] = value;
}

FILE *arr_get__file (int index){
    /* Check border conditions */

    // if (index >= this->size || index < 0){
    //     fprintf(stderr, "Array out of bounds exception\n");
    //     exit(1);
    // }

    return  ((FILE **) files->a)[index];
}

int dampl_open__str_str(String filename,String mode){

  FILE **fp = malloc(sizeof(FILE*));

  *fp = fopen(filename, mode);
  if(fp == NULL) {
    perror("Error opening file");
    exit(-1);
  }
  
  arr_append__file (*fp);

  return files->size-1;
}

void dampl_close__int(int index){
  
  FILE* fp;
  
  if (index >= files->size || index < 0){
    fprintf(stderr, "Illegal file descriptor\n");
    exit(1);
  }
  
  fp = (FILE*) arr_get__file (index);
  
  fclose(fp);
}

String dampl_readline__int(int index){
  char c;
  int i;
  FILE* fp;

  String file_str;
  
  int eof_flag = 1;
  int count = 0;

  if (index >= files->size || index < 0){
    fprintf(stderr, "Illegal file descriptor\n");
    exit(1);
  }

  fp = (FILE*) arr_get__file (index);
  
  while((c = fgetc(fp)) != EOF){
    //printf("%d\n", count);
    if(c == '\n') break;
    count++;
  }

  if(c != '\n') eof_flag = 0;

  file_str = (String) malloc((count+1)*sizeof(char));

  
  int err = fseek(fp, -(count+eof_flag), SEEK_CUR );
  if(err != 0) {
    perror("Error reading file");
    exit(-1);
  }

  for(i = 0; i < count; i++){
    c = fgetc(fp);
    file_str[i] = c;
  }

  c = fgetc(fp);
  file_str[count] = '\0';

  return file_str;
}

void dampl_writeline__int_String(int index, String str){
  
  FILE* fp;

  if (index >= files->size || index < 0){
    fprintf(stderr, "Illegal file descriptor\n");
    exit(1);
  }


  fp = (FILE*) arr_get__file (index);
  
  if(fputs(str, fp) == EOF){
    perror("Error writing file");
    exit(1);
  }
}

