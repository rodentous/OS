export PATH="$PATH:/usr/local/i386elfgcc/bin"

nasm -f bin "src/bootloader/bootloader.asm" -o "bin/bootloader.bin"

nasm -f elf "src/kernel/kernel.asm" -o "bin/kernel.o"

i386-elf-ld -o "bin/kernel.bin" -Ttext 0x1000 "bin/kernel.o" --oformat binary

nasm "src/zeroes.asm" -f bin -o "bin/zeroes.bin"
cat "bin/bootloader.bin" "bin/kernel.bin" "bin/zeroes.bin" > "bin/OS.bin"

qemu-system-x86_64 "bin/OS.bin"

# rm -rf bin/*
