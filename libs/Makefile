CC = gcc
CFLAGS = -g -Wall
LDFLAGS = -g

libdamplio.a: damplio.o damplstr.o dampllib.o dampltup.o
	ar rc libdampllib.a damplio.o damplstr.o dampllib.o dampltup.o
	ranlib libdampllib.a

damplio.o: damplio.h
damplstr.o: damplstr.h
dampllib.o: dampllib.h
dampltup.o: dampltup.h

.PHONY: clean
clean:
	rm -f *.o *.a

.PHONY: all
all: clean libdampllib.a