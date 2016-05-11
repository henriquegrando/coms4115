tuple Test {a, b, c:integer}

t = Test;
t2 = Test;

t$a = "ta";
t$b = "tb";
t$c = 123;

t2$a = "t2a";
t2$b = "t2b";
t2$c = 456;

print(7);
print("\n");
print(2.67);
print("\n");
print("abc");
print("\n");
print(t);
print("\n");

arr_int = [1, 2, 3, 4, 5];
arr_float = [8.12, 9.123, 64.23, 3.1415];
arr_str = ["hello", "bonjour", "ola"];
arr_tup = [t2, t];

print(arr_int);
print(arr_float);
print(arr_str);
print(arr_tup);

arr_str2 = ["world", "monde", "mundo"];

arr_arr = [arr_str, arr_str2];

print(arr_arr);