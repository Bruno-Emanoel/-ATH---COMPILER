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
  struct Node **child;
  int childCnt;
};

#define Node struct Node

Node *makeNode(char *name, Node **childs, int childCnt) {
    Node *novo = malloc(sizeof(Node));
    novo->value = malloc(sizeof(char)*30);
    strcpy(novo->value, name);
    novo->child = childs;
    novo->childCnt = childCnt;
    return novo;
}

void populate(Node **child, Node **list, int size) {
  for(int i = 0; i < size; i++) {
    child[i] = list[i];
  }
}

#define NULLCHILD NULL,0
#define $$ yyval.node
#define MAKECHILD Node **child = NULL;
#define ALLOCCHILD(num) { if(num) child = malloc(sizeof(Node*)*num); }
#define POPULATECHILD(size, ...) {Node *aux[] = {__VA_ARGS__}; populate(child,aux,size);}
#define NODEFY(name, size, ...) {  \
        MAKECHILD; \
        ALLOCCHILD(size);  \
        POPULATECHILD(size,__VA_ARGS__);  \
        $$ = makeNode(name,child,size); \
}
#define SINGLENODEFY(name) $$ = makeNode(name,NULLCHILD)

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

void imprimir_arvore(Node *node, int deepnes) {
    for(int i = 0; i < deepnes; i++) {
        putchar('\t');
    }
    printf("%s\n",node->value);
    for(int i = 0; i < node->childCnt; i++) {
        if(node->child[i]!=NULL)
            imprimir_arvore(node->child[i],deepnes+1);
    }
    free(node->value);
    if(node->childCnt)
        free(node->child);
}

Node *root;
%}

/* --- DEFINIÇÕES BISON --- */
%union {
    int ival;
    double fval; 
    char *name;
    Node *node;
}

%token T_ATH T_EXECUTE T_THIS T_SELF T_NULL T_IMPORT T_LEND T_INPUT T_RETURN T_AS
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

%start program
%type <node> program importList import importDeclaration multImportDeclaration 
%type <node> entityBlock entityDeclaration
%type <node> possessionList possesion possesionDeclaration
%type <node> typeName expression term unitaryOperator operator terminal
%type <node> cycleBlock cycleTerminator

%%
/*import unitário
expressão
posse normal (declaração de variável)
entidade de posse (nome: entidade)
Bloco de entidade*/
program:
    importList entityBlock {NODEFY("program", 2, $1, $2); root = $$; }
    ;

importList: { $$ = NULL;}|
    importList import {NODEFY("importList", 2, $1, $2);}
    ;
    
import:
    T_IMPORT importDeclaration T_SP_SMCOLON {NODEFY("import", 3, makeNode("IMPORT", NULLCHILD), $2, makeNode(";", NULLCHILD));}
    | T_IMPORT importDeclaration T_SP_BRACKETSLFT multImportDeclaration T_SP_BRACESRGT T_SP_SMCOLON {NODEFY("import", 6, makeNode("IMPORT", NULLCHILD), $2, makeNode("{", NULLCHILD), $4, makeNode("}", NULLCHILD), makeNode(";", NULLCHILD));}
    | T_IMPORT T_STRING T_SP_SMCOLON {NODEFY("import", 3, makeNode("IMPORT", NULLCHILD), makeNode($2, NULLCHILD), makeNode(";", NULLCHILD));}
    | T_IMPORT T_STRING T_AS T_ID T_SP_SMCOLON {NODEFY("import", 5, makeNode("IMPORT", NULLCHILD), makeNode(($2), NULLCHILD), makeNode("AS", NULLCHILD), makeNode($4, NULLCHILD), makeNode(";", NULLCHILD));}
    ;

importDeclaration:
    T_ID                { NODEFY("importDeclaration", 1, makeNode($1,NULLCHILD)); }
    | T_ID T_AS T_ID { NODEFY("importDeclaration", 3, makeNode($1,NULLCHILD), makeNode("AS", NULLCHILD), makeNode($3,NULLCHILD)); }
    ;

multImportDeclaration:
    importDeclaration T_SP_COMMA multImportDeclaration {NODEFY("multImportDeclaration", 3, $1, makeNode(",", NULLCHILD), $3);}
    | importDeclaration T_SP_COMMA importDeclaration {NODEFY("multImportDeclaration", 3, $1, makeNode(",", NULLCHILD), $3);}
    | importDeclaration {NODEFY("multmportDeclaration", 1, $1);}
    ;

entityBlock:
    possessionList cycleBlock { NODEFY("entityBlock", 2, $1, $2); }
    ;
    
entityDeclaration: 
    T_ID T_SP_COLON entityBlock { NODEFY("entityDeclaration", 3, makeNode($1,NULLCHILD), makeNode(":",NULLCHILD), $3); }
    ;

possessionList:  { $$ = NULL; }|
    possessionList possesion { NODEFY("possessionList", 2, $1, $2); }
    ;

possesion: 
    entityDeclaration       { NODEFY("possession", 1, $1); } | 
    possesionDeclaration    { NODEFY("possession", 1, $1); }
    ;


possesionDeclaration:
    typeName T_ID T_OP_ATRIB expression T_SP_SMCOLON { NODEFY("possessionDeclaration", 5, $1, makeNode(($2),NULLCHILD), makeNode("=",NULLCHILD), $4, makeNode(";",NULLCHILD)); }
    ;
       

