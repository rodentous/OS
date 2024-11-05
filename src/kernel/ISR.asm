extern interrupt_handler
isr_common_stub:
	pusha

	call interrupt_handler    ; from kernel.asm

	popa
	iret



; Interrupt Service Routines
global isr_0
isr_0:
	cli                       ; disable interrupts
	; push byte 0               ; push a dummy error code (if isr0 doesn't push it's own error code)
	; push byte 0               ; push the interrupt number (0)
	jmp isr_common_stub       ; common interupt stub
	hlt

%macro isr 1
global isr_%1
isr_%1:
	cli
	; push byte 0
	; push byte %1
	jmp isr_common_stub
	hlt
%endmacro

%assign i 1
%rep 32
	isr i
	%assign i i+1
%endrep
