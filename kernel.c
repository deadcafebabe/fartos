void puts(char* str)
{
    static char* video_mem = (char*)0xB8000;

    while (*str) {
        *video_mem = *str;
        *(video_mem + 1) = 0x7;
        video_mem += 2;
        str++;
    }
}

void main()
{
    puts("hello world");
}