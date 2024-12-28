[bits 32]


global _start
_start:
	mov byte [color.foreground], WHITE
	mov byte [color.background], BLACK

	times 5 call new_line

	mov  esi, kernel_text
	call write

	call setup_gdt

	call setup_idt
	
	int 0
	int 1
	int 2
	int 3
	int 4

	; in  ax, 0x60
	; cmp ax, 0x0

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



%include "src/kernel/GDT.asm"
%include "src/kernel/VGA.asm"

kernel_text:    db "== Kernel Setup ==", 0x10, 0
interrupt_text: db "Interrupt received: ", 0

%include "src/kernel/IDT.asm"