typeName: 
    T_KW_ENTITY { SINGLENODEFY("ENTITY"); } |
    T_KW_INT    { SINGLENODEFY("INT"); }    |
    T_KW_FLOAT  { SINGLENODEFY("FLOAT"); }  |
    T_KW_CHAR   { SINGLENODEFY("CHAR"); }   |
    T_KW_STRING { SINGLENODEFY("STRING"); } |
    T_KW_ARRAY  { SINGLENODEFY("ARRAY"); }
    ;

expression: 
    term                        { NODEFY("expression", 1, $1); }        | 
    unitaryOperator expression  { NODEFY("expression", 2, $1, $2); }    | 
    term operator expression    { NODEFY("expression", 3, $1, $2, $3); }
    ;
    
term:
    term operator terminal                           { NODEFY("term", 3, $1,$2,$3); } | 
    T_SP_PARENTESESLFT expression T_SP_PARENTESESLFT { NODEFY("term", 3, makeNode("(",NULLCHILD),$2,makeNode(")",NULLCHILD)); } | 
    terminal                                         { NODEFY("term", 1, $1); }
    ;       

terminal: T_FLOAT {
        char *s = malloc(50);
        sprintf(s,"%f",$1);
        SINGLENODEFY(s);
    } | 
    T_INTEGER {
        char *s = malloc(50);
        sprintf(s,"%d",$1);
        SINGLENODEFY(s);
    } | 
    T_ID {SINGLENODEFY(($1));} | 
    T_CHAR {SINGLENODEFY(($1));} | 
    T_STRING {SINGLENODEFY(($1));} |
    T_NULL   { SINGLENODEFY("NULL"); }
    ;

unitaryOperator:
        T_OP_NOT {SINGLENODEFY("!");}
        | T_OP_DEC {SINGLENODEFY("--");}
        | T_OP_INC {SINGLENODEFY("++");}
        ;
operator:
    T_OP_ADD        { SINGLENODEFY("+");  }
    | T_OP_AND      { SINGLENODEFY("&&"); }
    | T_OP_DIV      { SINGLENODEFY("/");  }
    | T_OP_GREATER  { SINGLENODEFY(">");  }
    | T_OP_GRTEQU   { SINGLENODEFY(">="); }
    | T_OP_DIVATB   { SINGLENODEFY("/="); }
    | T_OP_ISEQU    { SINGLENODEFY("=="); }
    | T_OP_LESSER   { SINGLENODEFY("<");  }
    | T_OP_LSSEQU   { SINGLENODEFY("<="); }
    | T_OP_MUL      { SINGLENODEFY("*");  }
    | T_OP_MULATB   { SINGLENODEFY("*="); }
    | T_OP_NOTEQ    { SINGLENODEFY("!="); }
    | T_OP_OR       { SINGLENODEFY("||"); }
    | T_OP_SUB      { SINGLENODEFY("-");  }
    | T_OP_SUBATB   { SINGLENODEFY("-="); }
    | T_OP_SUMATB   { SINGLENODEFY("+="); }
    | T_OP_XOR      { SINGLENODEFY("^^"); }
| T_OP_ATRIB        { SINGLENODEFY("=");  }
    ;
 
cycleBlock: { $$ = NULL; }| 
    T_ATH T_SP_PARENTESESLFT expression T_SP_PARENTESESRGT T_SP_BRACKETSLFT 
    cycleBlock T_SP_BRACKETSRGT T_EXECUTE T_SP_PARENTESESLFT expression T_SP_PARENTESESRGT T_SP_SMCOLON
    cycleTerminator {NODEFY("cycleBlock", 13, makeNode("~ATH", NULLCHILD), makeNode("(", NULLCHILD), $3, makeNode(")", NULLCHILD), makeNode("{", NULLCHILD), $6, makeNode("}", NULLCHILD), makeNode("EXECUTE", NULLCHILD), makeNode("(", NULLCHILD), $10, makeNode(")", NULLCHILD), makeNode(";", NULLCHILD), $13);}
            ;

cycleTerminator: { $$ = NULL; } |
    T_THIS T_OP_ACCESS T_ID T_SP_PARENTESESLFT T_SP_PARENTESESRGT T_SP_SMCOLON      { NODEFY("cycleTerminator", 6, makeNode("THIS", NULLCHILD), makeNode("->", NULLCHILD), makeNode(($3), NULLCHILD), makeNode("(", NULLCHILD), makeNode(")", NULLCHILD), makeNode(";", NULLCHILD)); }
    | T_SELF T_OP_ACCESS T_ID T_SP_PARENTESESLFT T_SP_PARENTESESRGT T_SP_SMCOLON    { NODEFY("cycleTerminator", 6, makeNode("SELF", NULLCHILD), makeNode("->", NULLCHILD), makeNode(($3), NULLCHILD), makeNode("(", NULLCHILD), makeNode(")", NULLCHILD), makeNode(";", NULLCHILD)); }
    ;

%%
/* --- CÓDIGO C ADICIONAL --- */
int main() {
    if(yyparse()==0) {
        imprimir_arvore(root,0);
        return 0;
    }
    return -1;
}

int yyerror(char *s) {
    if (strcmp(s, "syntax error") == 0) {
        fprintf(stderr, "Que vacilo! (Erro de sintaxe)\n");
    } else {
        fprintf(stderr, "%s\n", s);
    }
    return 0;
}