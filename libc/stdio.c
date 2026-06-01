#include "stdio.h"

void putc(int chr)
{
    terminal_write_char(chr);
}

void puts(const char* str)
{
    while (*str) putc(*str++);

    putc('\n');
}
