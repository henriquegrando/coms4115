DAMPL Project

Bernardo Abreu      bd2440
Henrique Grando     hp2409
Hugo Sousa          ha2398
Felipe Rocha        flt2107

    This project shows the DAMPL compiler working for a Hello World file written 
in our language. The functionalities of the compiler are not yet fully
implemented, as so, it's not possible to call it using something like:

    damplc helloworld.mpl 

    Instead, the source program to be compiled is received from the standard 
input and its correspondent C program is printed to stdout. The redirection of
the input and output is performed in the Makefile as well as the following 
compilation of the C code using GCC.
    In order to test this Hello World example, while in the root directory of
the project type:

    make
    ./hello

    
