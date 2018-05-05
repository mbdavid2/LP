/*
 * A n t l r  T r a n s l a t i o n  H e a d e r
 *
 * Terence Parr, Will Cohen, and Hank Dietz: 1989-2001
 * Purdue University Electrical Engineering
 * With AHPCRC, University of Minnesota
 * ANTLR Version 1.33MR33
 *
 *   antlr example1.g
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
#define zzSET_SIZE 4
#include "antlr.h"
#include "tokens.h"
#include "dlgdef.h"
#include "mode.h"

/* MR23 In order to remove calls to PURIFY use the antlr -nopurify option */

#ifndef PCCTS_PURIFY
#define PCCTS_PURIFY(r,s) memset((char *) &(r),'\0',(s));
#endif

ANTLR_INFO

#include <cstdlib>
#include <cmath>
#include <map>

map<string,int> m; //To store the variables

// function to fill token information
void zzcr_attr(Attrib *attr, int type, char *text) {
  if (type == NUM) {
    attr->kind = "intconst";
    attr->text = text;
  }
  else if (type == ID) {
    attr->kind = "id";
    attr->text = text;
  }
  else if (type == ASIG) {
    attr->kind = ":=";
    attr->text = text;
  }
  else if (type == WRITE) {
    attr->kind = "write";
    attr->text = text;
  }
  else if (type == IF) {
    attr->kind = "if";
    attr->text = text;
  }
  else {
    attr->kind = text;
    attr->text = "";
  }
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

int evaluate(AST *a) {
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
}

int main() {
  AST *root = NULL;
  ANTLR(program(&root), stdin);
  ASTPrint(root);
  execute(root);
}

  

void
#ifdef __USE_PROTOS
program(void)
#else
program()
#endif
{
  zzRULE;
  zzBLOCK(zztasp1);
  zzMake0;
  {
  linst();
  zzEXIT(zztasp1);
  return;
fail:
  zzEXIT(zztasp1);
  zzsyn(zzMissText, zzBadTok, (ANTLRChar *)"", zzMissSet, zzMissTok, zzErrk, zzBadText);
  zzresynch(setwd1, 0x1);
  }
}

void
#ifdef __USE_PROTOS
linst(void)
#else
linst()
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
    while ( (setwd1[LA(1)]&0x2) ) {
      instruction();
      zzLOOP(zztasp2);
    }
    zzEXIT(zztasp2);
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
instruction(void)
#else
instruction()
#endif
{
  zzRULE;
  zzBLOCK(zztasp1);
  zzMake0;
  {
  if ( (LA(1)==ID) ) {
    zzmatch(ID); zzCONSUME;
    zzmatch(ASIG); zzCONSUME;
    expr();
  }
  else {
    if ( (LA(1)==WRITE) ) {
      zzmatch(WRITE); zzCONSUME;
      expr();
    }
    else {
      if ( (LA(1)==IF) ) {
        zzmatch(IF); zzCONSUME;
        zzmatch(15); zzCONSUME;
        exprB();
        zzmatch(16); zzCONSUME;
        zzmatch(THEN); zzCONSUME;
        zzmatch(17); zzCONSUME;
        linst();
        zzmatch(18); zzCONSUME;
        zzmatch(ENDIF); zzCONSUME;
      }
      else {zzFAIL(1,zzerr1,&zzMissSet,&zzMissText,&zzBadTok,&zzBadText,&zzErrk); goto fail;}
    }
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
exprB(void)
#else
exprB()
#endif
{
  zzRULE;
  zzBLOCK(zztasp1);
  zzMake0;
  {
  expr();
  zzmatch(EQUAL); zzCONSUME;
  expr();
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
expr(void)
#else
expr()
#endif
{
  zzRULE;
  zzBLOCK(zztasp1);
  zzMake0;
  {
  term();
  {
    zzBLOCK(zztasp2);
    zzMake0;
    {
    while ( (setwd1[LA(1)]&0x20) ) {
      {
        zzBLOCK(zztasp3);
        zzMake0;
        {
        if ( (LA(1)==MINUS) ) {
          zzmatch(MINUS); zzCONSUME;
        }
        else {
          if ( (LA(1)==PLUS) ) {
            zzmatch(PLUS); zzCONSUME;
          }
          else {zzFAIL(1,zzerr2,&zzMissSet,&zzMissText,&zzBadTok,&zzBadText,&zzErrk); goto fail;}
        }
        zzEXIT(zztasp3);
        }
      }
      term();
      zzLOOP(zztasp2);
    }
    zzEXIT(zztasp2);
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
term(void)
#else
term()
#endif
{
  zzRULE;
  zzBLOCK(zztasp1);
  zzMake0;
  {
  atom();
  {
    zzBLOCK(zztasp2);
    zzMake0;
    {
    while ( (setwd1[LA(1)]&0x80) ) {
      {
        zzBLOCK(zztasp3);
        zzMake0;
        {
        if ( (LA(1)==PROD) ) {
          zzmatch(PROD); zzCONSUME;
        }
        else {
          if ( (LA(1)==DIV) ) {
            zzmatch(DIV); zzCONSUME;
          }
          else {zzFAIL(1,zzerr3,&zzMissSet,&zzMissText,&zzBadTok,&zzBadText,&zzErrk); goto fail;}
        }
        zzEXIT(zztasp3);
        }
      }
      atom();
      zzLOOP(zztasp2);
    }
    zzEXIT(zztasp2);
    }
  }
  zzEXIT(zztasp1);
  return;
fail:
  zzEXIT(zztasp1);
  zzsyn(zzMissText, zzBadTok, (ANTLRChar *)"", zzMissSet, zzMissTok, zzErrk, zzBadText);
  zzresynch(setwd2, 0x1);
  }
}

void
#ifdef __USE_PROTOS
atom(void)
#else
atom()
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
    if ( (LA(1)==NUM) ) {
      zzmatch(NUM); zzCONSUME;
    }
    else {
      if ( (LA(1)==ID) ) {
        zzmatch(ID); zzCONSUME;
      }
      else {zzFAIL(1,zzerr4,&zzMissSet,&zzMissText,&zzBadTok,&zzBadText,&zzErrk); goto fail;}
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
