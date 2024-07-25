IDT:
    dw 0x0          ; offset bits 0..15
    dw 0x0          ; a code segment selector in GDT or LDT
    db 0x0          ; bits 0..2 holds Interrupt Stack Table offset, rest of bits zero.
    db 0b00000000   ; gate type, dpl, and p fields
    dw 0b00000000   ; offset bits 16..31
    dq 0x0          ; offset bits 32..63
    dq 0x1          ; reserved