[bits 32]


[global _start]
_start:
	call setup_idt

	jmp main

	cli
	hlt


%include "src/kernel/IDT.asm"
%include "src/kernel/keyboard.asm"
%include "src/kernel/VGA.asm"
%include "src/kernel/main.asm"
