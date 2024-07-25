export PATH="$PATH:/usr/local/i386elfgcc/bin" # cross compilers

# assemble bootloader
nasm -f bin "src/bootloader/bootloader.asm" -o "bin/bootloader.bin"

# compile and link kernel
nasm -f elf "src/kernel/kernel.asm" -o "bin/kernel.o"
i386-elf-ld -o "bin/kernel.bin" -Ttext 0x1000 "bin/kernel.o" --oformat binary

nasm "src/bunch_of_zeroes.asm" -f bin -o "bin/bunch_of_zeroes.bin"
cat "bin/bootloader.bin" "bin/kernel.bin" "bin/bunch_of_zeroes.bin" > "bin/OS.bin"

# run with qemu
qemu-system-x86_64 -drive format=raw,file="bin/OS.bin"

# remove all binary files
# rm -rf bin/*
