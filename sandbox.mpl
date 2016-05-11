tuple Group {name, age:integer, year:integer, grade, position}

print(args);
die();


fun readCSV(filename){
	file = readfile(filename);
	table = strsplit(file,"\n");

	new_table = [];

	i = 0;
	while (i < len(table)){
		new_table[] = strsplit(table[i],",");
		i = i+1;
	}

	return new_table;
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

fun string_of_tuple(tup,separator){
	str = tup$(0);

	i = 1;
	while(i < len(tup)){
		str = str + separator + tup$(i) ;
		i = i+1;
	}

	return str;
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

fun print_array2(arr, dimension){
	size = len(arr);

	if(dimension == 1){
		i = 0;

		while(i < size){
			print(str(arr[i])+ " ");
			i = i+1;
		}
		print("\n");
	}
	else if(dimension == 2){
		i = 0;

		while(i < size){
			/*print(str(arr[i])+ " ");*/
			print(str(arr[i][0])+ " ");
			i = i+1;
		}
		print("\n");
	}
	/*else{
		i = 0;
		while(i < size){
			print_array(arr[i], dimension-1);
			i = i+1;
		}
	}
	*/
}


fun print_array(arr){
	size = len(arr);

	i = 0;
	while(i < size){
		print(str(arr[i])+ " ");
		i = i+1;
	}
	print("\n");
}

fun print_array_2d(arr){
	size = len(arr);

	i = 0;
	while(i < size){
		j = 0;
		while(j < len(arr[i])){
			print(str(arr[i][j]) + " ");
			j = j+1;
		}
		print(" | ");
		i = i+1;
	}
	print("\n");
}


	/*
	a = [ ["1","2"],["3","4"],["5","3"],["1","5","6"],["9"] ];
	print(len(a[0]));

	print_array_2d(a);
	print("\n");

	print_array_2d(a[2:4]);
	print("\n");
	a[2:4] = [["12"]];

	print_array_2d(a+a);
	print("\n");
	*/
/*
	tab = readCSV("Group.csv");
	ar = tab+tab;
	print(str(len(ar)) + "\n");
	print_array(tab[0]);

	print("\n");
	print_array(tab[0][1:3]);
	tab[0][1:3] = [1];
	print("\n");

	writeCSV(tab,"out.csv");
	writeCSV(invert(tab),"outi.csv");

	*/

	
	a=Group;

	a$name = "Name";
	a$(1) = "oi";
	a$year = 1995;
	a$grade = "A";
	a$position = "unemployed";
	
	print(a$name);
	print("\n");
	print(a$age + 5);
	print("\n");
/*
	print(a$(0));
	print("\n");

	print(string_of_tuple(a," ")+"\n");

	a=Group;
	tab = Group[];

	file = readCSV("Group.csv");

	a$name = "Name";
	a$age = 25;
	a$year = 1995;
	a$grade = "A";
	a$position = "unemployed";
	
	i = 0;
	size = len(file);

	while(i < size){
		tup = Group;
		j = 0;
		while(j < len(file[i])){
			tup$(j) = file[i][j];
			j = j+1;
		}
		tab[]=tup;
		i = i+1;
	}
	
	tab[]=a;

	i = 0;
	while(i < len(tab)){
		print(string_of_tuple(tab[i],", "));
		print("\n");
		i = i+1;
	}

	print("\n");
	ab = tab$year;
	print(ab[0]);
	print("\n");
	*/
