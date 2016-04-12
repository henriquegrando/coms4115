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

fun add(a,b) {
	return a+b;
}