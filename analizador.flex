%option noyywrap
%{
#include <stdio.h>

#define YY_DECL int yylex()

#include "ASint.tab.h"
%}

%%
"ROJO"|"AZUL"|"AMARILLO"|"VERDE"|"BLANCO"  {yylval.color = yytext; return COL;}
"dibujar"|"Dibujar"|"DIBUJAR"	{return DIBUJAR;}
"si"|"SI"|"Si"	{yylval.boolean = 1;return B;}
"no"|"NO"|"No"	{yylval.boolean = 0;return B;}
"cuadro"|"Cuadro"|"CUADRO"	{return CUADRO;}
"relleno"|"Relleno"|"RELLENO"	{return RELLENO;}
"linea"|"Linea"|"LINEA"		printf("Palabra reservada: Linea\n");
"color"|"Color"|"COLOR" {return COLOR;}
"redondo"|"Redondo"|"REDONDO"	{return REDONDO;}
"asignar"|"Asignar"|"ASIGNAR"	printf("Palabra reservada: Asignar\n");
"fin"|"Fin"|"FIN"	{return FIN;}
[A-Z]([A-Za-z]+[0-9]|[0-9]*) printf("Identificador: %s\n",yytext);
[-]?[0-9]+ {yylval.num = atoi(yytext); return NUM;}
"("	{return L_PARENTESIS;}
")"	{return R_PARENTESIS;}
","	{return COMA;}
"=" {return IGUAL;}
" " ;



%%

