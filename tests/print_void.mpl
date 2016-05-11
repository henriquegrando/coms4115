include "../DaMPL_stdlib.mpl";

/* This function returns void */
fun print10Hellos() {
	for i in range(0, 10) {
		print("Hello\n");
	}
}

print( print10Hellos() );