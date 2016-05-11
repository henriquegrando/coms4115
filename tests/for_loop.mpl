include "../DaMPL_stdlib.mpl";

array_real = [6.12, 3.1415, 2.21, 9.0001, 123.0, 5.6];

for i in array_real {
	print(str(i) + "\n");
}

tuple T {a:real, b:integer, c}

t = T;

t$a = 3.111;
t$b = 12356;
t$c = "abc";

for j in tuple_to_array(t) {
	print(str(j) + "\n");
}

for i in range(1, 11) {
	print(str(i) + "\n");
}