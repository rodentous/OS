[bits 32]


[global _start]
_start:
	mov byte [color.foreground], WHITE
	mov byte [color.background], LIGHT_BLUE

	call clear_screen

	call setup_idt

	jmp kernel_main

	cli
	hlt


[global isr_handler]
isr_handler:
	pusha

	mov  esi, interrupt_text
	call write

	call write_number
	call new_line

	popa
	ret


[global irq_handler]
irq_handler:
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


interrupt_text: db "Interrupt received: ", 0








kernel_main:
	mov esi, welcome_text
	call write

	.loop:
		call read_character

		; write character if not null
		cmp al, 0x0
		je .loop
		call write_character

		jmp .loop

	cli
	hlt


welcome_text:    db "== Welcome ==", 0x10, 0x0