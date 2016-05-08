
tuple Tup{aa,bb:real,cc}

fun foo() {
	a=[[1,2],[3,4]];
	for i in a {
		for j in i {
			print(j);
		}
	}
}

fun bar(table) {
	for t in table {
		len(table[]);
	}
}

a=Tup[];
bar(a);



