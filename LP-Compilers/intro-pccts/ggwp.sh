antlr $1.g
dlg parser.dlg scan.c 
gcc -o $1 $1.c scan.c err.c

