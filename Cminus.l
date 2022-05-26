
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
	  tokens = yyout;

  }
  currentToken = yylex();
  strncpy(tokenString,yytext,MAXTOKENLEN);
  fprintf(tokens,"\t%d: ",lineno);
  printToken(currentToken,tokenString);

  return currentToken;
}
void printToken( TokenType token, const char* tokenString )
{ 
  switch (token)
  { 
    case IF:
    case RETURN:
    case ELSE:
    case VOID:
    case WHILE:
    case INT:    fprintf(tokens,    "reserved word: %s\n",tokenString);  break;
    case ASSIGN: fprintf(tokens,"=  ASSIGN\n"); break;
    case LT:     fprintf(tokens,"<  LT\n");     break;
    case LE:     fprintf(tokens,"<=  LE\n");    break;
    case GT:     fprintf(tokens,">  GT\n");     break;
    case GE:     fprintf(tokens,">=  GE\n");    break;
    case EQ:     fprintf(tokens,"==  EQ\n");    break;
    case NE:     fprintf(tokens,"!=  NE\n");    break;
    case LPAREN: fprintf(tokens,"(  LPAREN\n"); break;
    case RPAREN: fprintf(tokens,")  RPAREN\n"); break;
    case SEMI:   fprintf(tokens,";  SEMI\n");   break;
    case PLUS:   fprintf(tokens,"+  PLUS\n");   break;
    case MINUS:  fprintf(tokens,"-  MINUS\n");  break;
    case TIMES:  fprintf(tokens,"*  TIMES\n");  break;
    case OVER:   fprintf(tokens,"/  OVER\n");   break;
    case COMMA:  fprintf(tokens,",  COMMA\n");  break;
    case LBRACE: fprintf(tokens,"[  LBRACE\n"); break;
    case RBRACE: fprintf(tokens,"]  RBRACE\n"); break;
    case LCURLY: fprintf(tokens,"{  LCURLY\n"); break;
    case RCURLY: fprintf(tokens,"}  RCURLY\n"); break;
    case ENDFILE:fprintf(tokens,"EOF\n");       break;
    case NUM:    fprintf(tokens, "NUM, val= %s\n",tokenString);   break;
    case ID:     fprintf(tokens,  "ID, name= %s\n",tokenString);  break;
    case ERROR:  fprintf(tokens,   "ERROR: %s\n",tokenString);    break;
    default:     fprintf(tokens,"Unknown token: %d\n",token);
  }
}


static void printSpaces(void)
{ 
  int i;
  for (i=0;i<indentno;i++)
    fprintf(tokens," ");
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
