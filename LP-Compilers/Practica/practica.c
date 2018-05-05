/*
 * A n t l r  T r a n s l a t i o n  H e a d e r
 *
 * Terence Parr, Will Cohen, and Hank Dietz: 1989-2001
 * Purdue University Electrical Engineering
 * With AHPCRC, University of Minnesota
 * ANTLR Version 1.33MR33
 *
 *   antlr -gt practica.g
 *
 */

#define ANTLR_VERSION	13333
#include "pcctscfg.h"
#include "pccts_stdio.h"

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
#define GENAST

#include "ast.h"

#define zzSET_SIZE 8
#include "antlr.h"
#include "tokens.h"
#include "dlgdef.h"
#include "mode.h"

/* MR23 In order to remove calls to PURIFY use the antlr -nopurify option */

#ifndef PCCTS_PURIFY
#define PCCTS_PURIFY(r,s) memset((char *) &(r),'\0',(s));
#endif

#include "ast.c"
zzASTgvars

ANTLR_INFO

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

  

void
#ifdef __USE_PROTOS
lists(AST**_root)
#else
lists(_root)
AST **_root;
#endif
{
  zzRULE;
  zzBLOCK(zztasp1);
  zzMake0;
  {
  {
    zzBLOCK(zztasp2);
    zzMake0;
    {
    while ( (setwd1[LA(1)]&0x1) ) {
      list_oper(zzSTR); zzlink(_root, &_sibling, &_tail);
      zzLOOP(zztasp2);
    }
    zzEXIT(zztasp2);
    }
  }
  (*_root)=createASTlist(_sibling);
  zzEXIT(zztasp1);
  return;
fail:
  zzEXIT(zztasp1);
  zzsyn(zzMissText, zzBadTok, (ANTLRChar *)"", zzMissSet, zzMissTok, zzErrk, zzBadText);
  zzresynch(setwd1, 0x2);
  }
}

void
#ifdef __USE_PROTOS
list_oper(AST**_root)
#else
list_oper(_root)
AST **_root;
#endif
{
  zzRULE;
  zzBLOCK(zztasp1);
  zzMake0;
  {
  if ( (LA(1)==LID) ) {
    zzmatch(LID); zzsubchild(_root, &_sibling, &_tail); zzCONSUME;
    zzmatch(ASIG); zzsubroot(_root, &_sibling, &_tail); zzCONSUME;
    expr(zzSTR); zzlink(_root, &_sibling, &_tail);
  }
  else {
    if ( (LA(1)==POP) ) {
      zzmatch(POP); zzsubroot(_root, &_sibling, &_tail); zzCONSUME;
      zzmatch(30);  zzCONSUME;
      zzmatch(LID); zzsubchild(_root, &_sibling, &_tail); zzCONSUME;
      zzmatch(31);  zzCONSUME;
    }
    else {
      if ( (LA(1)==FLATTEN) ) {
        zzmatch(FLATTEN); zzsubroot(_root, &_sibling, &_tail); zzCONSUME;
        zzmatch(LID); zzsubchild(_root, &_sibling, &_tail); zzCONSUME;
      }
      else {
        if ( (LA(1)==PRINT) ) {
          zzmatch(PRINT); zzsubroot(_root, &_sibling, &_tail); zzCONSUME;
          id(zzSTR); zzlink(_root, &_sibling, &_tail);
        }
        else {
          if ( (LA(1)==IF) ) {
            zzmatch(IF); zzsubroot(_root, &_sibling, &_tail); zzCONSUME;
            zzmatch(30);  zzCONSUME;
            exprB(zzSTR); zzlink(_root, &_sibling, &_tail);
            zzmatch(31);  zzCONSUME;
            zzmatch(THEN);  zzCONSUME;
            lists(zzSTR); zzlink(_root, &_sibling, &_tail);
            zzmatch(ENDIF);  zzCONSUME;
          }
          else {
            if ( (LA(1)==WHILE) ) {
              zzmatch(WHILE); zzsubroot(_root, &_sibling, &_tail); zzCONSUME;
              zzmatch(30);  zzCONSUME;
              exprB(zzSTR); zzlink(_root, &_sibling, &_tail);
              zzmatch(31);  zzCONSUME;
              zzmatch(DO);  zzCONSUME;
              lists(zzSTR); zzlink(_root, &_sibling, &_tail);
              zzmatch(ENDWHILE);  zzCONSUME;
            }
            else {zzFAIL(1,zzerr1,&zzMissSet,&zzMissText,&zzBadTok,&zzBadText,&zzErrk); goto fail;}
          }
        }
      }
    }
  }
  zzEXIT(zztasp1);
  return;
fail:
  zzEXIT(zztasp1);
  zzsyn(zzMissText, zzBadTok, (ANTLRChar *)"", zzMissSet, zzMissTok, zzErrk, zzBadText);
  zzresynch(setwd1, 0x4);
  }
}

