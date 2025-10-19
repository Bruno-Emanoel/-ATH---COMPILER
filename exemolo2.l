import console{ Print }; // importa entidade de print

// Definição de variáveis
int num = 2;

~ATH(num <= 10){ // Se num for menor ou igual a 10...
    // Imprime "é menor ou igual"
    ~ATH(){} EXECUTE ( Print{"é menor ou igual"} );

    SELF.DIE(); // Mata o ciclo sem passar por execute
} EXECUTE ( Print{"É maior"} );// Ao final imprime "É maior"

THIS.DIE(); // Finalizar