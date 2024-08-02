section .text

%macro isr 1
global isr_%1
isr_%1:
	cli
	pusha

	jmp $
	
	popa
	iret
%endmacro

%macro idt_entry 1
dw isr_%1           ; offset - IST entry point
dw 0x0              ; GDT code segment
db 0b00000000       ; IST offset(3) - zeroes since unused, (5)
db 0b00001001       ; gate type(4) - for long mode, (1), dpl(2) - privilege levels that can use interrupt, present(1)
dw 0x0              ; offset bits
; dq 0x0              ; offset bits
; dq 0x0              ; reserved
%endmacro
	


setup_idt:
	%assign n 0
	%rep 256
		isr n
		%assign n n+1
	%endrep
	lidt [IDT_descriptor]
	ret


IDT:
	%assign n 0
	%rep 256
		idt_entry n
		%assign n n+1
	%endrep
IDT_end:

IDT_descriptor:
	dw IDT_end - IDT - 1     ; length
	dd IDT                   ; base
