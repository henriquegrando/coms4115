.PHONY: project
project:
	cd src; make; cp dampl ../dampl
	cd libs; make
	./dampl < helloworld.mpl > helloworld.c
	gcc helloworld.c -o hello -Ilibs/ -Llibs/ -ldamplio	

.PHONY: clean
clean:
	rm -f *.c hello dampl
	cd src; make clean
	cd libs; make clean
