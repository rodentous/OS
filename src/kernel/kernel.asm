[bits 32]


[global _start]
_start:
	mov byte [color.foreground], WHITE
	mov byte [color.background], BLACK

	times 5 call new_line

	mov  esi, kernel_text
	call write

	call setup_idt
	mov esi, IDT_text
	call write

	in al, 0x21
	in ah, 0xA1

	call new_line
	mov ax, 0x0
	.loop:
		mov bx, ax
		call read_key
		cmp ax, bx
		je .loop
		cmp ax, 0x0
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
IDT_text:       db "-IDT", 0x10, 0
interrupt_text: db "Interrupt received: ", 0
