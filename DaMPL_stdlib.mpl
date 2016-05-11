fun readCSV(filename,tab){
	file = readfile(filename);
	table = strsplit(file,"\r\n");

	size = len(table);
	
	i=0;
	while(i < size){
		tab[] = strsplit(table[i],",");
		i = i+1;
	}

}


fun join(arr, separator){
	join__i = 1;
	
	join__size = len(arr);

	new_str = arr[0];

	while(join__i < join__size){
		new_str = new_str + separator + arr[join__i];
		join__i = join__i + 1;
	}

	return new_str;
}

fun join_tuple(tup, separator){
	join__tuple_i = 1;
	
	join__tuple_size = len(tup);

	new_str = tup$(0);

	while(join__tuple_i < join__tuple_size){
		new_str = new_str + separator + tup$(join__tuple_i);
		join__tuple_i = join__tuple_i + 1;
	}

	return new_str;
}

fun writeCSV(table,file){
	str = "";

	i = 0;
	size = len(table);

	while(i < size){
		str = str + join_tuple(table[i],",") + "\n";
		i = i+1;
	}

	writefile(file,str);
}

fun invert(arr){
	new_arr = [];

	i = len(arr) - 1;
	
	while(i >= 0){
		new_arr[] = arr[i];
		i = i-1;
	}

	return new_arr;
}

fun tuple_to_array(tup){
	arr = [];

	i = 0;

	while(i < len(tup)){
		arr[] = str(tup$(i));
		i = i+1;
	}

	return arr;
}

fun range(begin, end){
	i = begin;
	arr = [];

	while(i < end){
		arr[] = i;
		i = i + 1;
	}

	return arr;
}

fun range_s(begin, end, step){
	i = begin;
	arr = [];

	while(i < end){
		arr[] = i;
		i = i + step;
	}

	return arr;
}