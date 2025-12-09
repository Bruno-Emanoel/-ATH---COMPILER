/* Seção de Definições em C */
%{
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "parser_ath.tab.c"  

int yylval;

/* Tabela de Símbolos (baseada em table.l) */
#define MAX_SYMBOLS 100
char *symbol_table[MAX_SYMBOLS];
int symbol_count = 0;

// Contador de linhas
int line_count = 1;

// Função para obter a posição de um identificador na tabela de símbolos
int get_symbol_position(const char *id) {
    for (int i = 0; i < symbol_count; i++) {
        if (strcmp(symbol_table[i], id) == 0) {
            return i;
        }
    }
    // Adiciona o novo identificador se não for encontrado e retorna a nova posição
    symbol_table[symbol_count] = strdup(id);
    return symbol_count++;
}
%}

/* Opções do Flex */
%option noyywrap

/* Definições de Expressões Regulares (apelidos) */
DIGITO            [0-9]
LETRA             [a-zA-Z_]
ID                [a-zA-Z~]({LETRA}|{DIGITO}|~)*
ID_INVALIDO       ({DIGITO}|"_")({LETRA}|{DIGITO}|~)*
INTEIRO           {DIGITO}+
FLOAT_PADRAO      (({DIGITO}*"."{DIGITO}+)|({DIGITO}+"."{DIGITO}*))
FLOAT_CIENTIFICA  ((({DIGITO}+)|({FLOAT_PADRAO}))[eE][+-]?{DIGITO}+)
FLOAT             {FLOAT_CIENTIFICA}|({FLOAT_PADRAO})[fF]?
COMENTARIO_LINHA  \/\/[^\n]*
COMENTARIO_BLOCO  \/\*([^*]|\*+[^*/])*\*+\/
CHAR_LITERAL      \'\\?[^']\'
STRING_ABERTA     \"[^"\n]*\n
STRING_LITERAL    \"[^"\n]*\"

/* Seção de Regras */
%%
[\0 \r\t]+         { /* Ignorar espaços em branco e tabulações */ }
\n             { line_count++; }
{COMENTARIO_LINHA} { /* Ignora comentário de linha */ }
{COMENTARIO_BLOCO} { /* Ignora comentário de bloco */ }

[rR][eE][tT][uU][rR][nN]       { return T_RETURN; }
[nN][uU][lL][lL]               { return T_NULL; }
~[Aa][Tt][Hh]                  { return T_ATH; }
[eE][xX][eE][cC][uU][tT][eE]   { return T_EXECUTE; }
[tT][hH][iI][sS]               { return T_THIS; }
[Ss][Ee][Ll][fF]               { return T_SELF; }
[iI][mM][pP][oO][rR][tT]       { return T_IMPORT; };
[iI][nN][pP][uU][tT]           { return T_INPUT; };
[Ll][eE][nN][dD]               { return T_LEND; }

[cC][hH][aA][rR]               { return T_KW_CHAR; }
[eE][nN][tT][iI][tT][yY]       { return T_KW_ENTITY; }
[aA][rR][rR][aA][yY]           { return T_KW_ARRAY; }
[iI][nN][tT]                   { return T_KW_INT; }
[fF][lL][Oo][aA][tT]           { return T_KW_FLOAT; }

{FLOAT}        { yylval = atof(yytext); return T_FLOAT; }
{INTEIRO}      { yylval = atoi(yytext); return T_INTEGER; }
{CHAR_LITERAL} { return T_CHAR; }
{STRING_ABERTA}  { printf("\nErro Léxico na linha %d String não terminada %s\n", line_count, yytext); line_count++; return T_UNKNOWN; }
{STRING_LITERAL} { return T_STRING; }

{ID_INVALIDO}  { printf("\nErro Léxico na linha %d Identificador inválido: %s\n", line_count, yytext); line_count++; return T_UNKNOWN; }
{ID}           { yylval = get_symbol_position(yytext); return T_ID; }

"=="           { return T_OP_ISEQU; }
"!="           { return T_OP_NOTEQ; }
"<"            { return T_OP_LESSER; }
">"            { return T_OP_GREATER; }
"<="           { return T_OP_LSSEQU; }
">="           { return T_OP_GRTEQU; }

"++"           { return T_OP_INC; }
"--"           { return T_OP_DEC; }

"="            { return T_OP_ATRIB; }
"+="           { return T_OP_SUMATB; }
"-="           { return T_OP_SUBATB; }
"*="           { return T_OP_MULATB; }
"/="           { return T_OP_DIVATB; }
"+"            { return T_OP_ADD; }
"-"            { return T_OP_SUB; }
"*"            { return T_OP_MUL; }
"/"            { return T_OP_DIV; }

"&&"           { return T_OP_AND; }
"||"           { return T_OP_OR; }
"^^"           { return T_OP_XOR; }
"!"            { return T_OP_NOT; }
"->"           { return T_OP_ACCESS; }

