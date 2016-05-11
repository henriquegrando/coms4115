str_file = readfile("./tests/text_input.txt");
print(str_file);

writefile("./tests/test.txt", "Bonjour Monde!");

file1 = open("./tests/text_input.txt", "r");
bonjour = readline(file1);

close(file1);
