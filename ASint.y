
%{
#include <iostream>
#include <stdio.h>
#include <SDL2/SDL.h>
#include <string>
#include <stdlib.h>
extern int yylex();
extern int yyparse();
extern FILE* yyin;
void yyerror(const char* s);

using namespace std;

char colores[5][10] = {"rojo","azul","verde","blanco","amarillo"};
int color_index;
int filled = 0;
SDL_Rect rectangle;
SDL_Window* window = SDL_CreateWindow("C++ SDL2 Window",20, 20, 640,480,SDL_WINDOW_SHOWN);
SDL_Renderer* renderer = SDL_CreateRenderer(window,-1,SDL_RENDERER_ACCELERATED);

%}
%union{
	int num;
	char* name;
	int boolean;
	char* color;
	int punto[2];
	
}

%token DIBUJAR FIN COLOR RELLENO LINEA REDONDO CUADRO TRIANGULO L_PARENTESIS R_PARENTESIS COMA IGUAL VAR
%token <color> COL
%token <boolean> B
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
 COLOR L_PARENTESIS COL R_PARENTESIS 		{SDL_SetRenderDrawColor(renderer,255,255,255,SDL_ALPHA_OPAQUE);}
| RELLENO	L_PARENTESIS B R_PARENTESIS	{filled = $3;}
| CUADRO	L_PARENTESIS PUNTO COMA PUNTO R_PARENTESIS	{
																					rectangle.x=$3[0];
																					rectangle.y=$3[1];
																					rectangle.w=$5[0]-$3[0];
																					rectangle.h=$5[1]-$3[1];
																					if(filled){SDL_RenderFillRect(renderer,&rectangle);}
																					else{SDL_RenderDrawRect(renderer,&rectangle);}
																					SDL_RenderPresent(renderer);
}
| TRIANGULO	L_PARENTESIS PUNTO COMA PUNTO COMA PUNTO R_PARENTESIS	{
																		SDL_RenderDrawLine(renderer,$3[0],$3[1],$5[0],$5[1]);
																		SDL_RenderDrawLine(renderer,$5[0],$5[1],$7[0],$7[1]);
																		SDL_RenderDrawLine(renderer,$3[0],$3[1],$7[0],$7[1]);
																		if(filled){printf("WIP\n");}
																		SDL_RenderPresent(renderer);}
| REDONDO	L_PARENTESIS PUNTO NUM 
| LINEA 	L_PARENTESIS PUNTO COMA PUNTO R_PARENTESIS	{ SDL_RenderDrawLine(renderer,$3[0],$3[1],$5[0],$5[1]);SDL_RenderPresent(renderer);}
| PUNTO 
| L_PARENTESIS {SDL_SetRenderDrawColor(renderer,0,0,0,SDL_ALPHA_OPAQUE);;SDL_RenderPresent(renderer); SDL_SetRenderDrawColor(renderer,255,255,255,SDL_ALPHA_OPAQUE);
        SDL_RenderDrawLine(renderer,5,5,100,120);SDL_RenderPresent(renderer);}
;

PUNTO:NUM COMA NUM	{ $$[0]= $1;$$[1]=$3; }
| VAR COMA NUM
| VAR COMA VAR
| NUM COMA VAR
;
%%

int main() {
	yyin = stdin;
	SDL_RenderPresent(renderer);
	SDL_SetRenderDrawColor(renderer,255,255,255,SDL_ALPHA_OPAQUE);
	//
	do {
		yyparse();

	} while(!feof(yyin));
	
	return 0;
}

void yyerror(const char* s) {
	fprintf(stderr, "Parse error: %s\n", s);
	exit(1);
}


