
%{
#include <iostream>
#include <cmath>
#include <math.h>
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
int SDL_RenderDrawCircle(SDL_Renderer * renderer, int x, int y, int radius);
int SDL_RenderFillCircle(SDL_Renderer * renderer, int x, int y, int radius);
int SDL_RenderFillTriangle (SDL_Renderer* renderer, int x1, int y1,int x2, int y2,int x3, int y3);

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
																		
																		if(filled){SDL_RenderFillTriangle (renderer,$3[0],$3[1],$5[0],$5[1],$7[0],$7[1]);}
																		else{SDL_RenderDrawLine(renderer,$3[0],$3[1],$5[0],$5[1]);
																		SDL_RenderDrawLine(renderer,$5[0],$5[1],$7[0],$7[1]);
																		SDL_RenderDrawLine(renderer,$3[0],$3[1],$7[0],$7[1]);}
																		SDL_RenderPresent(renderer);}
| REDONDO	L_PARENTESIS PUNTO COMA NUM R_PARENTESIS{
													if(filled){
													SDL_RenderFillCircle(renderer,$3[0],$3[1],$5);
													}
													else{
													SDL_RenderDrawCircle(renderer,$3[0],$3[1],$5);}
													SDL_RenderPresent(renderer);
}
| LINEA 	L_PARENTESIS PUNTO COMA PUNTO R_PARENTESIS	{ SDL_RenderDrawLine(renderer,$3[0],$3[1],$5[0],$5[1]);SDL_RenderPresent(renderer);}
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
	exit(1);}
	
int SDL_RenderDrawCircle(SDL_Renderer * renderer, int x, int y, int radius){
    int offsetx, offsety, d;
    int status;


    offsetx = 0;
    offsety = radius;
    d = radius -1;
    status = 0;

    while (offsety >= offsetx) {
        status += SDL_RenderDrawPoint(renderer, x + offsetx, y + offsety);
        status += SDL_RenderDrawPoint(renderer, x + offsety, y + offsetx);
        status += SDL_RenderDrawPoint(renderer, x - offsetx, y + offsety);
        status += SDL_RenderDrawPoint(renderer, x - offsety, y + offsetx);
        status += SDL_RenderDrawPoint(renderer, x + offsetx, y - offsety);
        status += SDL_RenderDrawPoint(renderer, x + offsety, y - offsetx);
        status += SDL_RenderDrawPoint(renderer, x - offsetx, y - offsety);
        status += SDL_RenderDrawPoint(renderer, x - offsety, y - offsetx);

        if (status < 0) {
            status = -1;
            break;
        }

        if (d >= 2*offsetx) {
            d -= 2*offsetx + 1;
            offsetx +=1;
        }
        else if (d < 2 * (radius - offsety)) {
            d += 2 * offsety - 1;
            offsety -= 1;
        }
        else {
            d += 2 * (offsety - offsetx - 1);
            offsety -= 1;
            offsetx += 1;
        }
    }

    return status;
}


int
SDL_RenderFillCircle(SDL_Renderer * renderer, int x, int y, int radius)
{
    int offsetx, offsety, d;
    int status;

    offsetx = 0;
    offsety = radius;
    d = radius -1;
    status = 0;

    while (offsety >= offsetx) {

        status += SDL_RenderDrawLine(renderer, x - offsety, y + offsetx,
                                     x + offsety, y + offsetx);
        status += SDL_RenderDrawLine(renderer, x - offsetx, y + offsety,
                                     x + offsetx, y + offsety);
        status += SDL_RenderDrawLine(renderer, x - offsetx, y - offsety,
                                     x + offsetx, y - offsety);
        status += SDL_RenderDrawLine(renderer, x - offsety, y - offsetx,
                                     x + offsety, y - offsetx);

        if (status < 0) {
            status = -1;
            break;
        }

        if (d >= 2*offsetx) {
            d -= 2*offsetx + 1;
            offsetx +=1;
        }
        else if (d < 2 * (radius - offsety)) {
            d += 2 * offsety - 1;
            offsety -= 1;
        }
        else {
            d += 2 * (offsety - offsetx - 1);
            offsety -= 1;
            offsetx += 1;
        }
    }

    return status;
}

int SDL_RenderFillTriangle (SDL_Renderer* renderer, int x1, int y1,int x2, int y2,int x3, int y3){
	float offsetx1=0,offsetx2=0,offsety1=0,offsety2 = 0;
	float offsetx1t,offsetx2t,offsety1t,offsety2t;
	float dx1 =sqrt(pow(x3-x1,2)+pow(y3-y1,2)) , dx2 =sqrt(pow(x3-x2,2)+pow(y3-y2,2));
	
	offsetx1t = (x3-x1)/dx1;
	offsetx2t = (x3-x2)/dx2;
	offsety1t = (y3-y1)/dx1;
	offsety2t = (y3-y2)/dx2;
	SDL_RenderDrawLine(renderer,x1,y1,x2,y2);
	SDL_RenderDrawLine(renderer,x1,y1,x3,y3);
	SDL_RenderDrawLine(renderer,x3,y3,x2,y2);
	int i=0;
	
	while ( sqrt(pow(x2+offsetx2-x3,2) +(y2+offsety2-y3,2) ) >1.5){
		SDL_RenderDrawLineF(renderer, (x1+offsetx1),(y1+offsety1),(x2+offsetx2), y2+offsety2);
		offsetx1 += offsetx1t;
		offsetx2 +=	offsetx2t;
		offsety1 += offsety1t;
		offsety2 += offsety2t;
		SDL_RenderPresent(renderer);
		i++;
	}
	
return 0;}
	




