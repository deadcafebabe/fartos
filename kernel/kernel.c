void putc(int chr)
{
    terminal_write_char(chr);
}

void puts(char* str)
{
    while (*str) putc(*str++);

    putc('\n');
}

void main()
{
    terminal_init();

    puts("hello\nworld");
}