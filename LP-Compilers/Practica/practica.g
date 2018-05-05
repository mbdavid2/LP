#header
<<
#include <string>
#include <iostream>
using namespace std;

// struct to store information about tokens
typedef struct {
  string kind;
  string text;
} Attrib;

// function to fill token information (predeclaration)
void zzcr_attr(Attrib *attr, int type, char *text);

// fields for AST nodes
#define AST_FIELDS string kind; string text;
#include "ast.h"

// macro to create a new AST node (and function predeclaration)
#define zzcr_ast(as,attr,ttype,textt) as=createASTnode(attr,ttype,textt)
AST* createASTnode(Attrib* attr, int ttype, char *textt);
>>

<<
#include <cstdlib>
#include <cmath>
#include <map>

map<string,int> m; //To store the variables

// function to fill token information
void zzcr_attr(Attrib *attr, int type, char *text) {
  /*if (type == NUM) {
    //attr->kind = "intconst";
    attr->text = text;
  }
  else if (type == LID) {
    //attr->kind = "LID";
    attr->text = text;
  }*/
  //else {
    attr->kind = text;
    attr->text = "";
  //}
}

// function to create a new AST node
AST* createASTnode(Attrib* attr, int type, char* text) {
  AST* as = new AST;
  as->kind = attr->kind; 
  as->text = attr->text;
  as->right = NULL; 
  as->down = NULL;
  return as;
}

/// get nth child of a tree. Count starts at 0.
/// if no such child, returns NULL
AST* child(AST *a,int n) {
 AST *c=a->down;
 for (int i=0; c!=NULL && i<n; i++) c=c->right;
 return c;
} 

/// print AST, recursively, with indentation
void ASTPrintIndent(AST *a,string s)
{
  if (a==NULL) return;

  cout<<a->kind;
  if (a->text!="") cout<<"("<<a->text<<")";
  cout<<endl;

  AST *i = a->down;
  while (i!=NULL && i->right!=NULL) {
    cout<<s+"  \\__";
    ASTPrintIndent(i,s+"  |"+string(i->kind.size()+i->text.size(),' '));
    i=i->right;
  }
  
  if (i!=NULL) {
      cout<<s+"  \\__";
      ASTPrintIndent(i,s+"   "+string(i->kind.size()+i->text.size(),' '));
      i=i->right;
  }
}

/// print AST 
void ASTPrint(AST *a)
{
  while (a!=NULL) {
    cout<<" ";
    ASTPrintIndent(a,"");
    a=a->right;
  }
}

AST* createASTlist(AST* childs) {
  AST* as = new AST;
  as->kind = "list"; 
  //as->text = "list";
  as->right = NULL; 
  as->down = childs;
  return as;
}

/*int evaluate(AST *a) {
    return 0;
    if (a == NULL) return 0;
    else if (a->kind == "intconst")
        return atoi(a->text.c_str());
    else if (a->kind == "+")
        return evaluate(child(a,0)) + evaluate(child(a,1));
    else if (a->kind == "-")
        return evaluate(child(a,0)) - evaluate(child(a,1));
    else if (a->kind == "*")
        return evaluate(child(a,0)) * evaluate(child(a,1));
    else if (a->kind == "/")
        return evaluate(child(a,0)) / evaluate(child(a,1));
    else if (a->kind == "id") {
        string id = a->text;
        return m[id];
    }
}

bool evaluateB(AST *a) {
    return (evaluate(child(a,0))) == (evaluate(child(a,1)));
}

void execute(AST *a) {
    if (a == NULL)
        return;
    else if (a->kind == ":=") {
        m[child(a,0)->text] = evaluate(child(a,1));
    }
    else if (a->kind == "if"){
        if (evaluateB(child(a,0))) execute(child(a,1));
    }
    else if (a->kind == "write")
        cout << evaluate(child(a,0)) << endl;
    
    execute(a->right);
}*/

int main() {
    AST *root = NULL;
    ANTLR(lists(&root), stdin);
    ASTPrint(root);
    //execute(root);
}

>>

#lexclass START
#token NUM "[0-9]+"
#token PLUS "\+"
#token MINUS "\-"
#token PROD "\*"
#token CONCAT "\#"
#token ASIG "="

#token FLATTEN "flatten"
#token POP "pop"

#token PRINT "print"
#token HEAD "head"

#token LREDUCE "lreduce"
#token LMAP "lmap"
#token LFILTER "lfilter"

#token EMPTYLIST "\]"
#token EQUAL "=="
#token DIF "\!="
#token GT "\>"
#token LT "\<"
#token EMPTY "empty"
#token NOT "not"

#token IF "if"
#token THEN "then"
#token ENDIF "endif"

#token WHILE "while"
#token DO "do"
#token ENDWHILE "endwhile"


#token LID "[a-zA-Z][a-zA-Z0-9]*"
#token SPACE "[\ \n]" << zzskip();>>
//#token COMMENT "[\/\/][(\n|\r)]*[\r]?[\n]" << zzskip();>>

lists: (list_oper)* <<#0=createASTlist(_sibling);>> ;
list_oper: LID ASIG^ expr
         | POP^ "\("! LID "\)"! 
         | FLATTEN^ LID
         | PRINT^ id
         | IF^ "\("! exprB "\)"! THEN! lists ENDIF!
         | WHILE^ "\("! exprB "\)"! DO! lists ENDWHILE!
         ;

id: LID | (HEAD^ "\("! LID "\)"!);



//expr d'assignació
func: (MINUS | PLUS | PROD);
exprB: NOT^ exprB
	 | LID (DIF^ | EQ^ | GT^ | LT^) LID
	 | EMPTY^ "\("! LID "\)"! 
	 ;
expr: list
    | LID CONCAT^ LID
    | LREDUCE^ func LID
    | LMAP^ func NUM LID
    | LFILTER^ funcTwoPar LID
    ;

funcTwoPar: (DIF^ | EQ^ | GT^ | LT^) NUM; //Per que quedi igual el filter :/

//Definicio llista
list: "\["^ (EMPTYLIST! | (atomList) ("\,"! atomList)* "\]"!);
atomList: (list | NUM);

// Comments (inline C++-style)
//COMMENT   : "//" ~("\n"|"\r")* "\r"? "\n" -> skip ;

// White spaces
//WS        : (" "|"\t"|"\r"|"\n")+ -> skip ;

