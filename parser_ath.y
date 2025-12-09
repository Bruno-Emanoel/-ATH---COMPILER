/* calculadora_vars.y - Versão com Impressão de Tabela */

%{
#include <stdio.h>
#include <stdlib.h> 
#include <string.h> 
#include <math.h>

int yylex(void);
int yyerror(char *s);

struct Node {
  char *value;
  Node *child;
  int childCnt;
};

/* --- CÓDIGO DA TABELA DE SÍMBOLOS --- */
#define TAM_TABELA 100
struct simbolo {
    char *nome;
    double valor;
};
struct simbolo tabela_simbolos[TAM_TABELA];
int indice_tabela = 0;

struct simbolo* buscar(char *nome) {
    for (int i = 0; i < indice_tabela; i++) {
        if (strcmp(tabela_simbolos[i].nome, nome) == 0) {
            return &tabela_simbolos[i];
        }
    }
    return NULL;
}

void inserir_ou_atualizar(char *nome, double valor) {
    struct simbolo *s = buscar(nome);
    if (s != NULL) {
        s->valor = valor;
        free(nome); 
    } else {
        if (indice_tabela >= TAM_TABELA) {
            yyerror("Erro: Tabela de simbolos cheia!");
            free(nome);
            return;
        }
        tabela_simbolos[indice_tabela].nome = nome;
        tabela_simbolos[indice_tabela].valor = valor;
        indice_tabela++;
    }
}

/* * MUDANÇA 1: FUNÇÃO PARA IMPRIMIR A TABELA * */
void imprimir_tabela() {
    printf("\n--- Tabela de Simbolos ---\n");
    if (indice_tabela == 0) {
        printf("\t(vazia)\n");
    }
    for (int i = 0; i < indice_tabela; i++) {
        printf("\t%s = %.4f\n", tabela_simbolos[i].nome, tabela_simbolos[i].valor);
    }
    printf("--------------------------\n");
}
%}

/* --- DEFINIÇÕES BISON --- */
%union {
    int ival;
    double fval; 
    char *name;
    Node *token;
}

%union {
}

%token T_ATH T_EXECUTE T_THIS T_SELF T_NULL T_IMPORT T_LEND T_INPUT T_RETURN
%token T_KW_ENTITY T_KW_INT T_KW_FLOAT T_KW_CHAR T_KW_STRING T_KW_ARRAY

%token T_OP_ATRIB T_OP_SUMATB T_OP_SUBATB T_OP_MULATB T_OP_DIVATB
%token T_OP_ISEQU T_OP_NOTEQ T_OP_GREATER T_OP_LESSER T_OP_GRTEQU T_OP_LSSEQU
%token T_OP_AND T_OP_OR T_OP_NOT T_OP_XOR T_OP_ACCESS

%token T_SP_SMCOLON T_SP_COLON T_SP_COMMA
%token T_SP_PARENTESESLFT T_SP_PARENTESESRGT
%token T_SP_BRACKETSLFT T_SP_BRACKETSRGT
%token T_SP_BRACESLFT T_SP_BRACESRGT

%token <ival>    T_INTEGER
%token <fval>    T_FLOAT
%token <name>    T_CHAR T_STRING T_ID
%token T_UNKNOWN



%left T_OP_OR T_OP_XOR
%left T_OP_AND
%left T_OP_ISEQU T_OP_NOTEQ
%left T_OP_GREATER T_OP_LESSER T_OP_GRTEQU T_OP_LSSEQU
%right T_OP_NOT
%left T_OP_ADD T_OP_SUB
%left T_OP_MUL T_OP_DIV
%right T_OP_INC T_OP_DEC 
%left T_OP_ACCESS

%%

/* --- REGRAS DA GRAMÁTICA --- */

%%
/* --- CÓDIGO C ADICIONAL --- */
int main() {
    return yyparse();
}

int yyerror(char *s) {
    if (strcmp(s, "syntax error") == 0) {
        fprintf(stderr, "Que vacilo! (Erro de sintaxe)\n");
    } else {
        fprintf(stderr, "%s\n", s);
    }
    return 0;
}