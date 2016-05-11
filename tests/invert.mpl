fun invert(arr) {
	new_arr = [];

	i = len(arr) - 1;
	
	while(i >= 0) {
		new_arr[] = arr[i];
		i = i-1;
	}


	return new_arr;
}

a = [5, 4, 3, 2, 1];
a = invert(a);

print(a);