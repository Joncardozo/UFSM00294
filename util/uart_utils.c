// uart_utils.c

#define UART_TX     (*((volatile char *) 0xFFFFFF10))
#define UART_READY  (*((volatile char *) 0xFFFFFF14))

// Converte um número inteiro para string terminada em '\0'
void IntegerToString(int n, char *str) {
    int i = 0, sign = n;

    if (n < 0)
        n = -n;

    do {
        str[i++] = (n % 10) + '0';
        n /= 10;
    } while (n > 0);

    if (sign < 0)
        str[i++] = '-';

    str[i] = '\0';

    // Inverte a string
    for (int j = 0; j < i / 2; ++j) {
        char tmp = str[j];
        str[j] = str[i - j - 1];
        str[i - j - 1] = tmp;
    }
}

// Envia uma string pela UART, caractere por caractere
void PrintString(char *string) {
    while (*string) {
        while (UART_READY == 0);  // Espera a UART ficar pronta
        UART_TX = *string++;      // Envia caractere
    }
}
