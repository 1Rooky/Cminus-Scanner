
%{
#include "GLOBALS.H"
char tokenString[MAXTOKENLEN+1];
%}


%option noyywrap

digit       [0-9]
number      {digit}+
letter      [a-zA-Z]
identifier  {letter}+
newline     \n
whitespace  [ \t]+


%%

"if"            {return IF;}
"else"          {return ELSE;}
"int"           {return INT;}
"return"        {return RETURN;}
"void"          {return VOID;}
"while"         {return WHILE;}

"="            {return ASSIGN;}
"!="             {return NE;}
"=="             {return EQ;}
"<"             {return LT;}
"<="             {return LE;}
">"             {return GT;}
">="             {return GE;}
"+"             {return PLUS;}
"-"             {return MINUS;}
"*"             {return TIMES;}
"/"             {return OVER;}
"("             {return LPAREN;}
")"             {return RPAREN;}
";"             {return SEMI;}
","             {return COMMA;}
"["             {return LBRACE;}
"]"             {return RBRACE;}
"{"             {return LCURLY;}
"}"             {return RCURLY;}


{number}        {return NUM;}
{identifier}    {return ID;}
{newline}       {lineno++;}
{whitespace}    {         }    

"/*"		{
		char c;
		while(1){
			c=input();
			if(c==EOF) break;
			if(c=='*')
			{
				c=input();
				if(c=='/' || c==EOF) break;
			}
			if(c=='\n')
				lineno++;
			}
		}
.               {return ERROR;}

%%


TokenType getToken(void)

{ 
  static int firstTime = TRUE;
  TokenType currentToken;
  if (firstTime)
  { firstTime = FALSE;
    lineno++;
    yyout = fopen("tokens.txt", "w");
	

  }
  currentToken = yylex();
  strncpy(tokenString,yytext,MAXTOKENLEN);
  fprintf(yyout,"\t%d: ",lineno);
  printToken(currentToken,tokenString);
  return currentToken;
}
void printToken(TokenType token, const char* tokenString )
{ 
  switch (token)
  { 
    case IF:
    case RETURN:
    case ELSE:
    case VOID:
    case WHILE:
    case INT:    fprintf(yyout,    "reserved word: %s\n",tokenString);  break;
    case ASSIGN: fprintf(yyout,"=  ASSIGN\n"); break;
    case LT:     fprintf(yyout,"<  LT\n");     break;
    case LE:     fprintf(yyout,"<=  LE\n");    break;
    case GT:     fprintf(yyout,">  GT\n");     break;
    case GE:     fprintf(yyout,">=  GE\n");    break;
    case EQ:     fprintf(yyout,"==  EQ\n");    break;
    case NE:     fprintf(yyout,"!=  NE\n");    break;
    case LPAREN: fprintf(yyout,"(  LPAREN\n"); break;
    case RPAREN: fprintf(yyout,")  RPAREN\n"); break;
    case SEMI:   fprintf(yyout,";  SEMI\n");   break;
    case PLUS:   fprintf(yyout,"+  PLUS\n");   break;
    case MINUS:  fprintf(yyout,"-  MINUS\n");  break;
    case TIMES:  fprintf(yyout,"*  TIMES\n");  break;
    case OVER:   fprintf(yyout,"/  OVER\n");   break;
    case COMMA:  fprintf(yyout,",  COMMA\n");  break;
    case LBRACE: fprintf(yyout,"[  LBRACE\n"); break;
    case RBRACE: fprintf(yyout,"]  RBRACE\n"); break;
    case LCURLY: fprintf(yyout,"{  LCURLY\n"); break;
    case RCURLY: fprintf(yyout,"}  RCURLY\n"); break;
    case ENDFILE:fprintf(yyout,"EOF\n");       break;
    case NUM:    fprintf(yyout, "NUM, val= %s\n",tokenString);   break;
    case ID:     fprintf(yyout,  "ID, name= %s\n",tokenString);  break;
    case ERROR:  fprintf(yyout,   "ERROR: %s\n",tokenString);    break;
    default:     fprintf(yyout,"Unknown token: %d\n",token);
  }
}

int main()
{
	printf("Welcome to our Cminus scanner \n\n");
  char filename[50];
  printf("Please Enter The Source Code File Name : \n");
  scanf("%s",filename);
  source = fopen(filename,"r");
  yyin = source;
	while (getToken()){}
  printf("\nLexical Analysis is Done . . .\n");

	return 0;
}
