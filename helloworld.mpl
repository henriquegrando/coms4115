
fun foo(a) {
	print("hi\n");
	lastone();
	return;
}

fun bar(a) {
	print("Hello World!\n");
	foo(a);
	return a;
}

bar(1);

fun lastone() {
	print("bye!\n");
}