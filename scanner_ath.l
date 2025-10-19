/* Seção de Definições em C */
%{
#include <stdio.h>
#include <string.h>

/* Adriano Maia - Para integração com o Bison/Yacc, os tokens seriam definidos 
   em um arquivo de cabeçalho compartilhado (ex y.tab.h). 
   Por enquanto, definimos aqui. */

typedef enum {
    T_ATH        = 258,
    T_EXECUTE    = 259,
    T_THIS       = 260,
    T_SELF       = 261,
    T_NULL       = 262,
    T_IMPORT     = 263,
    T_LEND       = 264,
    T_INPUT      = 265,
    T_RETURN     = 266,

    // KW = KEYWORD
    T_KW_ENTITY  = 267,
    T_KW_INT     = 268,
    T_KW_FLOAT   = 269,
    T_KW_CHAR    = 270,
    T_KW_STRING  = 271,
    T_KW_ARRAY   = 272,
    T_KW_BOOLEAN = 273,

    // OP = OPERATOR
    T_OP_ADD     = 274,
    T_OP_SUB     = 275,
    T_OP_MUL     = 276,
    T_OP_DIV     = 277,
    T_OP_ATRIB   = 278,
    T_OP_SUMATB  = 279,
    T_OP_SUBATB  = 280,
    T_OP_MULATB  = 281,
    T_OP_DIVATB  = 281, 
    T_OP_ISEQU   = 282,
    T_OP_NOTEQ   = 283,
    T_OP_GREATER = 284,
    T_OP_LESSER  = 285,
    T_OP_GRTEQU  = 286,
    T_OP_LSSEQU  = 287,
    T_OP_INC     = 288,
    T_OP_DEC     = 289,
    T_OP_AND     = 290,
    T_OP_OR      = 291,
    T_OP_NOT     = 292,
    T_OP_XOR     = 293,
    T_OP_ACCESS  = 294,

    // Separators
    T_SP_SMCOLON = 295,
    T_SP_COLON   = 296,
    T_SP_COMMA   = 297,
    T_SP_PARENTESESLFT = 299,
    T_SP_PARENTESESRGT = 300,
    T_SP_BRACKETSLFT   = 301,
    T_SP_BRACKETSRGT   = 302,
    T_SP_BRACESLFT     = 303,
    T_SP_BRACESRGT     = 304,

    T_ID = 305,
    
    // Literais
    T_INTEGER    = 306,
    T_FLOAT      = 307,
    T_CHAR       = 308,
    T_STRING     = 309,
    
    T_EOF        = 310,
    T_UNKNOWN    = 311
} TokenType;

/* yylval é a variável global usada pelo Flex e Bison para trocar 
   valores. Em um compilador real, isso seria uma 'union' para 
   suportar diferentes tipos de dados (inteiros, strings, etc.). */

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
FLOAT             {DIGITO}+\.{DIGITO}*
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
[iI][nN][tT]                   { return T_KW_INT; }
[fF][lL][Oo][aA][tT]           { return T_KW_FLOAT; }

{INTEIRO}      { yylval = atoi(yytext); return T_INTEGER; }
{FLOAT}        { return T_FLOAT; }
{CHAR_LITERAL} { return T_CHAR; }
{STRING_ABERTA}  { printf("\nErro Léxico na linha %d String não terminada %s\n", line_count, yytext); line_count++; return T_UNKNOWN; }
{STRING_LITERAL} { return T_STRING; }

{ID_INVALIDO}  { printf("\nErro Léxico na linha %d Identificador inválido: %s\n", line_count, yytext); line_count++; return T_UNKNOWN; }
{ID}           { yylval = get_symbol_position(yytext); return T_ID; }

"=="           { return T_OP_ISEQU; }
"!="           { return T_OP_NOTEQ; }
"<"            { return T_OP_LESSER; }
"> "            { return T_OP_GREATER; }
"<="           { return T_OP_GRTEQU; }
">="           { return T_OP_LSSEQU; }

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

// Função main para testar o scanner de forma independente
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
            printf("<LFLOAT, %s>", yytext);
            break;
          case T_CHAR:
            printf("<LCHAR, %s>", yytext);
            break;
          case T_STRING:
            printf("<LSTRING, %s>", yytext);
            break;
          case T_ID:
            printf("<ID, %d>", get_symbol_position(yytext));
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
