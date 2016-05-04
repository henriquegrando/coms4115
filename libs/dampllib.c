#include "dampllib.h"
#include <stdio.h>
#include <stdlib.h>

String dampl_str__str (String string) {
	return string;
}

String dampl_str__float (float f){
	int size = snprintf(NULL, 0, "%.2f", f);
	char *s = malloc(size + 1);
	sprintf(s, "%.2f", f);
	return s;
}

String dampl_str__int (int i) {
	int size = snprintf(NULL, 0, "%d", i);
	char *s = malloc(size + 1);
	sprintf(s, "%d", i);
	return s;
}

void die(void) {
	exit(0);
}