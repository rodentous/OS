[bits 32]


[global _start]
_start:
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

	mov  esi, interrupt_request_text
	call write

	call write_number
	call new_line

	popa
	ret



%include "src/kernel/IDT.asm"
%include "src/kernel/VGA.asm"
%include "src/kernel/keyboard.asm"
%include "src/kernel/main.asm"


interrupt_text: db "Interrupt received: ", 0
interrupt_request_text: db "Interrupt requested: ", 0
