/* Seção de Definições em C */
%{
#include <stdio.h>
#include <string.h>

/* Adriano Maia - Para integração com o Bison/Yacc, os tokens seriam definidos 
   em um arquivo de cabeçalho compartilhado (ex: y.tab.h). 
   Por enquanto, definimos aqui. */

typedef enum {
    T_ATH 	  = 258,
    T_EXECUTE = 259,
    T_THIS  	= 260,
    T_SELF   	= 261,
    T_NULL  	= 262,
    T_IMPORT  = 263,
    T_LEND    = 264,
    T_INPUT   = 265,

    T_KW_ENTITY = 266,	//KW = KEYWORD
    T_KW_INT 	  = 267,
    T_KW_FLOAT 	= 268,
    T_KW_CHAR   = 269,
    T_KW_STRING = 270,
    
    T_OP_ADD	= 267,	//OP = OPERATOR
    T_OP_SUB	= 268,
    T_OP_MUL	= 269,
    T_OP_DIV	= 270,
    T_OP_ATRIB	= 271,
    T_OP_ISEQU	= 272,
    T_OP_NOTEQ	= 273,
    T_OP_GREATER= 274,
    T_OP_LESSER	= 275,
    T_OP_GRTEQU = 276,
    T_OP_LSSEQU = 277,
    T_OP_INC	= 278,
    T_OP_DEC	= 279,
    T_OP_AND	= 280,
    T_OP_OR	= 281,
    T_OP_NOT	= 282,
    
    T_SP_SMCOLON= 283,	//SP = SEPARATOR
    T_SP_COMMA	= 284,
    T_SP_PARENTESESLFT	= 285,
    T_SP_PARENTESESRGT	= 286,
    T_SP_BRACKETSLFT	= 287,
    T_SP_BRACKETSRGT	= 288,
    
    T_ID 	= 289,
    T_INTEGER 	= 290,
    T_FLOAT 	= 291,
    T_CHAR 	= 292,
    T_STRING 	= 293,
    T_EOF 	= 294,
    T_UNKNOWN 	= 295
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
ID                {LETRA}({LETRA}|{DIGITO})*
INTEIRO           {DIGITO}+
FLOAT             {DIGITO}+\.{DIGITO}*
COMENTARIO_LINHA  \/\/[^\n]*
COMENTARIO_BLOCO  \/\*([^*]|\*+[^*/])*\*+\/
CHAR_LITERAL      \'\\?[^']\'
STRING_ABERTA     \"[^"\n]*\n
STRING_LITERAL    \"[^"\n]*\"

/* Seção de Regras */
%%
[ \t]+         { /* Ignorar espaços em branco e tabulações */ }
\n             { line_count++; }
{COMENTARIO_LINHA} { /* Ignora comentário de linha */ }
{COMENTARIO_BLOCO} { /* Ignora comentário de bloco */ }

"if"           { return T_IF; }
"else"         { return T_ELSE; }
"return"       { return T_RETURN; }
"void"         { return T_VOID; }
"while"        { return T_WHILE; }
"for"          { return T_FOR; }

"char"         { return T_KW_CHAR; }
"int"          { return T_KW_INT; }
"float"        { return T_KW_FLOAT; }

{INTEIRO}      { yylval = atoi(yytext); return T_INTEGER; }
{FLOAT}        { return T_FLOAT; }
{CHAR_LITERAL} { return T_CHAR; }
{STRING_ABERTA}  { printf("Erro Léxico na linha %d: String não terminada: %s", line_count, yytext); line_count++; return T_UNKNOWN;}
{STRING_LITERAL} { return T_STRING; }

{ID}           { yylval = get_symbol_position(yytext); return T_ID; }

"=="           { return T_OP_ISEQU; }
"!="           { return T_OP_NOTEQ; }
"<"            { return T_OP_LESSER; }
">"            { return T_OP_GREATER; }
"<="           { return T_OP_GRTEQU; }
">="           { return T_OP_LSSEQU; }

"++"           { return T_OP_INC; }
"--"           { return T_OP_DEC; }

"+"            { return T_OP_ADD; }
"-"            { return T_OP_SUB; }
"*"            { return T_OP_MUL; }
"/"            { return T_OP_DIV; }
"="            { return T_OP_ATRIB; }

