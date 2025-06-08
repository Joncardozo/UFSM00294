// sprintf.h - versão mínima para IntegerToString

// Função strlen_
int strlen_(char s[]) {
    int i = 0;
    while (s[i] != '\0')
        ++i;
    return i;
}

// Função reverse
void reverse(char s[]) {
    int c, i, j;
    for (i = 0, j = strlen_(s) - 1; i < j; i++, j--) {
        c = s[i];
        s[i] = s[j];
        s[j] = c;
    }
}

// Função abs_ (valor absoluto)
int abs_(int i) {
    return i < 0 ? -i : i;
}

// Função itoa_
int itoa_(int n, char s[]) {
    int i = 0;
    int sign = n;

    if (sign < 0)
        n = -n;

    do {
        s[i++] = abs_(n % 10) + '0';
    } while ((n /= 10) != 0);

    if (sign < 0)
        s[i++] = '-';

    s[i] = '\0';

    reverse(s);

    return i;
}

// IntegerToString que usa itoa_
void IntegerToString(int n, char *str) {
    itoa_(n, str);
}

