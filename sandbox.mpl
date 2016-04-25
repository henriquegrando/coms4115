
tuple Tup{a,b,c}

/*
tuple Tup2{a,bc};

fun convert(t) {
	t2 = Tup2;
	t2$a = t$a;
	t2$bc = t$b + t$c;
}

tab = Tup[];
*/
/* y = map tab using convert; */


fun foo(a) {
	print("Hi\n");
	b=1;
	b=a;
	bar(a);
	return 1;
}

fun bar(a) {
	print("bye!\n");
}

foo(1);
foo(1.1);


add(1,2);
add(1,1.1);

fun add(a,b) {
	return a+b;
}