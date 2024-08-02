CODE_SEGMENT equ GDT.code - GDT
DATA_SEGMENT equ GDT.data - GDT

GDT:
	.null:
		dw 0x0          ; base
		dw 0x0          ; limit
		db 0x0          ; ?
		db 0b00000000   ; access byte  [ present, privilege(3), type, executable, direction/conforming, readable/writable, accessed ]
		db 0b00000000   ; flags        [ granularity(3), size(2), long-mode, reserved ]
		db 0x0          ; ?
		
	.code:
		dw 0xffff       ; base
		dw 0x0          ; limit
		db 0x0          ; ?
		db 0b10011010   ; access byte  [ present, privilege(3), type, executable, direction/conforming, readable/writable, accessed ]
		db 0b11001111   ; flags        [ granularity(3), size(2), long-mode, reserved ]
		db 0x0          ; ?

	.data:
		dw 0xffff       ; base
		dw 0x0          ; limit
		db 0x0          ; ?
		db 0b10010010   ; access byte  [ present, privilege(3), type, executable, direction/conforming, readable/writable, accessed ]
		db 0b11001111   ; flags        [ granularity(3), size(2), long-mode, reserved ]
		db 0x0          ; ?
	.end:

GDT_descriptor:
	dw GDT.end - GDT - 1    ; length
	dd GDT                  ; base
