fun foo(a) {
	b=1;
	print("hi\n");
	lastone();
	return a;
}

fun bar(a) {
	c=1.1;
	print("Hello World!\n");
	/* foo(a); */ /* PROBLEMA QUANDO VARIAVEL LOCAL OU global É PASSADA COMO PARAMETRO */
	return foo(a);
}


fun lastone() {
	print("bye!\n");
}