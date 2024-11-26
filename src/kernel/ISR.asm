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
	jmp isr_common_stub
	hlt
%endmacro


%assign i 0
%rep 1
	isr i
	%assign i i+1
%endrep
