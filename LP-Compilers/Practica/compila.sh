if [ -z "$1" ] 
then
	echo "usage: ./compila.sh fileName sense extensio."
	echo "Exemple: ./compila.sh practica"
	exit 1
fi
antlr -gt $1.g
dlg -ci parser.dlg scan.c 
g++ -I/usr/include/pccts -std=c++11 -Wno-write-strings -o $1 $1.c scan.c err.c 

