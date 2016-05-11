.PHONY: project
project:
	cd src; make; cp dampl ../dampl
	cd libs; make
	./dampl mycsv.mpl > mycsv.c
	gcc mycsv.c -O2 -o mycsv -Ilibs/ -Llibs/ -ldampllib

.PHONY: clean
clean:
	rm -f *.c hello dampl sandbox
	cd src; make clean
	cd libs; make clean
