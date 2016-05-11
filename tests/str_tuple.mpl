fun string_of_tuple(tup,separator) {
	str = tup$(0);

	i = 1;
	while(i < len(tup)) {
		str = str + separator + tup$(i) ;
		i = i+1;
	}

	return str;
}



tuple Person {name, age:integer, address}

b = Person;
b$name = "Bernie";
b$age = 21;
b$address = "Bauxita Street";

print(string_of_tuple(b, ", "));