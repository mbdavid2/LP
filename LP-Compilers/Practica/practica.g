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
#include <list>

struct ElemList {
 bool isNum;
 int num;
 list<ElemList> llista;
};

typedef list<ElemList> hetList;
typedef hetList::iterator hetIter;

ElemList initElem (int n, hetList l, bool ty) {
    ElemList newElem;
    newElem.isNum = ty;
    newElem.num = n;
    newElem.llista = l;
    return newElem;
}

void printHetList (hetList& llista) {
    cout << "[";
    hetIter it;
    int i = 0;
    for (it = llista.begin(); it != llista.end(); it++) {
        if (!(*it).isNum) printHetList(((*it).llista));
        else cout << (*it).num;
        if (i < llista.size()-1) cout << ",";
        i++;
    }
    cout << "]";
}

void printHeadHetList (hetList& llista) {
    if (llista.empty()) return;
    hetIter it = llista.begin();
    if (!(*it).isNum) printHetList((*it).llista);
    else cout << (*it).num;
    cout << endl;
}

map<string,hetList> m; //To store the variables

// function to fill token information
void zzcr_attr(Attrib *attr, int type, char *text) {
    attr->kind = text;
    attr->text = "";
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

void appendHetLists(hetList& result, hetList& A, hetList& B) {
    result = A;
    for (auto el : B) result.push_back(el);
}

void popHetList(hetList& l) {
    if (!l.empty()) l.pop_front();
}

void flattenHetList (hetList& l) {
    hetList flatList;
    for (auto el: l) {
        if (el.isNum) flatList.push_back(el);
        else {
            hetList newL = el.llista;
            flattenHetList(newL);
            appendHetLists(flatList, flatList, newL);
        }
    }
    l = flatList;
}

int reduceHetList(string op, hetList& l) {
    int result = 0;
    if (op == "+") {
        for (auto el: l) {
            if (el.isNum) result += el.num;
            else result += reduceHetList(op, el.llista);
        }
    }
    else if (op == "-") {
        for (auto el: l) {
            if (el.isNum) result -= el.num;
            else result *= reduceHetList(op, el.llista);
        }
    }
    else if (op == "*") {
        for (auto el: l) {
            if (el.isNum) result *= el.num;
            else result *= reduceHetList(op, el.llista);
        }
    }
    return result;
}

void mapHetList(hetList& res, string op, int n, hetList& llista) {
    res = llista;
    hetIter it;
    for (it = res.begin(); it != res.end(); it++) {
        if ((*it).isNum) {
            //NUM//
            if (op == "+") (*it).num += n;
            else if (op == "-") (*it).num -= n;
            else if (op == "*") (*it).num *= n;
        }
        else mapHetList((*it).llista, op, n, (*it).llista);
    }
}

void filterHetList(hetList& res, string binOp, int n, hetList& l) {
    hetIter it;
    for (it = l.begin(); it != l.end(); it++) {
        if ((*it).isNum) {
            if (binOp == "!=") {
                if ((*it).num != n) res.push_back((*it));
            }
            else if (binOp == "==") {
                if ((*it).num == n) res.push_back((*it));
            }
            else if (binOp == ">") {
                if ((*it).num > n) res.push_back((*it));
            }
            else if (binOp == "<") {
                if ((*it).num < n) res.push_back((*it));
            }
        }
        else {
            hetList insideList;
            filterHetList(insideList, binOp, n, (*it).llista);
            res.push_back(initElem(-1, insideList, false));
        }
    }
}

bool isEmptyHetList(hetList& l) {
    return l.empty();
    //Versio per comprovar si hi ha numeros
    /*if (l.empty()) return true;
    else {
        hetIter it;
        bool aux = true;
        for (it = l.begin(); it != l.end(); it++) {
            if ((*it).isNum) return false;
            else {
                aux = isEmptyHetList((*it).llista);
                if (!aux) return false;
            }
        }
    }
    return true;*/
}

hetList evaluateList(AST *a) {
    hetList llista;
    if (a == NULL) return llista;
    if (a->kind == "[") {
        int i = 0;
        while (child(a,i) != NULL) {
            ElemList el;
            if (child(a,i)->kind != "[") {
                //Numero//
                el = initElem(stoi(child(a,i)->kind), llista, true);
            }
            else if (child(a,i)->kind == "[") {
                //Llista//
                hetList insideList = evaluateList(child(a,i));
                el = initElem(-1, insideList, false);
            }
            llista.push_back(el);
            ++i;
        }
    }
    else if (a->kind == "#") {
        //Concat//
        hetList firstList = evaluateList(child(a,0));
        hetList secondList = evaluateList(child(a,1));
        appendHetLists(llista, firstList, secondList);
        return llista;
    }
    else if (a->kind == "lreduce") {
        int res = reduceHetList(child(a,0)->kind, m[child(a,1)->kind]);
        ElemList el = initElem(res, llista, true);
        llista.push_back(el);
    }
    else if (a->kind == "lmap") {
        mapHetList(llista, child(a,0)->kind, stoi(child(a,1)->kind), m[child(a,2)->kind]);
        return llista;
    }
    else if (a->kind == "lfilter") {
        filterHetList(llista, child(a,0)->kind, stoi(child(child(a,0),0)->kind), m[child(a,1)->kind]);
        return llista;
    }
    else {
        //Ident//
        llista = m[a->kind];
        return llista;
    }
    return llista;
}

bool compareHetLists(string op, hetList& A, hetList& B) {
    //Pre: flattened lists
    if (op == "==") if (A.size() != B.size()) return false;
    hetIter it1, it2;
    it1 = A.begin();
    it2 = B.begin();
    while (it1 != A.end() or it2 != B.end()){
        if (op == "==") if((*it1).num != (*it2).num) return false;
        if (op == ">") {
             if (it1 == A.end() and it2 != B.end()) return false;
             if (it1 != A.end() and it2 == B.end()) return true;
             if ((*it1).num < (*it2).num) return false;
             else if ((*it1).num > (*it2).num) return true;
        }
        if (op == "<") {
            if (it1 == A.end() and it2 != B.end()) return true;
            if (it1 != A.end() and it2 == B.end()) return false;
            if ((*it1).num < (*it2).num) return true;
            else if ((*it1).num > (*it2).num) return false;
        }
        it1++;
        it2++;
    }
    return false;
}

bool checkBooleanExpr(AST *a) {
    bool aux = false;
    string op = a->kind;
    if (op == "and") aux = (checkBooleanExpr(child(a,0))) and (checkBooleanExpr(child(a,1)));
    else if (op == "or") aux = (checkBooleanExpr(child(a,0))) or (checkBooleanExpr(child(a,1)));
    else if (op == "not") aux = !(checkBooleanExpr(child(a,0)));
    else if (op == "empty") aux = isEmptyHetList(m[child(a,0)->kind]);
    else if (op == ">") aux = compareHetLists(op, m[child(a,0)->kind], m[child(a,1)->kind]);
    else if (op == "<") aux = compareHetLists(op, m[child(a,0)->kind], m[child(a,1)->kind]);
    else if (op == ">=") aux = !compareHetLists("<", m[child(a,0)->kind], m[child(a,1)->kind]);
    else if (op == "<=") aux = !compareHetLists(">", m[child(a,0)->kind], m[child(a,1)->kind]);
    else if (op == "==") aux = compareHetLists(op, m[child(a,0)->kind], m[child(a,1)->kind]);
    else if (op == "!=") aux = !compareHetLists(op, m[child(a,0)->kind], m[child(a,1)->kind]);
    return aux;
}

void execute(AST *a) {
    if (a == NULL) return;
    else if (a->kind == "=") {
        m[child(a,0)->kind] = evaluateList(child(a,1));
    }
    else if (a->kind == "print") {
        if (child(a,0)->kind == "head") printHeadHetList(m[child(child(a,0),0)->kind]);
        else {
            //cout << child(a,0)->kind << " = ";
            printHetList(m[child(a,0)->kind]);
            cout << endl;
        }
    }
    else if (a->kind == "pop") {
        popHetList(m[child(a,0)->kind]);
    }
    else if (a->kind == "flatten") {
        flattenHetList(m[child(a,0)->kind]);
    }
    else if (a->kind == "if") {
        bool bExpr = checkBooleanExpr(child(a,0));
        if (bExpr) execute(child(a,1)->down);
    }
    else if (a->kind == "while") {
        bool bExpr = checkBooleanExpr(child(a,0));
        AST *b = child(a,1)->down;
        while (bExpr) {
            execute(b);
            bExpr = checkBooleanExpr(child(a,0));
        }
    }
    else cout << "nope" << endl;
    execute(a->right);
}

int main() {
    AST *root = NULL;
    ANTLR(lists(&root), stdin);
    ASTPrint(root);
    execute(root->down);
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
#token EQ "\=="
#token DIF "\!="
#token GT "\>"
#token LT "\<"
#token GTE "\>="
#token LTE "\<="
#token EMPTY "empty"
#token AND "and"
#token OR "or"
#token NOT "not"

#token IF "if"
#token THEN "then"
#token ENDIF "endif"

#token WHILE "while"
#token DO "do"
#token ENDWHILE "endwhile"


#token LID "[a-zA-Z][a-zA-Z0-9]*"
#token SPACE "[\ \n]" << zzskip();>>


lists: (list_oper)* <<#0=createASTlist(_sibling);>> ;
list_oper: LID ASIG^ expr
         | POP^ "\("! LID "\)"!
         | FLATTEN^ LID
         | PRINT^ elem
         | IF^ "\("! exprB "\)"! THEN! lists ENDIF!
         | WHILE^ "\("! exprB "\)"! DO! lists ENDWHILE!
         ;

elem : (LID^ | (HEAD^ "\("! LID "\)"!));

exprB: exprBor (AND^ exprBor)*;

exprBor: exprBnot (OR^ exprBnot)*;

exprBnot: (NOT^ | ) exprBatom;

exprBatom: (LID | listDef) (DIF^ | EQ^ | GT^ | LT^ | GTE^ | LTE^) (LID | listDef)
         | EMPTY^ "\("! LID "\)"!
         | "\("! exprB "\)"!
         ;

expr: listDef
    | LID CONCAT^ LID
    | LREDUCE^ func LID
    | LMAP^ func NUM LID
    | LFILTER^ innerFunc LID
    ;
func: (MINUS | PLUS | PROD);
innerFunc: (DIF^ | EQ^ | GT^ | LT^ | GTE^ | LTE^) NUM;

listDef: "\["^ (EMPTYLIST! | (atomList) ("\,"! atomList)* "\]"!);
atomList: (listDef | NUM);
