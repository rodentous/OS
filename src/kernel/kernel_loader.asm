[bits 32]
[extern main]

lidt [IDT_descriptor]
call main

%include "src/kernel/IDT.asm"

jmp $
