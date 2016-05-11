#!/bin/sh

# Regression testing script for DaMPL Compiler
# Step through a list of files
#  Compile, run, and check the output of each expected-to-work test
#  Compile and check the error of each expected-to-fail test

# Path to C Compiler (GCC)
GCC="gcc"
LDFLAG="-g -Llibs/"
CFLAG="-Ilibs/"
LDLIB="-ldampllib"
#GCC="usr/bin/gcc"

# DaMPL compiler.
DAMPLC="./dampl"

Build() {
	cd src &&
	make &&
	cp dampl ../dampl 
	cd ..
	cd libs &&
	make &&
	cd ..
}

# Main #

# Builds the compiler
Build

# Test files
files="tests/*.mpl"

for file in $files
do
	echo ""

	filename="${file%.*}"
	echo "File: \"${file}\""
	echo "Compiling from .mpl to .c ..."
	eval "$DAMPLC" "${file}" ">" "${filename}.c" "2> ./tests/temp.out"

	if [ -s ./tests/temp.out ]; then
    	echo "Compile time error, aborting test ..."

    	diff -b ${filename}.out ./tests/temp.out > ${filename}.diff 2>&1

		rm ./tests/temp.out
    	
    	echo "Done."
    	continue
	else 
		echo "Generating the executable file ..."
		eval "$GCC" "-o" "${filename}" "${filename}.c" "$CFLAG" "$LDFLAG" "$LDLIB"

		echo "Testing the generated file ..."
		./${filename} > ./tests/temp.out 2>&1

		diff -b ${filename}.out ./tests/temp.out > ${filename}.diff 2>&1

		rm ./tests/temp.out
		rm ${filename}

		echo "Done."
	fi
done