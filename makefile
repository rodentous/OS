asm := nasm
ld := x86_64-elf-ld
gcc := x86_64-elf-gcc
qemu := qemu-system-x86_64

all: clean bootloader kernel concatenate run

clean:
	clear
	rm -rf bin/*

bootloader:
	${asm} -f bin "src/bootloader/bootloader.asm" -o "bin/bootloader.bin"

kernel:
	${asm} -f elf64 "src/kernel/kernel.asm" -o "bin/kernel.o"
	${asm} -f elf64 "src/kernel/main.asm" -o "bin/main.o"
	${ld} -o "bin/kernel.elf" -Ttext 0x1000 "bin/kernel.o" "bin/main.o"
	objcopy -O binary "bin/kernel.elf" "bin/kernel.bin"

concatenate:
	${asm} "src/bunch_of_zeroes.asm" -f bin -o "bin/bunch_of_zeroes.bin"
	cat "bin/bootloader.bin" "bin/kernel.bin" "bin/bunch_of_zeroes.bin" > "bin/OS.bin"

run:
	${qemu} -drive format=raw,file=bin/OS.bin
