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
    T_IF = 266,
    T_VOID = 301,
    T_ELSE = 302,
    T_WHILE = 303,
    T_FOR = 304,
    T_RETURN = 305,

    T_KW_ENTITY = 267,	//KW = KEYWORD
    T_KW_INT 	  = 268,
    T_KW_FLOAT 	= 269,
    T_KW_CHAR   = 270,
    T_KW_STRING = 271,
    
    T_OP_ADD	= 272,	//OP = OPERATOR
    T_OP_SUB	= 273,
    T_OP_MUL	= 274,
    T_OP_DIV	= 275,
    T_OP_ATRIB	= 276,
    T_OP_ISEQU	= 277,
    T_OP_NOTEQ	= 278,
    T_OP_GREATER= 279,
    T_OP_LESSER	= 280,
    T_OP_GRTEQU = 281,
    T_OP_LSSEQU = 282,
    T_OP_INC	= 283,
    T_OP_DEC	= 284,
    T_OP_AND	= 285,
    T_OP_OR	= 286,
    T_OP_NOT	= 287,
    
    T_SP_SMCOLON= 288,	//SP = SEPARATOR
    T_SP_COMMA	= 289,
    T_SP_PARENTESESLFT	= 290,
    T_SP_PARENTESESRGT	= 291,
    T_SP_BRACKETSLFT	= 292,
    T_SP_BRACKETSRGT	= 293,
    
    T_ID 	= 294,
    T_INTEGER 	= 295,
    T_FLOAT 	= 296,
    T_CHAR 	= 297,
    T_STRING 	= 298,
    T_EOF 	= 299,
    T_UNKNOWN 	= 300

    T_FUNC_OBJ = 306
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

[iI][fF]           { return T_IF; }
[eE][lL][sS][eE]         { return T_ELSE; }
[rR][eE][tT][uU][rR][nN]       { return T_RETURN; }
[vV][oO][iI][dD]         { return T_VOID; }
[wW][hH][iI][lL][eE]        { return T_WHILE; }
[fF][oO][rR]          { return T_FOR; }
~[Aa][Tt][Hh]  { return T_ATH; }
[eE][xX][eE][cC][uU][tT][eE] { return T_EXECUTE; }
[tT][hH][iI][sS] { return T_THIS; }
[Ss][Ee][Ll][fF] { return T_SELF; }
[nN][uU][lL][lL] { return T_NULL; }
[iI][mM][pP][oO][rR][tT] { return T_IMPORT; };
[iI][nN][pP][uU][tT]     { return T_INPUT; };
[Ll][eE][nN][dD]         { return T_LEND; }

[cC][hH][aA][rR]         { return T_KW_CHAR; }
[iI][nN][tT]          { return T_KW_INT; }
[fF][lL][Oo][aA][tT]       { return T_KW_FLOAT; }

{INTEIRO}      { yylval = atoi(yytext); return T_INTEGER; }
{FLOAT}        { return T_FLOAT; }
{CHAR_LITERAL} { return T_CHAR; }
{STRING_ABERTA}  { printf("Erro Léxico na linha %d: String não terminada: %s", line_count, yytext); line_count++; return T_UNKNOWN;}
{STRING_LITERAL} { return T_STRING; }

{ID}           { yylval = get_symbol_position(yytext); return T_ID; }

"=="           { return T_OP_ISEQU; }
"!="           { return T_OP_NOTEQ; }
"<"            { return T_OP_LESSER; }
"> "            { return T_OP_GREATER; }
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
        if(token_id == 294){
            printf("<id, %d> ", get_symbol_position(yytext));
        }

        switch ( token_id ) {
          case T_ATH:
            printf("<ATH> ");
            break;
          case T_EXECUTE:
            printf("<EXECUTE> ");
            break;
          case T_THIS:
            printf("<THIS> ");
            break;
          case T_SELF:
            printf("<SELF> ");
            break;
          case T_NULL:
            printf("<NULL> ");
            break;
          case T_IMPORT:
            printf("<IMPORT> ");
            break;
          case T_LEND:
            printf("<LEND> ");
          break;
          case T_INPUT:
            printf("<INPUT> ");
          break;
          case T_IF:
            printf("<IF> ");
          break;
          case T_ELSE:
            printf("<ELSE> ");
          break;
          case T_RETURN:
            printf("<RETURN> ");
          break;
          case T_WHILE:
            printf("<WHILE> ");
          break;
          case T_FOR:
            printf("<FOR> ");
          break;
          case T_VOID:
            printf("<VOID> ");
          break;
          case T_KW_ENTITY:
            printf("<ENTITY> ");
          break;
          case T_KW_CHAR:
            printf("<CHAR> ");
          break;
          case T_KW_INT:
            printf("<INT> ");
          break;
          case T_KW_FLOAT:
            printf("<FLOAT> ");
          break;
          case T_OP_ADD:
            printf("<+> ");
          break;
          case T_OP_SUB:
            printf("<-> ");
          break;
          case T_OP_MUL:
            printf("<*> ");
          break;
          case T_OP_DIV:
            printf("<\\> ");
          break;
          case T_OP_ATRIB:
            printf("<=> ");
          break;
          case T_OP_ISEQU:
            printf("<==> ");
          break;
          case T_OP_NOTEQ:
            printf("<!=");
          break;
          case T_OP_GREATER:
            printf("< > > ");
          break;
          case T_OP_LESSER:
            printf("< < > ");
          break;
          case T_OP_GRTEQU:
            printf("< >= > ");
          break;
          case T_OP_LSSEQU:
            printf("< <= > ");
          break;
          case T_OP_INC:
            printf("<++> ");
          break;
          case T_OP_DEC:
            printf("<--> ");
          break;
          case T_OP_AND:
            printf("<&&> ");
          break;
          case T_OP_OR:
            printf("<||> ");
          break;
          case T_OP_NOT:
            printf("< ! > ");
          break;
          case T_SP_SMCOLON:
            printf("< ; > ");
          break;
          case T_SP_COMMA:
            printf("< , > ");
          break;
          case T_SP_PARENTESESLFT:
            printf("< ( > ");
          break;
          case T_SP_PARENTESESRGT:
            printf("< ) > ");
          break;
          case T_SP_BRACKETSLFT:
            printf("< { > ");
          break;
          case T_SP_BRACKETSRGT:
            printf("< } > ");
          break;
          case T_INTEGER:
            printf("<int, %d> ", yylval);
          break;
          case T_FLOAT:
            printf("<float, %s> ", yytext);
          break;
          case T_CHAR:
            printf("<char %s> ", yytext);
          break;
          case T_STRING:
            printf("<string, %s> ", yytext);
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
