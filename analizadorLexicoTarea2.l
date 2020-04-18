%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

void errorEncontrado(char *s);
%}

%option yylineno
%option noyywrap
%s COMENTARIOS

letras [a-zA-Z]
digitos [0-9]
id "#"({letras}|{digitos})+
Preservadas "@"(if|else|while)
opAritmeticos "/"|"+"|"-"|"*"|"%"
opRelacionales (">"|"<")("=")?|"=="|"!="
opAsignacion "="
opPipe "||"
opLogicos "&&"|{opPipe}|not
signoPuntuacion "{"|"}"|"("|")"|","|";"
entero ({digitos})+
reales {digitos}*"."{digitos}+|{digitos}+"."{digitos}*
exp [eE][+-]?{entero}
flotante ({reales}{exp}?|{entero}{exp})[Ff]

%%
{id}    {printf("Identificador: %s\n", yytext);}
{Preservadas}    {printf("Palabra Reservada: %s\n", yytext);} 
{opAritmeticos}     {printf("Operador Aritmetico: %s\n", yytext);}
{opRelacionales}     {printf("Operador Relacional: %s\n", yytext);}
{opAsignacion}     {printf("Operador de Asignacion: %s\n", yytext);}
{opLogicos}     {printf("Operador logico: %s\n", yytext);}
{signoPuntuacion}     {printf("Simbolo de Puntuacion: %s\n", yytext);}
{entero}    {printf("Entero: %s\n", yytext);}
{flotante}  {printf("Flotante: %s\n", yytext);}
<INITIAL>[ \t\n\r] {/* Se ignora los espacios en blanco*/}
<INITIAL>"/*" { BEGIN(COMENTARIOS);}
<COMENTARIOS>"*/" { printf("\n");
					BEGIN(INITIAL);}
<INITIAL>.  {errorEncontrado(yytext);}
%%

void errorEncontrado(char *s){
    printf("Error léxico: %s\n",s);
}

int main(int argc, char **argv){
    FILE *f;
    if(argc<2){
        printf("No se ingreso el nombre del archivo\n");
        exit(-1);
    }
    f = fopen(argv[1],"r");
    if(!f){
        printf("Error al abrir el archivo\n");
        exit(-1);
    }
    yyin = f;
    yylex();
    return 0;
}