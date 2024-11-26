%include "src/kernel/ISR.asm"

%macro gate_descriptor 1
	mov eax, isr_0
    mov [IDT + %1 * 8], ax
    mov word [IDT + %1 * 8 + 2], 0x08
    mov word [IDT + %1 * 8 + 4], 0x8E00
    shr eax, 16
    mov [IDT + %1 * 8 + 6], ax
%endmacro


IDT:                         ; Interrupt Descriptor Table
	resb 8 * 0
	.end:

IDT_descriptor:
	dw (IDT.end - IDT) - 1   ; length
	dd IDT                   ; base


setup_idt:
	cli

	lidt [IDT_descriptor]

	%assign i 0
	%rep 1
		gate_descriptor i
		%assign i i+1
	%endrep

	sti
	ret
