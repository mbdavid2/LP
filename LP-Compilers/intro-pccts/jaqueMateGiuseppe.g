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
#token SPACE "[\ \n]" << zzskip(); >>

input: expr "@" ;
expr: NUM PLUS expr;

