BUILD_DIR=build
TARGET=i686-elf
CROSS_DIR=~/opt/cross/bin
CFLAGS=-ffreestanding -O2 -nostdlib -Wall -Wextra -nostartfiles
CC=$(CROSS_DIR)/$(TARGET)-gcc
AS=$(CROSS_DIR)/$(TARGET)-as

CRTI_OBJ=crti.o
CRTBEGIN_OBJ=$(shell $(CC) $(CFLAGS) -print-file-name=crtbegin.o)
CRTEND_OBJ=$(shell $(CC) $(CFLAGS) -print-file-name=crtend.o)
CRTN_OBJ=crtn.o

OBJ_LINK_LIST=$(CRTI_OBJ) $(CRTBEGIN_OBJ) $(OBJS) $(CRTEND_OBJ) $(CRTN_OBJ)

OBJS=boot.o kernel.o vga.o

all:
	$(AS) boot.asm -o boot.o
	$(AS) crti.asm -o $(CRTI_OBJ)
	$(AS) crtn.asm -o $(CRTN_OBJ)
	$(CC) -c kernel/vga.c -o vga.o $(CFLAGS)
	$(CC) -c kernel/kernel.c -o kernel.o $(CFLAGS)
	$(CC) -T linker.ld -o fartos $(OBJ_LINK_LIST) -lgcc $(CFLAGS)

	mkdir -p isodir/boot/grub
	cp fartos isodir/boot/fartos
	cp grub.cfg isodir/boot/grub/grub.cfg
	grub-mkrescue -o fartos.iso isodir

clean:
	rm *.o

