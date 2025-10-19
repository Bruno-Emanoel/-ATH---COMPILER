# ~ATH - COMPILADORES
### Integrantes
|Nome|Github|
|----|------|
|Bruno Emanoel|[link](github.com)|
|Cecília Brito|[link](github.com)|
|Allan Barros|[link](github.com)|

### Sumário

1. [Resumo](#resumo)
2. [Introdução](#introdução)
3. [Estrutura da linguagem](#estrutura-da-linguagem)
4. [Lexemas e Tokens](#lexemas-e-tokens)
5. [Estrutura do projeto](#estrutura-do-projeto)
6. [Teste e Exemplos](#teste)

## Resumo

Este projeto mantém a implementação da `~ATH` ("Til Death"), uma linguagem de programação de paradigma imperativo e com sistema de tipos estático, desenvolvida para a disciplina de Compiladores - MATA61 da UFBA - Universidade Federal da Bahia. A característica principal da linguagem está em sua estruturação "orientada a loops", ou "orientada a ciclos de vida", na qual a principal estrutura de controle de fluxo é implementada através de uma construção iterativa que persiste realizando uma mesma ação enquanto uma condição ou entidade vinculada a ela mantiver um estado "ativo" ou "vivo".

Estado do Projeto: O projeto está em fase de concepção da linguagem e planejamento da implementação do analisador léxico.

## Introdução

A linguagem `~ATH` é inspirada em uma linguagem de programação ficticia de mesmo nome presente na webcomic "Homestuck". Sua estrutura principal é um constructo de interação baseado na "vida" de valores variáveis dentro de um programa. Abaixo está um exemplo de um código mínimo de `~ATH`:

```~ATH
~ATH() {

} EXECUTE (NULL);

THIS.DIE();
```

A palavra chave `~ATH` define um "ciclo" ou "loop" de maneira análoga a linguagens tradicionais. Dentro dos parênteses seguintes é possível "vincular" algum valor ou objeto da linguagem cujo estado será checado ao final de cada iteração deste ciclo. Dentro das chaves é aceito código com a mesma estrutura representada. 

Ao final, quando o estado do objeto vinculado ao ciclo for reconhecido como "inativo" ou "morto", então não será realizada uma nova execução, e será feita uma chamada para uma função pelo campo `EXECUTE` ao fim do loop, nesse caso nada será executado, evidenciado pela palavra reservada `NULL`. Por fim, `THIS.DIE()` é uma boa prática para finalização do programa.

## Estrutura da linguagem

## Lexemas e Tokens

## Lexemas e Tokens

### Palavras Reservadas

| Categoria | Token | Lexema | Descrição |
|-----------|-------|--------|-----------|
| Controle de Ciclo | `<~ATH>` | `~ATH` | Indica o início de um "ciclo de vida" ou "loop" |
| Controle de Ciclo | `<EXECUTE>` | `EXECUTE` | Indica o fim de um "ciclo de vida" e a ação que será executada ao seu término |
| Controle de Ciclo | `<THIS>` | `THIS` | Se refere ao escopo global do programa |
| Controle de Ciclo | `<SELF>` | `SELF` | Se refere ao escopo local do programa, ou o "ciclo" atual |
| Valores Especiais | `<NULL>` | `NULL` | Entidade vazia, pode ser chamada como "função" mas não realiza nenhuma ação |
| Modularidade | `<IMPORT>` | `IMPORT` | Importa outros módulos ou constructos da biblioteca padrão |
| Referência | `<LEND>` | `LEND` | Toma a referência de um valor |
| Funções | `<INPUT>` | `INPUT` | Define uma posse de um ciclo como "entrada" ou "argumento" |
| Funções | `<RETURN>` | `RETURN` | Define uma posse de um ciclo como "saída" ou "retorno" |
| Tipos | `<INT>` | `INT` | Palavra chave para identificar tipagem de variável como valor inteiro |
| Tipos | `<FLOAT>` | `FLOAT` | Palavra chave para identificar tipagem de variável como valor de ponto flutuante |
| Tipos | `<CHAR>` | `CHAR` | Palavra chave para identificar tipagem de variável como valor de caractere |
| Tipos | `<STRING>` | `STRING` | Palavra chave para identificar tipagem de variável como valor de string ou texto |
| Tipos | `<ARRAY>` | `ARRAY` | Palavra chave para identificar tipagem de variável como valor composto de diversos tipos |
| Tipos | `<ENTITY>` | `ENTITY` | Palavra chave para identificar tipagem de variável como valor complexo que pode ser executado como ciclo próprio |

### Operadores

| Token | Lexema | Descrição |
|-------|--------|-----------|
| `<ATRIB>` | `=` | Operador de atribuição |
| `<SUMATRIB>` | `+=` | Operador de atribuição com soma |
| `<SUBATRIB>` | `-=` | Operador de atribuição com subtração |
| `<MULATRIB>` | `*=` | Operador de atribuição com multiplicação |
| `<DIVATRIB>` | `/=` | Operador de atribuição com divisão |
| `<SUM>` | `+` | Operador de soma |
| `<SUB>` | `-` | Operador de subtração |
| `<INC>` | `++` | Operador de incremento |
| `<DEC>` | `--` | Operador de decremento |
| `<MUL>` | `*` | Operador de multiplicação |
| `<DIV>` | `/` | Operador de divisão |
| `<ACCESS>` | `->` | Operador de acesso |
| `<ISEQU>` | `==` | Operador de "igual à" |
| `<ISDIF>` | `!=` | Operador de "diferente de" |
| `<LT>` | `<` | Operador de "menor que" |
| `<GT>` | `>` | Operador de "maior que" |
| `<LTE>` | `<=` | Operador de "menor ou igual" |
| `<GTE>` | `>=` | Operador de "maior ou igual" |
| `<OR>` | `\|\|` | Operador de "Ou" lógico |
| `<AND>` | `&&` | Operador de "E" lógico |
| `<NOT>` | `!` | Operador de "Não" lógico |
| `<XOR>` | `^^` | Operador de "Ou exclusivo" lógico |

### Separadores

| Token | Lexema | Descrição |
|-------|--------|-----------|
| `<SCOLLON>` | `;` | Delimitador de expressões |
| `<COLLON>` | `:` | Indicador de ciclo interno |
| `<COMMA>` | `,` | Separador de argumentos |
| `<DOT>` | `.` | Operador de acesso especial |
| `<PTOPEN>` | `(` | Delimitador de expressão (abertura) |
| `<PTCLOSE>` | `)` | Delimitador de expressão (fechamento) |
| `<SBOPEN>` | `[` | Especificador de array (abertura) |
| `<SBCLOSE>` | `]` | Especificador de array (fechamento) |
| `<BTOPEN>` | `{` | Delimitador de composição (abertura) |
| `<BTCLOSE>` | `}` | Delimitador de composição (fechamento) |

### Literais

| Token | Lexema | Descrição | Exemplo |
|-------|--------|-----------|---------|
| `<LINT>` | Números inteiros | Números inteiros literais, com suporte para decimal, binário, octal e hexadecimal | `<LINT, 123>` |
| `<LFLOAT>` | Números com casa decimal | Números com casa decimal ou notação científica | `<LFLOAT, 1.2>` |
| `<LCHAR>` | Caracteres entre aspas simples | Caracter normal ou especial (escapado) entre aspas simples | `<LCHAR, 'c'>` |
| `<LSTRING>` | Sequência de caracteres | Sequência de caracteres entre aspas duplas | `<LSTRING, "alo">` |

### Identificadores (Posses)

| Token | Lexema | Descrição | Padrão |
|-------|--------|-----------|--------|
| `<ID>` | Identificadores | Variáveis em `~ATH`, devem começar com uma letra ou til(~) e são formados por letras, dígitos, underscore (_) ou til (~) | `[a-zA-Z~][a-zA-Z0-9_~]*` |

## Estrutura do projeto

## Teste e Exemplos

## Regras de Transição (em Mermaid)

### Palavras Reservadas

**Token:** RETURN
```mermaid
graph LR;
A(Start) -- r/R --> B;
B -- e/E --> C;
C -- t/T --> D;
D -- u/U --> E;
E -- r/R --> F;
F -- n/N --> G((Accept RETURN));
```

**Token:** NULL
```mermaid
graph LR;
A(Start) -- n/N --> B;
B -- u/U --> C;
C -- l/L --> D;
D -- l/L --> E((Accept NULL));
```

**Token:** ATH
```mermaid
graph LR;
A(Start) -- ~ --> B;
B -- a/A --> C;
C -- t/T --> D;
D -- h/H --> E((Accept ATH));
```

**Token:** EXECUTE
```mermaid
graph LR;
A(Start) -- e/E --> B;
B -- x/X --> C;
C -- e/E --> D;
D -- c/C --> E;
E -- u/U --> F;
F -- t/T --> G;
G -- e/E --> H((Accept EXECUTE));
```

**Token:** THIS
```mermaid
graph LR;
A(Start) -- t/T --> B;
B -- h/H --> C;
C -- i/I --> D;
D -- s/S --> E((Accept THIS));
```

**Token:** SELF
```mermaid
graph LR;
A(Start) -- s/S --> B;
B -- e/E --> C;
C -- l/L --> D;
D -- f/F --> E((Accept SELF));
```

**Token:** IMPORT
```mermaid
graph LR;
A(Start) -- i/I --> B;
B -- m/M --> C;
C -- p/P --> D;
D -- o/O --> E;
E -- r/R --> F;
F -- t/T --> G((Accept IMPORT));
```

**Token:** INPUT
```mermaid
graph LR;
A(Start) -- i/I --> B;
B -- n/N --> C;
C -- p/P --> D;
D -- u/U --> E;
E -- t/T --> F((Accept INPUT));
```

**Token:** LEND
```mermaid
graph LR;
A(Start) -- l/L --> B;
B -- e/E --> C;
C -- n/N --> D;
D -- d/D --> E((Accept LEND));
```

**Token:** CHAR
```mermaid
graph LR;
A(Start) -- c/C --> B;
B -- h/H --> C;
C -- a/A --> D;
D -- r/R --> E((Accept CHAR));
```

**Token:** ENTITY
```mermaid
graph LR;
A(Start) -- e/E --> B;
B -- n/N --> C;
C -- t/T --> D;
D -- i/I --> E;
E -- t/T --> F;
F -- y/Y --> G((Accept ENTITY));
```

**Token:** ARRAY
```mermaid
graph LR;
A(Start) -- a/A --> B;
B -- r/R --> C;
C -- r/R --> D;
D -- a/A --> E;
E -- y/Y --> F((Accept ARRAY));
```

**Token:** INT
```mermaid
graph LR;
A(Start) -- i/I --> B;
B -- n/N --> C;
C -- t/T --> D((Accept INT));
```

**Token:** FLOAT
```mermaid
graph LR;
A(Start) -- f/F --> B;
B -- l/L --> C;
C -- o/O --> D;
D -- a/A --> E;
E -- t/T --> F((Accept FLOAT));
```

---

### Tipos e Literais

**Token:** LINT
```mermaid
graph LR;
A(Start) -- [0-9] --> B((* Accept LINT));
B -- [0-9] --> B;
```


**Token:** LFLOAT
```mermaid
graph LR;
    A(Start) -- [0-9] --> B(* B);
    B -- [0-9] --> B;
    A -- . --> C;
    B -- . --> D((* Accept LFLOAT));
    C -- [0-9] --> D;
    D -- [0-9] --> D;
    
    %% Caminho FLOAT_PADRAO + [fF]?
    D -- f/F --> E((Accept LFLOAT));
    
    %% Caminho FLOAT_CIENTIFICA
    B -- e/E --> F;
    D -- e/E --> F;
    
    F -- [+-] --> G;
    F -- [0-9] --> H((* Accept LFLOAT));
    G -- [0-9] --> H((* Accept LFLOAT));
    H -- [0-9] --> H;
```


**Token:** LCHAR
```mermaid
graph LR;
A(Start) -- ' --> B;
B -- \ --> C;
B -- [^'] --> D;
C -- [^'] --> D;
D -- ' --> E((Accept LCHAR));
```


**Token:** LSTRING
```mermaid
graph LR;
A(Start) -- '' --> B(* B);
B -- [^''\n] --> B;
B -- '' --> C((Accept LSTRING));
```
OBS: como o mermaid tem problemas como o caractere de aspas duplas, esse diagrama usa duas aspas simples como substituto.

**Token:** ID
```mermaid
graph LR;
A(Start) -- [a-zA-Z~] --> B((* Accept ID));
B -- [a-zA-Z_0-9~] --> B;
```

### Operadores relacionais e lógicos

**Token:** ISEQU
```mermaid
graph LR;
A(Start) -- "=" --> B;
B -- "=" --> C((Accept ISEQU));
```

**Token:** ISDIF
```mermaid
graph LR;
A(Start) -- "!" --> B;
B -- "=" --> C((Accept ISDIF));
```

**Token:** LT
```mermaid
graph LR;
A(Start) -- "<" --> B((Accept LT));
```

**Token:** GT
```mermaid
graph LR;
A(Start) -- ">" --> B((Accept GT));
```

**Token:** LTE
```mermaid
graph LR;
A(Start) -- "<" --> B;
B -- "=" --> C((Accept LTE));
```

**Token:** GTE
```mermaid
graph LR;
A(Start) -- ">" --> B;
B -- "=" --> C((Accept GTE));
```

### Operadores de incremento e atribuição

**Token:** INC
```mermaid
graph LR;
A(Start) -- "+" --> B;
B -- "+" --> C((Accept INC));
```

**Token:** DEC
```mermaid
graph LR;
A(Start) -- "-" --> B;
B -- "-" --> C((Accept DEC));
```

**Token:** ATRIB
```mermaid
graph LR;
A(Start) -- "=" --> B((Accept ATRIB));
```

**Token:** SUMATRIB
```mermaid
graph LR;
A(Start) -- "+" --> B;
B -- "=" --> C((Accept SUMATRIB));
```

**Token:** SUBATRIB
```mermaid
graph LR;
A(Start) -- "-" --> B;
B -- "=" --> C((Accept SUBATRIB));
```

**Token:** MULATRIB
```mermaid
graph LR;
A(Start) -- "*" --> B;
B -- "=" --> C((Accept MULATRIB));
```

**Token:** DIVATRIB
```mermaid
graph LR;
A(Start) -- "/" --> B;
B -- "=" --> C((Accept DIVATRIB));
```

### Operadores aritméticos

**Token:** SUM
```mermaid
graph LR;
A(Start) -- "+" --> B((Accept SUM));
```

**Token:** SUB
```mermaid
graph LR;
A(Start) -- "-" --> B((Accept SUB));
```

**Token:** MUL
```mermaid
graph LR;
A(Start) -- "*" --> B((Accept MUL));
```

**Token:** DIV
```mermaid
graph LR;
A(Start) -- "/" --> B((Accept DIV));
```

### Operadores lógicos

**Token:** AND
```mermaid
graph LR;
A(Start) -- "&" --> B;
B -- "&" --> C((Accept AND));
```

**Token:** OR
```mermaid
graph LR;
A(Start) -- "|" --> B;
B -- "|" --> C((Accept OR));
```

**Token:** XOR
```mermaid
graph LR;
A(Start) -- "^" --> B;
B -- "^" --> C((Accept XOR));
```

**Token:** NOT
```mermaid
graph LR;
A(Start) -- "!" --> B((Accept NOT));
```

**Token:** ACCESS
```mermaid
graph LR;
A(Start) -- "-" --> B;
B -- ">" --> C((Accept ACCESS));
```

---

### Símbolos Especiais

**Token:** SCOLLON
```mermaid
graph LR;
A(Start) -- ";" --> B((Accept SCOLLON));
```

**Token:** COMMA
```mermaid
graph LR;
A(Start) -- "," --> B((Accept COMMA));
```

**Token:** PTOPEN
```mermaid
graph LR;
A(Start) -- "(" --> B((Accept PTOPEN));
```

**Token:** PTCLOSE
```mermaid
graph LR;
A(Start) -- ")" --> B((Accept PTCLOSE));
```

**Token:** BTOPEN
```mermaid
graph LR;
A(Start) -- "{" --> B((Accept BTOPEN));
```

**Token:** BTCLOSE
```mermaid
graph LR;
A(Start) -- "}" --> B((Accept BTCLOSE));
```

**Token:** SBOPEN
```mermaid
graph LR;
A(Start) -- "[" --> B((Accept SBOPEN));
```

**Token:** SBCLOSE
```mermaid
graph LR;
A(Start) -- "]" --> B((Accept SBCLOSE));
```

**Token:** COLLON
```mermaid
graph LR;
A(Start) -- ":" --> B((Accept COLLON));
```

---

