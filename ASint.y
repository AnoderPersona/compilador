
%{
#include <stdio.h>
#include <string>
#include <stdlib.h>
extern int yylex();
extern int yyparse();
extern FILE* yyin;
void yyerror(const char* s);

char colores[5][10] = {"rojo","azul","verde","blanco","amarillo"};
int color_index;
%}
%union{
	double num;
	char* name;
	int boolean;
	char* color;
	int punto[2];
	
}

%token DIBUJAR FIN COLOR RELLENO LINEA REDONDO CUADRO TRIANGULO L_PARENTESIS R_PARENTESIS COMA IGUAL VAR
%token <color> COL
%token <bool> B
%token <num> NUM
%type <punto> PUNTO 
%type <name> VAR
 
%%
prog:DIBUJAR INSTRUCCIONES FIN	{exit(1);}

	;
	
INSTRUCCIONES:
| INSTRUCCION INSTRUCCIONES
;

INSTRUCCION:
 COLOR L_PARENTESIS COL R_PARENTESIS 		
| RELLENO	L_PARENTESIS B R_PARENTESIS
| CUADRO	L_PARENTESIS PUNTO COMA PUNTO COMA PUNTO COMA PUNTO R_PARENTESIS
| TRIANGULO	L_PARENTESIS PUNTO COMA PUNTO COMA PUNTO R_PARENTESIS
| REDONDO	L_PARENTESIS PUNTO NUM 
| LINEA 	L_PARENTESIS PUNTO COMA PUNTO R_PARENTESIS
| PUNTO 
;

PUNTO:NUM COMA NUM	{ $$[0]= $1;$$[1]=$3;printf(" %d ",$$[0]); }
| VAR COMA NUM
| VAR COMA VAR
| NUM COMA VAR
;
%%

int main() {
	yyin = stdin;
	do {
		yyparse();
	} while(!feof(yyin));
	
	return 0;
}

void yyerror(const char* s) {
	fprintf(stderr, "Parse error: %s\n", s);
	exit(1);
}


