#include "dampllib.h"
#include <stdio.h>
#include <stdlib.h>

String dampl_str__str (String string) {
	return string;
}

String dampl_str__float (float f){
	int size = snprintf(NULL, 0, "%g", f);
	char *s = malloc(size + 1);
	sprintf(s, "%g", f);
	return s;
}

String dampl_str__int (int i) {
	int size = snprintf(NULL, 0, "%d", i);
	char *s = malloc(size + 1);
	sprintf(s, "%d", i);
	return s;
}

String dampl_str__bool (int b){
  String str;
  if (b) str = dampl_str_copy("true");
  else str = dampl_str_copy("false");

  return str;
}


String dampl_str_arr__int (Array arr, int dimensions){
    int i, size;

    size = dampl_arr_len(arr);

    String str;

    str = dampl_str_copy("[ ");
    
    if(dimensions == 1){
      str = dampl_str_concat(str, dampl_str__int (dampl_arr_get__int (arr, 0)));
      for(i = 1; i < size; i++){
        str = dampl_str_concat(str,", ");
        str = dampl_str_concat(str,dampl_str__int (dampl_arr_get__int (arr, i)));
      }
    }
    else{
      for(i = 0; i < size; i++){
        str = dampl_str_concat(str,dampl_str_arr__int (dampl_arr_get__arr (arr, i), dimensions-1));
      }
    }

    str = dampl_str_concat(str," ]");

    return str;
}


String dampl_str_arr__float (Array arr, int dimensions){
    int i, size;

    size = dampl_arr_len(arr);

    String str;

    str = dampl_str_copy("[ ");
    
    if(dimensions == 1){
      str = dampl_str_concat(str, dampl_str__float (dampl_arr_get__float (arr, 0)));
      for(i = 1; i < size; i++){
        str = dampl_str_concat(str,", ");
        str = dampl_str_concat(str,dampl_str__float (dampl_arr_get__float (arr, i)));
      }
    }
    else{
      for(i = 0; i < size; i++){
        dampl_str_arr__float (dampl_arr_get__arr (arr, i), dimensions-1);
      }
    }

    str = dampl_str_concat(str," ]");

    return str;
}

String dampl_str_arr__str (Array arr, int dimensions){
    int i, size;

    size = dampl_arr_len(arr);

    String str;

    str = dampl_str_copy("[ ");
    
    if(dimensions == 1){
      str = dampl_str_concat(str, dampl_arr_get__str (arr, 0));
      for(i = 1; i < size; i++){
        str = dampl_str_concat(str,", ");
        str = dampl_str_concat(str, dampl_arr_get__str (arr, i));
      }
    }
    else{
      for(i = 0; i < size; i++){
        dampl_str_arr__str (dampl_arr_get__arr (arr, i), dimensions-1);
      }
    }

    str = dampl_str_concat(str," ]");

    return str;
}

String dampl_str_arr__tup (Array arr, int dimensions){
    int i, size;

    size = dampl_arr_len(arr);

    String str;

    str = dampl_str_copy("[ ");
    
    if(dimensions == 1){
      str = dampl_str_concat(str, dampl_arr_get__str (arr, 0));
      for(i = 1; i < size; i++){
        str = dampl_str_concat(str,", ");
        str = dampl_str_concat(str, dampl_arr_get__str (arr, i));
      }
    }
    else{
      for(i = 0; i < size; i++){
        dampl_str_arr__str (dampl_arr_get__arr (arr, i), dimensions-1);
      }
    }

    str = dampl_str_concat(str," ]");

    return str;
}

String dampl_str__tup (Tuple tup){
	int i, size;

	size = dampl_tup_len(tup);

	String str;

    str = dampl_str_copy("(");

	str = dampl_str_concat(str, dampl_tup_get__str (tup, 0));

	for(i = 1; i < size; i++){
		str = dampl_str_concat(str, ", ");
		str = dampl_str_concat(str, dampl_tup_get__str (tup, i));
	}

	str = dampl_str_concat(str,")");

	return str;
}

Array build_args_array(String* args) {
	Array a = dampl_arr_new();
	while(*args) {
		dampl_arr_append__str(a,*args);
		args++;
	}
	return a;
}


void dampl_die__(void) {
	exit(0);
}