";"            { return T_SP_SMCOLON; }
","            { return T_SP_COMMA; }
"("            { return T_SP_PARENTESESLFT; }
")"            { return T_SP_PARENTESESRGT; }
"{"            { return T_SP_BRACKETSLFT; }
"}"            { return T_SP_BRACKETSRGT; }
"["            { return T_SP_BRACESLFT; }
"]"            { return T_SP_BRACESRGT; }
":"            { return T_SP_COLON; }

.              { printf("Erro Léxico na linha %d: Caractere inesperado '%s'\n", line_count, yytext); return T_UNKNOWN; }

%%
/* Seção de Código do Usuário */

int yywrap() {
  return 1;
}

// Função main para testar o scanner de forma independente
/*
int main(int argc, char **argv) {
    if (argc > 1) {
        FILE *file = fopen(argv[1], "r");
        if (file) {
            yyin = file;
        }
    }

    int token_id;
    while ((token_id = yylex())) {
        switch ( token_id ) {
          case T_ATH:
            printf("<~ATH>");
            break;
          case T_EXECUTE:
            printf("<EXECUTE>");
            break;
          case T_THIS:
            printf("<THIS>");
            break;
          case T_SELF:
            printf("<SELF>");
            break;
          case T_NULL:
            printf("<NULL>");
            break;
          case T_IMPORT:
            printf("<IMPORT>");
            break;
          case T_LEND:
            printf("<LEND>");
            break;
          case T_INPUT:
            printf("<INPUT>");
            break;
          case T_RETURN:
            printf("<RETURN>");
            break;
          case T_KW_ENTITY:
            printf("<ENTITY>");
            break;
          case T_KW_CHAR:
            printf("<CHAR>");
            break;
          case T_KW_INT:
            printf("<INT>");
            break;
          case T_KW_FLOAT:
            printf("<FLOAT>");
            break;
          case T_KW_STRING:
            printf("<STRING>");
            break;
          case T_KW_ARRAY:
            printf("<ARRAY>");
            break;
          case T_OP_ADD:
            printf("<SUM>");
            break;
          case T_OP_SUB:
            printf("<SUB>");
            break;
          case T_OP_MUL:
            printf("<MUL>");
            break;
          case T_OP_DIV:
            printf("<DIV>");
            break;
          case T_OP_ATRIB:
            printf("<ATRIB>");
            break;
          case T_OP_ISEQU:
            printf("<ISEQU>");
            break;
          case T_OP_NOTEQ:
            printf("<ISDIF>");
            break;
          case T_OP_GREATER:
            printf("<GT>");
            break;
          case T_OP_LESSER:
            printf("<LT>");
            break;
          case T_OP_GRTEQU:
            printf("<GTE>");
            break;
          case T_OP_LSSEQU:
            printf("<LTE>");
            break;
          case T_OP_INC:
            printf("<INC>");
            break;
          case T_OP_DEC:
            printf("<DEC>");
            break;
          case T_OP_AND:
            printf("<AND>");
            break;
          case T_OP_OR:
            printf("<OR>");
            break;
          case T_OP_NOT:
            printf("<NOT>");
            break;
          case T_OP_XOR:
            printf("<XOR>");
            break;
          case T_OP_ACCESS:
            printf("<ACCESS>");
            break;
          case T_SP_SMCOLON:
            printf("<SCOLLON>");
            break;
          case T_SP_COLON:
            printf("<COLLON>");
            break;
          case T_SP_COMMA:
            printf("<COMMA>");
            break;
          case T_SP_PARENTESESLFT:
            printf("<PTOPEN>");
            break;
          case T_SP_PARENTESESRGT:
            printf("<PTCLOSE>");
            break;
          case T_SP_BRACKETSLFT:
            printf("<SBOPEN>");
            break;
          case T_SP_BRACKETSRGT:
            printf("<SBCLOSE>");
            break;
          case T_SP_BRACESLFT:
            printf("<BTOPEN>");
            break;
          case T_SP_BRACESRGT:
            printf("<BTCLOSE>");
            break;
          case T_INTEGER:
            printf("<INT, %d>", yylval);
            break;
          case T_FLOAT:
            printf("<LFLOAT, %f>", (float)yylval);
            break;
          case T_CHAR:
            printf("<LCHAR, %s>", yytext);
            break;
          case T_STRING:
            printf("<LSTRING, %s>", yytext);
            break;
          case T_ID:
            printf("<ID, %d>", yylval);
            break;
        }
        printf(" ");
    }

    // Adicione este trecho para imprimir a tabela de símbolos
    printf("\n\n--- Tabela de Símbolos Final ---\n");
    printf("Posição | Identificador\n");
    printf("-----------------------------\n");
    for (int i = 0; i < symbol_count; i++) {
        printf("%-7d | %s\n", i, symbol_table[i]);
    }
    printf("-----------------------------\n\n");


    // Libera a memória alocada para a tabela de símbolos
    for (int i = 0; i < symbol_count; i++) {
        free(symbol_table[i]);
    }

    return 0;

}
*/