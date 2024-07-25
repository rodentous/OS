[bits 32]

[extern main]


lidt
call main

%include "src/kernel/IDT.asm"

jmp $