void
#ifdef __USE_PROTOS
id(AST**_root)
#else
id(_root)
AST **_root;
#endif
{
  zzRULE;
  zzBLOCK(zztasp1);
  zzMake0;
  {
  if ( (LA(1)==LID) ) {
    zzmatch(LID); zzsubchild(_root, &_sibling, &_tail); zzCONSUME;
  }
  else {
    if ( (LA(1)==HEAD) ) {
      {
        zzBLOCK(zztasp2);
        zzMake0;
        {
        zzmatch(HEAD); zzsubroot(_root, &_sibling, &_tail); zzCONSUME;
        zzmatch(30);  zzCONSUME;
        zzmatch(LID); zzsubchild(_root, &_sibling, &_tail); zzCONSUME;
        zzmatch(31);  zzCONSUME;
        zzEXIT(zztasp2);
        }
      }
    }
    else {zzFAIL(1,zzerr2,&zzMissSet,&zzMissText,&zzBadTok,&zzBadText,&zzErrk); goto fail;}
  }
  zzEXIT(zztasp1);
  return;
fail:
  zzEXIT(zztasp1);
  zzsyn(zzMissText, zzBadTok, (ANTLRChar *)"", zzMissSet, zzMissTok, zzErrk, zzBadText);
  zzresynch(setwd1, 0x8);
  }
}

void
#ifdef __USE_PROTOS
func(AST**_root)
#else
func(_root)
AST **_root;
#endif
{
  zzRULE;
  zzBLOCK(zztasp1);
  zzMake0;
  {
  {
    zzBLOCK(zztasp2);
    zzMake0;
    {
    if ( (LA(1)==MINUS) ) {
      zzmatch(MINUS); zzsubchild(_root, &_sibling, &_tail); zzCONSUME;
    }
    else {
      if ( (LA(1)==PLUS) ) {
        zzmatch(PLUS); zzsubchild(_root, &_sibling, &_tail); zzCONSUME;
      }
      else {
        if ( (LA(1)==PROD) ) {
          zzmatch(PROD); zzsubchild(_root, &_sibling, &_tail); zzCONSUME;
        }
        else {zzFAIL(1,zzerr3,&zzMissSet,&zzMissText,&zzBadTok,&zzBadText,&zzErrk); goto fail;}
      }
    }
    zzEXIT(zztasp2);
    }
  }
  zzEXIT(zztasp1);
  return;
fail:
  zzEXIT(zztasp1);
  zzsyn(zzMissText, zzBadTok, (ANTLRChar *)"", zzMissSet, zzMissTok, zzErrk, zzBadText);
  zzresynch(setwd1, 0x10);
  }
}

