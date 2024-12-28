[bits 32]


global _start
_start:
	mov byte [color.foreground], WHITE
	mov byte [color.background], BLACK

	times 4 call new_line
а
	mov  esi, kernel_text
	call write

	call setup_idt
	
	int 0
	int 1
	int 2
	int 3
	int 4

	; in  ax, 0x60
	; cmp ax, 0x0
	; jne interrupt_handler

	cli
	hlt



global interrupt_handler
interrupt_handler:
	pusha

	mov  esi, interrupt_text
	call write

	call write_number
	call new_line
	
	popa
	ret



%include "src/kernel/VGA_functions.asm"

kernel_text:    db "Starting kernel...", 0x10, 0
interrupt_text: db "Interrupt received: ", 0

%include "src/kernel/IDT.asm"
