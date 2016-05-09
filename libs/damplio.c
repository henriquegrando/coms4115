#include "damplio.h"
#include <stdio.h>
#include <stdlib.h>

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

Array dampl_strsplit__str (String str){

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

void dampl_writefile__str_str (String string1, String string2){

}