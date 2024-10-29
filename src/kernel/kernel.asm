[bits 32]

global _start
_start:
	cli

	call setup_idt

	sti

	mov byte [color.foreground], WHITE
	mov byte [color.background], BLACK

	mov esi, title_text
	call write
	
	int 0x0

	jmp $


sleep:
	push eax
	mov eax, 0xfffffff

	.loop:
		dec eax
		cmp eax, 0
		jg  .loop

	pop eax
	ret


isr_handler:
	mov esi, interrupt_text
	call write
	ret
	

%include "src/kernel/VGA_functions.asm"
%include "src/kernel/IDT.asm"



title_text: db "Hello Kernel", 0x10, 0
interrupt_text: db "Interrupt received!", 0x10, 0
