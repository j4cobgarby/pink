all:
	nasm boot.asm -f bin -o boot_sect.bin

run:
	qemu-system-x86_64 -drive format=raw,file=boot_sect.bin
