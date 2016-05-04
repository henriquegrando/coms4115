#include "damplstr.h"
#include <string.h>


String concat(String s1, String s2) {
	int size = strlen(s1) + strlen(s2);
	char *s = malloc(size+1);
	strcpy(s,s1);
	strcat(s,s2);
	return s;
}