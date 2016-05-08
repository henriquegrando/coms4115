tuple Tup{aa,bb:real,cc}

a=[[1],[2]];

tab=Tup[];

fun bar(t) {
	print(len(t[]));
}

bar(tab);


/*
fun foo() {
	a=[[1,2],[3,4]];
	for i in a {
		for j in i {
			print(j);
		}
	}
}

fun bar(table) {
	print(len(table));
	for t in table {
		print(len(table[]));
	}
}

a=Tup[];
bar(a);

*/

