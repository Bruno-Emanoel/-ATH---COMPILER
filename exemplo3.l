import console{ Print }; // importa entidade de Print

// Definição de funções
Sum:
    // ordem dos inputs definida por ordem de declaração
    int a = input(); // Define o primeiro input
    int b = input(); // Define o segundo input
    int c = return();// Define a variável que será o retorno
    ~ATH(){} EXECUTE ( c = a + b; );


    SELF.DIE();

// Definição de variáveis
int num = 2;

~ATH(){
    // Não realiza nada dentro do loop
           // Ao executar, imprime o retorno de Sum
           // São passados os parâmetros num e 5 (a e b)
} EXECUTE ( Print{ Sum(num, 5 ) } );

THIS->DIE(); // Finalizar
