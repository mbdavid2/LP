#ifndef tokens_h
#define tokens_h
/* tokens.h -- List of labelled tokens and stuff
 *
 * Generated from: example1.g
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
#define DIV 6
#define ASIG 7
#define IF 8
#define THEN 9
#define ENDIF 10
#define EQUAL 11
#define ID 12
#define WRITE 13
#define SPACE 14

#ifdef __USE_PROTOS
void program(void);
#else
extern void program();
#endif

#ifdef __USE_PROTOS
void linst(void);
#else
extern void linst();
#endif

#ifdef __USE_PROTOS
void instruction(void);
#else
extern void instruction();
#endif

#ifdef __USE_PROTOS
void exprB(void);
#else
extern void exprB();
#endif

#ifdef __USE_PROTOS
void expr(void);
#else
extern void expr();
#endif

#ifdef __USE_PROTOS
void term(void);
#else
extern void term();
#endif

#ifdef __USE_PROTOS
void atom(void);
#else
extern void atom();
#endif

#endif
extern SetWordType zzerr1[];
extern SetWordType zzerr2[];
extern SetWordType zzerr3[];
extern SetWordType setwd1[];
extern SetWordType zzerr4[];
extern SetWordType setwd2[];
