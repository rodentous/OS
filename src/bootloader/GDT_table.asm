CODE_SEGMENT equ GDT_code - GDT_start
DATA_SEGMENT equ GDT_data - GDT_start

GDT_start:
	GDT_null:
		dw 0x0          ; base
		dw 0x0          ; limit
		db 0x0          ; ?
		db 0b00000000   ; access byte  [ present, privilege(3), type, executable, direction/conforming, readable/writable, accessed ]
		db 0b00000000   ; flags        [ granularity(3), size(2), long-mode, reserved ]
		db 0x0          ; ?
		
	GDT_code:
		dw 0xffff       ; base
		dw 0x0          ; limit
		db 0x0          ; ?
		db 0b10011010   ; access byte  [ present, privilege(3), type, executable, direction/conforming, readable/writable, accessed ]
		db 0b11001111   ; flags        [ granularity(3), size(2), long-mode, reserved ]
		db 0x0          ; ?

	GDT_data:
		dw 0xffff       ; base
		dw 0x0          ; limit
		db 0x0          ; ?
		db 0b10010010   ; access byte  [ present, privilege(3), type, executable, direction/conforming, readable/writable, accessed ]
		db 0b11001111   ; flags        [ granularity(3), size(2), long-mode, reserved ]
		db 0x0          ; ?
GDT_end:


GDT_descriptor:
	dw GDT_end - GDT_start - 1
	dd GDT_start