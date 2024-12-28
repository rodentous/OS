asm := nasm
ld := i386-elf-ld
gcc := i386-elf-gcc
qemu := qemu-system-x86_64

all: clean bootloader kernel concatenate run

clean:
	clear
	rm -rf bin/*

bootloader:
	${asm} -f bin "src/bootloader/bootloader.asm" -o "bin/bootloader.bin"

kernel:
	${asm} -f elf "src/kernel/kernel.asm" -o "bin/kernel.o"
	${ld} -o "bin/kernel.bin" -Ttext 0x1000 "bin/kernel.o" --oformat binary

concatenate:
	${asm} "src/bunch_of_zeroes.asm" -f bin -o "bin/bunch_of_zeroes.bin"
	cat "bin/bootloader.bin" "bin/kernel.bin" "bin/bunch_of_zeroes.bin" > "bin/OS.bin"

run:
	${qemu} bin/OS.bin
