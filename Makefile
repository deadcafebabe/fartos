BUILD_DIR=build

all:
	nasm boot.asm -o $(BUILD_DIR)/boot.bin
	nasm kernel.asm -o $(BUILD_DIR)/kernel.bin
	
	dd if=/dev/zero of=$(BUILD_DIR)/floppy.img bs=1024 count=1440
	mkfs.fat -F 12 -n "FARTOS" $(BUILD_DIR)/floppy.img

	dd if=$(BUILD_DIR)/boot.bin of=$(BUILD_DIR)/floppy.img conv=notrunc
	mcopy -i $(BUILD_DIR)/floppy.img $(BUILD_DIR)/kernel.bin "::kernel.bin"
	mcopy -i $(BUILD_DIR)/floppy.img tmp/test.txt "::test.txt"