"&&"           { return T_OP_AND; }
"||"           { return T_OP_OR; }
"!"            { return T_OP_NOT; }

";"            { return T_SP_SMCOLON; }
","            { return T_SP_COMMA; }
"("            { return T_SP_PARENTESESLFT; }
")"            { return T_SP_PARENTESESRGT; }
"{"            { return T_SP_BRACKETSLFT; }
"}"            { return T_SP_BRACKETSRGT; }

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
        printf("Token: %d ", token_id);

        switch ( token_id ) {
          case T_IF:
            printf("(IF)     | Lexema: %s\n", yytext);
          break;
          case T_ELSE:
            printf("(ELSE)     | Lexema: %s\n", yytext);
          break;
          case T_RETURN:
            printf("(RETURN)     | Lexema: %s\n", yytext);
          break;
          case T_WHILE:
            printf("(WHILE)     | Lexema: %s\n", yytext);
          break;
          case T_FOR:
            printf("(FOR)     | Lexema: %s\n", yytext);
          break;
          case T_VOID:
            printf("(VOID)     | Lexema: %s\n", yytext);
          break;
          case T_KW_CHAR:
            printf("(CHAR)     | Lexema: %s\n", yytext);
          break;
          case T_KW_INT:
            printf("(INT)     | Lexema: %s\n", yytext);
          break;
          case T_KW_FLOAT:
            printf("(FLOAT)     | Lexema: %s\n", yytext);
          break;
          case T_OP_ADD:
            printf("(ADD)     | Lexema: %s\n", yytext);
          break;
          case T_OP_SUB:
            printf("(SUB)     | Lexema: %s\n", yytext);
          break;
          case T_OP_MUL:
            printf("(MUL)     | Lexema: %s\n", yytext);
          break;
          case T_OP_DIV:
            printf("(DIV)     | Lexema: %s\n", yytext);
          break;
          case T_OP_ATRIB:
            printf("(ATRIB)     | Lexema: %s\n", yytext);
          break;
          case T_OP_ISEQU:
            printf("(ISEQU)     | Lexema: %s\n", yytext);
          break;
          case T_OP_NOTEQ:
            printf("(NOTEQ)     | Lexema: %s\n", yytext);
          break;
          case T_OP_GREATER:
            printf("(GREATER)     | Lexema: %s\n", yytext);
          break;
          case T_OP_LESSER:
            printf("(LESSER)     | Lexema: %s\n", yytext);
          break;
          case T_OP_GRTEQU:
            printf("(GRTEQU)     | Lexema: %s\n", yytext);
          break;
          case T_OP_LSSEQU:
            printf("(LSSEQU)     | Lexema: %s\n", yytext);
          break;
          case T_OP_INC:
            printf("(INC)     | Lexema: %s\n", yytext);
          break;
          case T_OP_DEC:
            printf("(DEC)     | Lexema: %s\n", yytext);
          break;
          case T_OP_AND:
            printf("(AND)     | Lexema: %s\n", yytext);
          break;
          case T_OP_OR:
            printf("(OR)     | Lexema: %s\n", yytext);
          break;
          case T_OP_NOT:
            printf("(NOT)     | Lexema: %s\n", yytext);
          break;
          case T_SP_SMCOLON:
            printf("(SMCOLON)     | Lexema: %s\n", yytext);
          break;
          case T_SP_COMMA:
            printf("(COMMA)     | Lexema: %s\n", yytext);
          break;
          case T_SP_PARENTESESLFT:
            printf("(PARENTESESLFT)     | Lexema: %s\n", yytext);
          break;
          case T_SP_PARENTESESRGT:
            printf("(PARENTESESRGT)     | Lexema: %s\n", yytext);
          break;
          case T_SP_BRACKETSLFT:
            printf("(BRACKETSLFT)     | Lexema: %s\n", yytext);
          break;
          case T_SP_BRACKETSRGT:
            printf("(BRACKETSRGT)     | Lexema: %s\n", yytext);
          break;
          case T_INTEGER:
            printf("(Integer)  | Valor: %d\n", yylval);
          break;
          case T_FLOAT:
            printf("(Float)    | Lexema: %s\n", yytext);
          break;
          case T_CHAR:
            printf("(Char)     | lexema: %s\n", yytext);
          break;
          case T_STRING:
            printf("(String)   | Lexema: %s\n", yytext);
          break;
        }
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
