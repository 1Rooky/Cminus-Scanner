#define _GLOBALS_H_
#define FALSE 0
#define TRUE 1
#define MAXTOKENLEN 40


#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>


int lineno; 
extern int Error;
extern char tokenString[MAXTOKENLEN+1];


typedef enum
    /* book-keeping tokens */
   {ENDFILE,ERROR,
    /* reserved words */
    IF,ELSE,RETURN,VOID,WHILE,INT,
    /* multicharacter tokens */
    ID,NUM,LETTER,DIGIT,
    /* special symbols */
    ASSIGN,EQ,NE,LT,LE,GT,GE,PLUS,MINUS,TIMES,OVER,LPAREN,RPAREN,SEMI,COMMA, LBRACE, RBRACE,LCURLY,RCURLY
   } TokenType;


TokenType getToken(void);

void printToken( TokenType, const char* );
