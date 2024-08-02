[bits 32]

global _start
_start:
	;call setup_idt

	mov byte [color.foreground], WHITE
	mov byte [color.background], BLACK

	mov esi, title_text
	call write
	;int 0x0	
	mov esi, title_text
	call write
	
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


%include "src/kernel/VGA_functions.asm"
%include "src/kernel/IDT.asm"



title_text: db "Hello Kernel", 0x10, 0
