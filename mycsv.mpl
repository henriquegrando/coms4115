include "DaMPL_stdlib.mpl";

tuple Report {cdatetime, address,district:integer,beat,grid:integer,crimedescr,ucr_ncic_code:integer, latitude:real,longitude:real}


tab = Report[];

readCSV("SacramentocrimeJanuary2006.csv", tab);

tab = tab[1:];


arr = tab$cdatetime;

size = len(arr);

i = 0;

writefile("out.txt",join(arr, "\n"));

while (i<size){
	arr[i] = str(i);

	i = i+1;
}

writefile("out2.txt",join(arr, "\n"));


tab$cdatetime = arr;

writeCSV(tab,"tst.csv");

