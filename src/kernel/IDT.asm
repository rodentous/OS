isr_common_stub:
	pusha

	call isr_handler     ; from kernel.asm

	popa
	iret


global isr_entry_0
isr_entry_0:
	cli                 ; disable interrupts
	push byte 0         ; push a dummy error code (if isr0 doesn't push it's own error code)
	push byte 0         ; push the interrupt number (0)
	jmp isr_common_stub

%macro isr_entry 1
	global isr_entry_%1

	isr_entry_%1:
		cli
	    push byte 0
	    push byte %1
	    jmp isr_common_stub
%endmacro

%assign i 1
%rep 31
	isr_entry i
	%assign i i+1
%endrep



setup_idt:
	lidt [IDT_descriptor]
	ret



%macro idt_entry 1
	dw isr_entry_%1     ; offset - corresponding isr entry
	dw 0x08             ; GDT code segment
	db 0b00000000       ; IST offset(3) - zeroes since unused, ???(5)
	db 0b00001001       ; gate type(4) - for long mode, ???(1), dpl(2) - privilege levels that can use interrupt, present(1)
	db 0x00             ; offset bits
	db 0x00             ; reserved
%endmacro

IDT:                    ; Interrupt Descriptor Table
	%assign n 0
	%rep 32
		idt_entry n
		%assign n n+1
	%endrep
IDT_end:

IDT_descriptor:
	dw IDT_end - IDT - 1     ; length
	dd IDT                   ; base
