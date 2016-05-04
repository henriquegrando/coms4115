CC = gcc
CFLAGS = -g -Wall
LDFLAGS = -g

libdamplio.a: damplio.o damplstr.o dampllib.o
	ar rc libdampllib.a damplio.o damplstr.o dampllib.o
	ranlib libdampllib.a

damplio.o: damplio.h
damplstr.h: damplstr.h
dampllib.h: dampllib.h

.PHONY: clean
clean:
	rm -f *.o *.a

.PHONY: all
all: clean libdampllib.a