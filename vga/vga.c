#include "vga.h"

uint8_t column;
uint8_t row;
uint16_t* video_mem;

uint16_t vga_entry(uint8_t chr, uint8_t clr)
{
    return clr << 8 | chr;
}

void terminal_init()
{
    column = 0;
    row = 0;
    video_mem = (uint16_t*)VIDEO_MEMORY;

    for (uint8_t y = 0; y < VIDEO_HEIGHT; y++) {
        for (uint8_t x = 0; x < VIDEO_WIDTH; x++) {
            video_mem[y * VIDEO_HEIGHT + x] = vga_entry(' ', 0x7);
        }
    }
}

void terminal_write_char(uint8_t chr)
{
    switch (chr) {
        case '\n':
            video_mem += VIDEO_WIDTH - row;
            row = 0;
            column++;
            break;

        case '\r':
            video_mem -= row;
            row = 0;
            break;

        case '\t':
            video_mem += 4 - (row % 4); 
            row += 4 - (row % 4);
    }

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