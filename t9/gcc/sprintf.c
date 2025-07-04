#include "sprintf.h"

int strlen_(char s[]) {
    int i = 0;
    while (s[i] != '\0')
        ++i;
    return i;
}


void reverse(char s[]) {
    int c, i, j;
    for (i = 0, j = strlen_(s) - 1; i < j; i++, j--) {
        c = s[i];
        s[i] = s[j];
        s[j] = c;
    }
}


int abs_(int i) {
    return i < 0 ? -i : i;
}


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


void IntegerToString(int n, char *str) {
    itoa_(n, str);
}


void integer_to_hex(int n, char *s) {
    s[1] = n % 16;
    s[0] = (n / 16) % 16;
}


void delay(int d) {
    volatile int i;
    for (i = 0; i < d; i++);
}

void hex_to_ascii(char* c, char* str) {
    for (int i = 0; i < 2; i++) {
        if (c[i] <= 9) {
            str[i] = (char) c[i] + 48;
        } else {
            str[i] = (char) c[i] + 65 - 10;
        }
    }
}
