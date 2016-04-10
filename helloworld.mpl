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

b=1;
bar(1.1);
/* foo(bar(1)); */

fun lastone() {
	print("bye!\n");
}