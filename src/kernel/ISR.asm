extern interrupt_handler
isr_common_stub:
	pusha

	call interrupt_handler    ; from kernel.asm

	popa
	iret



; Interrupt Service Routines
isr_0:
	cli
	jmp isr_common_stub
	
	;cli                      ; disable interrupts
	;push byte 0              ; push a dummy error code (if isr0 doesn't push it's own error code)
	;push byte 0              ; push the interrupt number (0)
	;jmp isr_common_stub      ; common interupt stub

;%macro isr 1
;isr_%1:
;	cli
;    ;push byte 0
;    ;push byte %1
;    jmp isr_common_stub
;%endmacro

;%assign i 1
;%rep 255
;	isr i
;	%assign i i+1
;%endrep
