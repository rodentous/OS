[bits 32]

global _start
_start:
	mov byte [color.foreground], WHITE
	mov byte [color.background], BLACK

	mov  esi, kernel_text
	call write

	call setup_idt
	
	; in  ax, 0x60
	; cmp ax, 0x0
	; jne interrupt_handler
	
	mov  esi, hello_text
	call write

	int 0

	cli
	hlt


sleep:
	push eax
	mov  eax, 0xFFFFFFF

	.loop:
		dec eax
		cmp eax, 0
		jg  .loop

	pop eax
	ret


global interrupt_handler
interrupt_handler:
	pusha

	mov  esi, interrupt_text
	call write
	
	popa
	ret
	

%include "src/kernel/VGA_functions.asm"
%include "src/kernel/IDT.asm"

kernel_text:    db 0x10, 0x10, 0x10, 0x10, "Starting kernel...", 0x10, 0
interrupt_text: db "Interrupt received", 0x10, 0
hello_text:     db "Hello from kernel!", 0x10, 0