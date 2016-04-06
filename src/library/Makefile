CC = gcc
CFLAGS = -g -Wall
LDFLAGS = -g

libdamplio.a: damplio.o damplio.h
	ar rc libdamplio.a damplio.o
	ranlib libdamplio.a

damplio.o: damplio.h

.PHONY: clean
clean:
	rm -f *.o *.a

.PHONY: all
all: clean libdamplio.a