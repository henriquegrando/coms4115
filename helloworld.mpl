
fun foo(a) {
	b=1;
	print("hi\n");
	lastone();
	return a;
}

fun bar(a) {
	print("Hello World!\n");
	/* foo(a); */
	return foo(a);
}

b=1;
bar(1);
/* foo(bar(1)); */

fun lastone() {
	print("bye!\n");
}