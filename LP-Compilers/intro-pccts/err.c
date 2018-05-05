/*
 * A n t l r  S e t s / E r r o r  F i l e  H e a d e r
 *
 * Generated from: example1.g
 *
 * Terence Parr, Russell Quong, Will Cohen, and Hank Dietz: 1989-2001
 * Parr Research Corporation
 * with Purdue University Electrical Engineering
 * With AHPCRC, University of Minnesota
 * ANTLR Version 1.33MR33
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
#include "err.h"

ANTLRChar *zztokens[19]={
	/* 00 */	"Invalid",
	/* 01 */	"@",
	/* 02 */	"NUM",
	/* 03 */	"PLUS",
	/* 04 */	"MINUS",
	/* 05 */	"PROD",
	/* 06 */	"DIV",
	/* 07 */	"ASIG",
	/* 08 */	"IF",
	/* 09 */	"THEN",
	/* 10 */	"ENDIF",
	/* 11 */	"EQUAL",
	/* 12 */	"ID",
	/* 13 */	"WRITE",
	/* 14 */	"SPACE",
	/* 15 */	"\\(",
	/* 16 */	"\\)",
	/* 17 */	"\\{",
	/* 18 */	"\\}"
};
SetWordType zzerr1[4] = {0x0,0x31,0x0,0x0};
SetWordType zzerr2[4] = {0x18,0x0,0x0,0x0};
SetWordType zzerr3[4] = {0x60,0x0,0x0,0x0};
SetWordType setwd1[19] = {0x0,0x4d,0x0,0x20,0x20,0x80,0x80,
	0x0,0x4a,0x0,0x0,0x40,0x4a,0x4a,0x0,
	0x0,0x50,0x0,0x4c};
SetWordType zzerr4[4] = {0x4,0x10,0x0,0x0};
SetWordType setwd2[19] = {0x0,0x3,0x0,0x3,0x3,0x2,0x2,
	0x0,0x3,0x0,0x0,0x3,0x3,0x3,0x0,
	0x0,0x3,0x0,0x3};
