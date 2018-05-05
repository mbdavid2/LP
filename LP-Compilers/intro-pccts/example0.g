#header 
<< #include "charptr.h" >>

<<
#include "charptr.c"

int main() {
   ANTLR(input(),stdin);
}

>>

#lexclass START
#token NUM "[0-9]+"
#token PLUS "\+"
#token MINUS "\-"
#token MULT "\*"
#token DIV "\/"
#token SPACE "[\ \n]" << zzskip(); >>

input: expr "@" ;
expr: NUM ( | (PLUS | MINUS | MULT | DIV) expr);
