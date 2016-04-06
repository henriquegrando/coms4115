
fun foo(a) {
	print("oi\n");
	return a;
}

fun bar(a) {
	print("Hello World!\n");
	foo(a);
	return a;
}

bar(1);
