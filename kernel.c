#include <stdint.h>

#define VIDEO_HEIGHT 25
#define VIDEO_WIDTH 80
#define VIDEO_MEMORY 0xB8000

uint8_t column;
uint8_t row;
uint16_t* video_mem;

void terminal_init()
{
    column = 0;
    row = 0;
    video_mem = (uint16_t*)VIDEO_MEMORY;
}

uint16_t vga_entry(uint8_t chr, uint8_t clr)
{
    return clr << 8 | chr;
}

void terminal_write_char(uint8_t chr)
{
    if (chr == '\n') {
        video_mem += VIDEO_WIDTH - row;
        row = 0;
        column++;
        return;
    }

    if (chr == '\r') {
        video_mem -= row;
        row = 0;
        return;
    }

    *video_mem = vga_entry(chr, 0x7);
    video_mem++;
    row++;

    if (row == VIDEO_WIDTH) {
        row = 0;
        column++;
    }
}

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

    puts("welcome\nto\nfart\nos");
}