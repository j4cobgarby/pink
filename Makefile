all: dist/pink.img

run: all
	bochs

clean:
	rm -rf build dist

build/boot_sect.bin: boot.asm
	mkdir -p build
	nasm $< -f bin -o $@

build/kernel_entry.o: boot/kernel_entry.asm
	mkdir -p build
	nasm $< -f elf -o $@

build/kernel.o: kernel/kernel.c
	mkdir -p build
	gcc -ffreestanding -m32 -c $< -o $@

build/kernel.bin: build/kernel_entry.o build/kernel.o
	ld -m elf_i386 -o $@ -Ttext 0x1000 $^

dist/pink.img: build/boot_sect.bin build/kernel.bin
	mkdir -p dist
	cat $^ > $@
