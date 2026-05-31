BUILD_DIR=build
TARGET=i686-elf
CROSS_DIR=$(HOME)/opt/cross/bin
PROJ_DIR=$(shell pwd)/libc
CFLAGS=-ffreestanding -O2 -nostdlib -Wall -Wextra -nostartfiles

CC=$(CROSS_DIR)/$(TARGET)-gcc
AS=$(CROSS_DIR)/$(TARGET)-as
AR=$(CROSS_DIR)/$(TARGET)-ar

CRTI_OBJ=crti.o
CRTBEGIN_OBJ=$(shell $(CC) $(CFLAGS) -print-file-name=crtbegin.o)
CRTEND_OBJ=$(shell $(CC) $(CFLAGS) -print-file-name=crtend.o)
CRTN_OBJ=crtn.o
LIBC=libc.a
OBJ_LINK_LIST=$(CRTI_OBJ) $(CRTBEGIN_OBJ) $(LIBC) $(OBJS) $(CRTEND_OBJ) $(CRTN_OBJ)

OBJS=boot.o kernel.o vga.o stdio.o

all:
	$(AS) boot.asm -o boot.o
	$(AS) crti.asm -o $(CRTI_OBJ)
	$(AS) crtn.asm -o $(CRTN_OBJ)
	$(CC) -c kernel/vga.c -o vga.o $(CFLAGS)
	$(CC) -c libc/stdio.c -o stdio.o $(CFLAGS)

	$(AR) rcs $(LIBC) stdio.o
	$(CC) -c kernel/kernel.c -o kernel.o -I$(PROJ_DIR) $(CFLAGS)
	$(CC) -T linker.ld -o fartos $(OBJ_LINK_LIST) -L. -lc $(CFLAGS)

	mkdir -p isodir/boot/grub
	cp fartos isodir/boot/fartos
	cp grub.cfg isodir/boot/grub/grub.cfg
	grub-mkrescue -o fartos.iso isodir

clean:
	rm -rf *.o *.a isodir fartos
