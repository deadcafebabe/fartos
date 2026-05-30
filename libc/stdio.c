#include "stdio.h"

void putc(int chr)
{
    terminal_write_char(chr);
}

void puts(char* str)
{
    while (*str) putc(*str++);

    putc('\n');
}
