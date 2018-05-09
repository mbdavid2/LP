#ifndef tokens_h
#define tokens_h
/* tokens.h -- List of labelled tokens and stuff
 *
 * Generated from: practica.g
 *
 * Terence Parr, Will Cohen, and Hank Dietz: 1989-2001
 * Purdue University Electrical Engineering
 * ANTLR Version 1.33MR33
 */
#define zzEOF_TOKEN 1
#define NUM 2
#define PLUS 3
#define MINUS 4
#define PROD 5
#define CONCAT 6
#define ASIG 7
#define FLATTEN 8
#define POP 9
#define PRINT 10
#define HEAD 11
#define LREDUCE 12
#define LMAP 13
#define LFILTER 14
#define EMPTYLIST 15
#define EQ 16
#define DIF 17
#define GT 18
#define LT 19
#define EMPTY 20
#define AND 21
#define OR 22
#define NOT 23
#define IF 24
#define THEN 25
#define ENDIF 26
#define WHILE 27
#define DO 28
#define ENDWHILE 29
#define LID 30
#define SPACE 31

#ifdef __USE_PROTOS
void lists(AST**_root);
#else
extern void lists();
#endif

#ifdef __USE_PROTOS
void list_oper(AST**_root);
#else
extern void list_oper();
#endif

#ifdef __USE_PROTOS
void elem(AST**_root);
#else
extern void elem();
#endif

#ifdef __USE_PROTOS
void exprB(AST**_root);
#else
extern void exprB();
#endif

#ifdef __USE_PROTOS
void exprBor(AST**_root);
#else
extern void exprBor();
#endif

#ifdef __USE_PROTOS
void exprBnot(AST**_root);
#else
extern void exprBnot();
#endif

#ifdef __USE_PROTOS
void exprBatom(AST**_root);
#else
extern void exprBatom();
#endif

#ifdef __USE_PROTOS
void expr(AST**_root);
#else
extern void expr();
#endif

#ifdef __USE_PROTOS
void func(AST**_root);
#else
extern void func();
#endif

#ifdef __USE_PROTOS
void innerFunc(AST**_root);
#else
extern void innerFunc();
#endif

#ifdef __USE_PROTOS
void listDef(AST**_root);
#else
extern void listDef();
#endif

#ifdef __USE_PROTOS
void atomList(AST**_root);
#else
extern void atomList();
#endif

#endif
extern SetWordType zzerr1[];
extern SetWordType zzerr2[];
extern SetWordType zzerr3[];
extern SetWordType zzerr4[];
extern SetWordType zzerr5[];
extern SetWordType setwd1[];
extern SetWordType zzerr6[];
extern SetWordType zzerr7[];
extern SetWordType zzerr8[];
extern SetWordType zzerr9[];
extern SetWordType zzerr10[];
extern SetWordType setwd2[];
