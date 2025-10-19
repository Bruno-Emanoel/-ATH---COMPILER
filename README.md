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

### Palavras reservadas

* `~ATH`: Indica o início de um "ciclo de vida" ou "loop"
    * \<~ATH>
* `EXECUTE`: Indica o fim de um "ciclo de vida" e a ação que será executa ao seu término
    * \<EXECUTE>
* `THIS`: Se refere ao escopo global do programa. É possível realizar ações como DIE e EXECUTE.
    * \<THIS>
* `SELF`: Se refere ao escopo local do programa, ou o "ciclo" atual.
    * \<SELF>
* `NULL`: Entidade vazia, pode ser chamada como "função" mas não realiza nenhuma ação.
    * \<NULL>
* `IMPORT`: Importa outros módulos ou constructos da biblioteca padrão.
    * \<IMPORT>
* `LEND`: Toma a referência de um valor.
    * \<LEND>
* `INPUT`: Define uma posse de um ciclo como "entrada" ou "argumento".
    * \<INPUT>
* `RETURN`: Define uma posse de um ciclo como "saida" ou "retorno".
    * \<RETURN>
* `INT`: Palavra chave para identificar tipagem de variável como valor inteiro.
    * \<INT>
* `FLOAT`: Palavra chave para identificar tipagem de variável como valor de ponto flutuante.
    * \<FLOAT>
* `CHAR`: Palavra chave para identificar tipagem de variável como valor de caractere.
    * \<CHAR>
* `STRING`: Palavra chave para identificar tipagem de variável como valor de string ou texto.
    * \<STRING>
* `ARRAY`: Palavra chave para identificar tipagem de variável como valor composto de diversos tipos.
    * \<ARRAY>
* `ENTITY`: Palavra chave para identificar tipagem de variável como valor complexo que pode ser executado como ciclo próprio.
    * \<ENTITY>

### Operadores

* `=`: Operador de atribuição
    * \<ATRIB>
* `+`: Operador de soma
    * \<SUM>
* `-`: Operador de subtração
    * \<SUB>
* `++`: Operador de incremento
    * \<INC>
* `--`: Operador de decremento
    * \<DEC>
* `*`: Operador de multiplicação
    * \<MUL>
* `/`: Operador de divisão
    * \<DIV>
* `->`: Operador de acesso
    * \<ACCESS>
* `==`: Operador de "igual à"
    * \<ISEQU>
* `!=`: Operador de "diferente de"
    * \<ISDIF>
* `<`: Operador de "menor que"
    * \<LT>
* `>`: Operador de "maior que"
    * \<GT>
* `<=`: Operador de "menor ou igual"
    * \<LTE>
* `>=`: Operador de "maior ou igual"
    * \<GTE>
* `||`: Operador de "Ou" lógico
    * \<OR>
* `&&`: Operador de "E" lógico
    * \<AND>
* `!`: Operador de "Não" lógico
    * \<NOT>
* `^^`: Operador de "Ou exclusivo" lógico
    * \<XOR>

### Separadores

* `;`: Delimitador de expressões
    * \<SCOLLON>
* `:`: Indicador de ciclo interno
    * \<COLLON>
* `,`: Separador de argumentos
    * \<COMMA>
* `.`: Operador de acesso especial
    * \<DOT>
* `(`: Delimitador de expressão (abertura)
    * \<PTOPEN>
* `)`: Delimitador de expressão (fechamento)
    * \<PTCLOSE>
* `[`: Especificador de array (abertura)
    * \<SBOPEN>
* `]`: Especificador de array (abertura)
    * \<SBCLOSE>
* `{`: Delimitador de composição (abertura)
    * \<BTOPEN>
* `}`: Delimitador de composição (abertura)
    * \<BTCLOSE>

### Literais

* Inteiros: numeros inteiros literais, com suporte para decimal, binário, octal e hexadecimal. 
    * \<LINT, 123>

* Ponto flutuante: Números com casa decimal ou notação científica
    * \<LFLOAT, 1.2>

* Caracter: caracter normal ou especial(escapado) entre aspas simples
    * \<LCHAR, 'c'>

* Strings: Sequencia de caracteres
    * \<LSTRING, "alo">

### Posses (Variáveis)

* Posses: São as variáveis em `~ATH`, elas devem começar com uma letra ou til(~) e são formados por letras, digitos, underscore (_) ou til (~)
    * \<ID, (num)>

## Estrutura do projeto

## Teste e Exemplos
