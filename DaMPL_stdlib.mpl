fun readCSV(filename){
	file = readfile(filename);
	table = strsplit(file,"\n");

	for i in table{
		new_table[] = strsplit(i,",");
	}

	return new_table;
}


fun join(arr, separator){
	i = 1;
	
	size = len(arr);

	new_str = arr[0];

	while(i < size){
		new_str = new_str + separator + arr[i];
		i = i + 1;
	}

	return new_str;
}

fun writeCSV(table,file){
	str = "";

	i = 0;
	size = len(table);

	while(i < size){
		str = str + join(table[i],",") + "\n";
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