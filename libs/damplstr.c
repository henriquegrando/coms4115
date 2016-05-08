#include "damplstr.h"
#include <string.h>


String dampl_str_concat(String s1, String s2) {
	int size = strlen(s1) + strlen(s2);
	char *s = malloc(size+1);
	strcpy(s,s1);
	strcat(s,s2);
	return s;
}

String dampl_str_copy(String s1) {
	int size = strlen(s1);
	char *s = malloc(size+1);
	strcpy(s,s1);
	return s;
}