void
#ifdef __USE_PROTOS
exprB(AST**_root)
#else
exprB(_root)
AST **_root;
#endif
{
  zzRULE;
  zzBLOCK(zztasp1);
  zzMake0;
  {
  if ( (LA(1)==NOT) ) {
    zzmatch(NOT); zzsubroot(_root, &_sibling, &_tail); zzCONSUME;
    exprB(zzSTR); zzlink(_root, &_sibling, &_tail);
  }
  else {
    if ( (LA(1)==LID) ) {
      zzmatch(LID); zzsubchild(_root, &_sibling, &_tail); zzCONSUME;
      {
        zzBLOCK(zztasp2);
        zzMake0;
        {
        if ( (LA(1)==DIF) ) {
          zzmatch(DIF); zzsubroot(_root, &_sibling, &_tail); zzCONSUME;
        }
        else {
          if ( (LA(1)==EQ) ) {
            zzmatch(EQ); zzsubroot(_root, &_sibling, &_tail); zzCONSUME;
          }
          else {
            if ( (LA(1)==GT) ) {
              zzmatch(GT); zzsubroot(_root, &_sibling, &_tail); zzCONSUME;
            }
            else {
              if ( (LA(1)==LT) ) {
                zzmatch(LT); zzsubroot(_root, &_sibling, &_tail); zzCONSUME;
              }
              else {zzFAIL(1,zzerr4,&zzMissSet,&zzMissText,&zzBadTok,&zzBadText,&zzErrk); goto fail;}
            }
          }
        }
        zzEXIT(zztasp2);
        }
      }
      zzmatch(LID); zzsubchild(_root, &_sibling, &_tail); zzCONSUME;
    }
    else {
      if ( (LA(1)==EMPTY) ) {
        zzmatch(EMPTY); zzsubroot(_root, &_sibling, &_tail); zzCONSUME;
        zzmatch(30);  zzCONSUME;
        zzmatch(LID); zzsubchild(_root, &_sibling, &_tail); zzCONSUME;
        zzmatch(31);  zzCONSUME;
      }
      else {zzFAIL(1,zzerr5,&zzMissSet,&zzMissText,&zzBadTok,&zzBadText,&zzErrk); goto fail;}
    }
  }
  zzEXIT(zztasp1);
  return;
fail:
  zzEXIT(zztasp1);
  zzsyn(zzMissText, zzBadTok, (ANTLRChar *)"", zzMissSet, zzMissTok, zzErrk, zzBadText);
  zzresynch(setwd1, 0x20);
  }
}

void
#ifdef __USE_PROTOS
expr(AST**_root)
#else
expr(_root)
AST **_root;
#endif
{
  zzRULE;
  zzBLOCK(zztasp1);
  zzMake0;
  {
  if ( (LA(1)==33) ) {
    list(zzSTR); zzlink(_root, &_sibling, &_tail);
  }
  else {
    if ( (LA(1)==LID) ) {
      zzmatch(LID); zzsubchild(_root, &_sibling, &_tail); zzCONSUME;
      zzmatch(CONCAT); zzsubroot(_root, &_sibling, &_tail); zzCONSUME;
      zzmatch(LID); zzsubchild(_root, &_sibling, &_tail); zzCONSUME;
    }
    else {
      if ( (LA(1)==LREDUCE) ) {
        zzmatch(LREDUCE); zzsubroot(_root, &_sibling, &_tail); zzCONSUME;
        func(zzSTR); zzlink(_root, &_sibling, &_tail);
        zzmatch(LID); zzsubchild(_root, &_sibling, &_tail); zzCONSUME;
      }
      else {
        if ( (LA(1)==LMAP) ) {
          zzmatch(LMAP); zzsubroot(_root, &_sibling, &_tail); zzCONSUME;
          func(zzSTR); zzlink(_root, &_sibling, &_tail);
          zzmatch(NUM); zzsubchild(_root, &_sibling, &_tail); zzCONSUME;
          zzmatch(LID); zzsubchild(_root, &_sibling, &_tail); zzCONSUME;
        }
        else {
          if ( (LA(1)==LFILTER) ) {
            zzmatch(LFILTER); zzsubroot(_root, &_sibling, &_tail); zzCONSUME;
            funcTwoPar(zzSTR); zzlink(_root, &_sibling, &_tail);
            zzmatch(LID); zzsubchild(_root, &_sibling, &_tail); zzCONSUME;
          }
          else {zzFAIL(1,zzerr6,&zzMissSet,&zzMissText,&zzBadTok,&zzBadText,&zzErrk); goto fail;}
        }
      }
    }
  }
  zzEXIT(zztasp1);
  return;
fail:
  zzEXIT(zztasp1);
  zzsyn(zzMissText, zzBadTok, (ANTLRChar *)"", zzMissSet, zzMissTok, zzErrk, zzBadText);
  zzresynch(setwd1, 0x40);
  }
}

