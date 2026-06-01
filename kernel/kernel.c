#include <stdio.h>
#include <string.h>

void main()
{
    terminal_init();

    char s[] = "hello world";

    memcpy(s, s + 6, 5 * sizeof(char));

    puts(s);
}