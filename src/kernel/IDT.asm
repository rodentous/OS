ISR:
    isr_1:
        pusha
        cli

        popa
        iret
times 256-($-$$) dw 0

IDT:
    dw ISR              ; offset - IST entry point
    dw GDT_code         ; GDT code segment
    db 0b00000000       ; IST offset(3) - zeroes since unused, (5)
    db 0b00001001       ; gate type(4) - for long mode, (1), dpl(2) - privilege levels that can use interrupt, present(1)
    dw 0x0              ; offset bits
    ; dq 0x0              ; offset bits
    ; dq 0x0              ; reserved
IDT_end:

IDT_descriptor:
	dw IDT_end - IDT - 1     ; length
	dd IDT                   ; base