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
#define EQUAL 16
#define DIF 17
#define GT 18
#define LT 19
#define EMPTY 20
#define NOT 21
#define IF 22
#define THEN 23
#define ENDIF 24
#define WHILE 25
#define DO 26
#define ENDWHILE 27
#define LID 28
#define SPACE 29
#define EQ 32

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
void id(AST**_root);
#else
extern void id();
#endif

#ifdef __USE_PROTOS
void func(AST**_root);
#else
extern void func();
#endif

#ifdef __USE_PROTOS
void exprB(AST**_root);
#else
extern void exprB();
#endif

#ifdef __USE_PROTOS
void expr(AST**_root);
#else
extern void expr();
#endif

#ifdef __USE_PROTOS
void funcTwoPar(AST**_root);
#else
extern void funcTwoPar();
#endif

#ifdef __USE_PROTOS
void list(AST**_root);
#else
extern void list();
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
extern SetWordType zzerr6[];
extern SetWordType zzerr7[];
extern SetWordType setwd1[];
extern SetWordType zzerr8[];
extern SetWordType zzerr9[];
extern SetWordType setwd2[];
