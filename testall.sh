#!/bin/sh

# Regression testing script for DaMPL Compiler
# Step through a list of files
#  Compile, run, and check the output of each expected-to-work test
#  Compile and check the error of each expected-to-fail test

# Path to C Compiler (GCC)
GCC="gcc"
LDFLAG="-g -Llibs/"
CFLAG="-Ilibs/"
LDLIB="-ldamplio"
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
	filename="${file%.*}"
	eval "$DAMPLC" "<" "${file}" ">" "${filename}.c"
	eval "$GCC" "-o" "${filename}" "${filename}.c" "$CFLAG" "$LDFLAG" "$LDLIB"

	./${filename} > ./tests/temp.out

	diff -b ${filename}.out temp.out > ${filename}.diff 1>&2

	rm ./tests/temp.out
	rm ${filename}
done