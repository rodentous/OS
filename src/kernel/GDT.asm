CODE_SEGMENT equ GDT.code - GDT
DATA_SEGMENT equ GDT.data - GDT

; Global Descriptor Table
GDT:
	.null:
		dw 0x0           ; limit (lower 16 bits)
        dw 0x0           ; base (lower 16 bits)
        db 0x0           ; base (bits 16-23)
        db 0b00000000    ; 1st flags and type flags
        db 0b00000000    ; 2nd flags and limit (upper 4 bits)
        db 0x0           ; base (upper 8 bits)

    .code:
		dw 0xFFFF        ; limit (lower 16 bits)
        dw 0x0           ; base (lower 16 bits)
        db 0x0           ; base (bits 16-23)
        db 0b10011010    ; 1st flags and type flags
        db 0b11001111    ; 2nd flags and limit (upper 4 bits)
        db 0x0           ; base (upper 8 bits)
		
	.data:
		dw 0x0           ; limit (lower 16 bits)
        dw 0x0           ; base (lower 16 bits)
        db 0x0           ; base (bits 16-23)
        db 0b10010010    ; 1st flags and type flags
        db 0b11001111    ; 2nd flags and limit (upper 4 bits)
        db 0x0           ; base (upper 8 bits)
    
    .progc:
        dw 0xFFFF        ; limit (lower 16 bits)
        dw 0x0           ; base (low 16 bits)
        db 0x10          ; base (bits 16-23)
        db 0b10011010    ; 1st flags and type flags (access byte)
        db 0b11001111    ; 2nd flags and limit (upper 4 bits)
        db 0x0           ; base (upper 8 bits)

    .progd:
        dw 0xFFFF        ; limit (lower 16 bits)
        dw 0x0           ; base (low 16 bits)
        db 0x10          ; base (bits 16-23)
        db 0b10010010    ; 1st flags and type flags (access byte)
        db 0b11001111    ; 2nd flags and limit (upper 4 bits)
        db 0x0           ; base (upper 8 bits)

	.end:

GDT_descriptor:
	dw (GDT.end - GDT) - 1  ; length
	dd GDT                  ; base