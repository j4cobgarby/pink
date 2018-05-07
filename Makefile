all:
	mkdir -p build dist
	nasm boot.asm -f bin -o build/boot_sect.bin
	nasm boot/kernel_entry.asm -f elf -o build/kernel_entry.o
	gcc -ffreestanding -m32 -c kernel/kernel.c -o build/kernel.o
	ld -m elf_i386 -o build/kernel.bin -Ttext 0x1000 build/kernel_entry.o build/kernel.o
	cat build/boot_sect.bin build/kernel.bin > dist/pink.img
