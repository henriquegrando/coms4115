
fun foo() {
	a=[[1,2],[3,4]];
	for i in a {
		for j in i {
			print(j);
		}
	}
}

fun bar(a,b) {
	return a+b;
}


foo();

bar(1,2);
bar("a","b");


