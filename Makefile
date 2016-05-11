.PHONY: project
project:
	cd src; make; cp dampl ../dampl
	cd libs; make
	./dampl helloworld.mpl > helloworld.c
	gcc helloworld.c -o hello -Ilibs/ -Llibs/ -ldampllib

.PHONY: clean
clean:
	rm -f *.c hello dampl sandbox
	cd src; make clean
	cd libs; make clean
