[bits 32]

[global _start]
[extern main]
_start:
	call setup_idt
	call main
	cli
	hlt

%include "src/kernel/IDT.asm"
