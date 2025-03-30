[bits 32]


[global _start]
_start:
	mov byte [color.foreground], WHITE
	mov byte [color.background], BLACK

	times 5 call new_line

	mov  esi, setup_text
	call write

	call setup_idt

	mov esi, IDT_text
	call write

	call new_line

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


setup_text:    db "== Kernel Setup ==", 0x10, 0
IDT_text:       db "-IDT", 0x10, 0
interrupt_text: db "Interrupt received: ", 0








kernel_main:
	mov esi, welcome_text
	call write

	.loop:
		mov bl, al
		call read_character
		cmp bl, al
		je .loop

		cmp al, 0x0
		je .loop

		call write_character
		jmp .loop

	cli
	hlt


welcome_text:    db "== Welcome ==", 0x10, 0x0