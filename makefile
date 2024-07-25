asm := nasm
ld := /usr/local/i386elfgcc/bin/i386-elf-ld
gcc := /usr/local/i386elfgcc/bin/i386-elf-gcc
qemu := qemu-system-x86_64

all: bootloader kernel concatenate run clean

bootloader:
	${asm} -f bin "src/bootloader/bootloader.asm" -o "bin/bootloader.bin"

kernel:
	${asm} -f elf "src/kernel/kernel.asm" -o "bin/kernel.o"
	${ld} -o "bin/kernel.bin" -Ttext 0x1000 "bin/kernel.o" --oformat binary

concatenate:
	${asm} "src/bunch_of_zeroes.asm" -f bin -o "bin/bunch_of_zeroes.bin"
	cat "bin/bootloader.bin" "bin/kernel.bin" "bin/bunch_of_zeroes.bin" > "bin/OS.bin"

run:
	${qemu} -drive format=raw,file="bin/OS.bin"

clean:
	clear
	rm -rf bin/*
