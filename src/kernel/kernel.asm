[bits 32]


[global _start]
_start:
	mov byte [color.foreground], WHITE
	mov byte [color.background], BLACK

	times 5 call new_line

	mov  esi, kernel_text
	call write

	
	call setup_idt
	int 0
	int 1
	int 2
	int 3
	int 4

	.loop:
		mov bx, ax
		call read_key
		cmp bx, ax
		je .loop
		call write_character
		jmp .loop

	cli
	hlt




[global interrupt_handler]
interrupt_handler:
	pusha

	mov  esi, interrupt_text
	call write

	call write_number
	call new_line
	
	popa
	ret



%include "src/kernel/IDT.asm"
%include "src/kernel/VGA.asm"
%include "src/kernel/keyboard.asm"


kernel_text:    db "== Kernel Setup ==", 0x10, 0
interrupt_text: db "Interrupt received: ", 0x10, 0
