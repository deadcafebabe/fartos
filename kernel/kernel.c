#include "../vga/vga.h"

void putc(uint8_t chr)
{
    terminal_write_char(chr);
}

void puts(uint8_t* str)
{
    while (*str) putc(*str++);

    putc('\n');
}

void main()
{
    terminal_init();

    puts("lorem\nipsum\ndolor\nsit\namet\nconsectur\n");
}