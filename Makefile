BUILD_DIR=build
TARGET=i686-elf
CROSS_DIR=~/opt/cross/bin

all:
	$(CROSS_DIR)/$(TARGET)-as boot.asm -o boot.o
	$(CROSS_DIR)/$(TARGET)-gcc -c kernel.c -o kernel.o -std=gnu99 -ffreestanding -O2 -Wall -Wextra
	$(CROSS_DIR)/$(TARGET)-gcc -T linker.ld -o fartos -ffreestanding -O2 -nostdlib boot.o kernel.o -lgcc

	mkdir -p isodir/boot/grub
	cp fartos isodir/boot/fartos
	cp grub.cfg isodir/boot/grub/grub.cfg
	grub-mkrescue -o fartos.iso isodir

