#ifndef VGA_H
#define VGA_H

#include <stdint.h>

#define VIDEO_HEIGHT 25
#define VIDEO_WIDTH 80
#define VIDEO_MEMORY 0xB8000

uint16_t vga_entry(uint8_t chr, uint8_t clr);

void terminal_init();
void terminal_write_char(uint8_t chr);

#endif