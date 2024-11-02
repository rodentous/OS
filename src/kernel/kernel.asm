[bits 32]

global _start
_start:
	mov byte [color.foreground], WHITE
	mov byte [color.background], BLACK

	mov esi, kernel_text
	call write

	cli
	call setup_idt
	sti
	
	; int 0x0

	cli
	hlt


sleep:
	push eax
	mov eax, 0xfffffff

	.loop:
		dec eax
		cmp eax, 0
		jg  .loop

	pop eax
	ret


interrupt_handler:
	mov esi, interrupt_text
	call write
	ret
	

%include "src/kernel/VGA_functions.asm"
%include "src/kernel/IDT.asm"



kernel_text: db 0x10, "Starting kernel...", 0x10, 0
interrupt_text: db "Interrupt received!", 0x10, 0
