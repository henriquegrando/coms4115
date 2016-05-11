fun join(arr, separator){
	i = 1;
	
	size = len(arr);

	new_str = str(arr[0]);

	while(i < size){
		new_str = new_str + separator + str(arr[i]);
		i = i + 1;
	}

	return new_str;
}

a = [1, 2, 3, 4, 5];
a_str = join(a, ",");

print(a_str);