extern interrupt_handler
isr_common_stub:
	pusha

	call interrupt_handler    ; from kernel.asm

	popa
	iret


; Interrupt Service Routines
%macro isr 1
global isr_%1
isr_%1:
	cli
	; push byte 0
	; push byte %1
	mov al, %1
	jmp isr_common_stub

	sti
	hlt
%endmacro


%assign i 0
%rep 20
	isr i
	%assign i i+1
%endrep


%macro gate_descriptor 1
	mov eax, isr_%1
    mov [IDT + %1 * 8], ax
    mov word [IDT + %1 * 8 + 2], 0x08
    mov word [IDT + %1 * 8 + 4], 0x8E00
    shr eax, 16
    mov [IDT + %1 * 8 + 6], ax
%endmacro


IDT:                         ; Interrupt Descriptor Table
	.end:

IDT_descriptor:
	dw (IDT.end - IDT) - 1   ; length
	dd IDT                   ; base


setup_idt:
	cli

	lidt [IDT_descriptor]

	%assign i 0
	%rep 5
		gate_descriptor i
		%assign i i+1
	%endrep

	sti
	ret