void
#ifdef __USE_PROTOS
funcTwoPar(AST**_root)
#else
funcTwoPar(_root)
AST **_root;
#endif
{
  zzRULE;
  zzBLOCK(zztasp1);
  zzMake0;
  {
  {
    zzBLOCK(zztasp2);
    zzMake0;
    {
    if ( (LA(1)==DIF) ) {
      zzmatch(DIF); zzsubroot(_root, &_sibling, &_tail); zzCONSUME;
    }
    else {
      if ( (LA(1)==EQ) ) {
        zzmatch(EQ); zzsubroot(_root, &_sibling, &_tail); zzCONSUME;
      }
      else {
        if ( (LA(1)==GT) ) {
          zzmatch(GT); zzsubroot(_root, &_sibling, &_tail); zzCONSUME;
        }
        else {
          if ( (LA(1)==LT) ) {
            zzmatch(LT); zzsubroot(_root, &_sibling, &_tail); zzCONSUME;
          }
          else {zzFAIL(1,zzerr7,&zzMissSet,&zzMissText,&zzBadTok,&zzBadText,&zzErrk); goto fail;}
        }
      }
    }
    zzEXIT(zztasp2);
    }
  }
  zzmatch(NUM); zzsubchild(_root, &_sibling, &_tail); zzCONSUME;
  zzEXIT(zztasp1);
  return;
fail:
  zzEXIT(zztasp1);
  zzsyn(zzMissText, zzBadTok, (ANTLRChar *)"", zzMissSet, zzMissTok, zzErrk, zzBadText);
  zzresynch(setwd1, 0x80);
  }
}

void
#ifdef __USE_PROTOS
list(AST**_root)
#else
list(_root)
AST **_root;
#endif
{
  zzRULE;
  zzBLOCK(zztasp1);
  zzMake0;
  {
  zzmatch(33); zzsubroot(_root, &_sibling, &_tail); zzCONSUME;
  {
    zzBLOCK(zztasp2);
    zzMake0;
    {
    if ( (LA(1)==EMPTYLIST) ) {
      zzmatch(EMPTYLIST);  zzCONSUME;
    }
    else {
      if ( (setwd2[LA(1)]&0x1) ) {
        {
          zzBLOCK(zztasp3);
          zzMake0;
          {
          atomList(zzSTR); zzlink(_root, &_sibling, &_tail);
          zzEXIT(zztasp3);
          }
        }
        {
          zzBLOCK(zztasp3);
          zzMake0;
          {
          while ( (LA(1)==34) ) {
            zzmatch(34);  zzCONSUME;
            atomList(zzSTR); zzlink(_root, &_sibling, &_tail);
            zzLOOP(zztasp3);
          }
          zzEXIT(zztasp3);
          }
        }
        zzmatch(EMPTYLIST);  zzCONSUME;
      }
      else {zzFAIL(1,zzerr8,&zzMissSet,&zzMissText,&zzBadTok,&zzBadText,&zzErrk); goto fail;}
    }
    zzEXIT(zztasp2);
    }
  }
  zzEXIT(zztasp1);
  return;
fail:
  zzEXIT(zztasp1);
  zzsyn(zzMissText, zzBadTok, (ANTLRChar *)"", zzMissSet, zzMissTok, zzErrk, zzBadText);
  zzresynch(setwd2, 0x2);
  }
}

void
#ifdef __USE_PROTOS
atomList(AST**_root)
#else
atomList(_root)
AST **_root;
#endif
{
  zzRULE;
  zzBLOCK(zztasp1);
  zzMake0;
  {
  {
    zzBLOCK(zztasp2);
    zzMake0;
    {
    if ( (LA(1)==33) ) {
      list(zzSTR); zzlink(_root, &_sibling, &_tail);
    }
    else {
      if ( (LA(1)==NUM) ) {
        zzmatch(NUM); zzsubchild(_root, &_sibling, &_tail); zzCONSUME;
      }
      else {zzFAIL(1,zzerr9,&zzMissSet,&zzMissText,&zzBadTok,&zzBadText,&zzErrk); goto fail;}
    }
    zzEXIT(zztasp2);
    }
  }
  zzEXIT(zztasp1);
  return;
fail:
  zzEXIT(zztasp1);
  zzsyn(zzMissText, zzBadTok, (ANTLRChar *)"", zzMissSet, zzMissTok, zzErrk, zzBadText);
  zzresynch(setwd2, 0x4);
  }
}
