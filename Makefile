BUILD_DIR=build
TARGET=i686-elf
CROSS_DIR=~/opt/cross/bin
CFLAGS=-ffreestanding -O2 -nostdlib -Wall -Wextra

all:
	$(CROSS_DIR)/$(TARGET)-as boot.asm -o boot.o
	$(CROSS_DIR)/$(TARGET)-gcc -c vga/vga.c -o vga.o $(CFLAGS)
	$(CROSS_DIR)/$(TARGET)-gcc -c kernel/kernel.c -o kernel.o $(CFLAGS)
	$(CROSS_DIR)/$(TARGET)-gcc -T linker.ld -o fartos boot.o kernel.o vga.o -lgcc $(CFLAGS)

	mkdir -p isodir/boot/grub
	cp fartos isodir/boot/fartos
	cp grub.cfg isodir/boot/grub/grub.cfg
	grub-mkrescue -o fartos.iso isodir

