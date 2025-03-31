[extern isr_handler]
isr_common_stub:
	call isr_handler    ; from kernel.asm

	sti
	iret


[extern irq_handler]
irq_common_stub:
	call irq_handler    ; from kernel.asm

	sti
	iret




; Interrupt Service Routine
%macro isr 1
	[global isr_%1]
	isr_%1:
		cli
		; push byte 0
		; push byte %1
		mov al, %1
		jmp isr_common_stub
%endmacro

%macro isre 1 ; same but with error code
	[global isr_%1]
	isr_%1:
		cli
		; push byte %1
		mov al, %1
		jmp isr_common_stub
%endmacro

	isr 0   ; Divide By Zero Exception
	isr 1   ; Debug Exception
	isr 2   ; Non Maskable Interrupt Exception
	isr 3   ; Int 3 Exception
	isr 4   ; INTO Exception
	isr 5   ; Out of Bounds Exception
	isr 6   ; Invalid Opcode Exception
	isr 7   ; Coprocessor Not Available Exception
	isre 8  ; Double Fault Exception                 (With Error Code!)
	isr  9  ; Coprocessor Segment Overrun Exception
	isre 10 ; Bad TSS Exception                      (With Error Code!)
	isre 11 ; Segment Not Present Exception          (With Error Code!)
	isre 12 ; Stack Fault Exception                  (With Error Code!)
	isre 13 ; General Protection Fault Exception     (With Error Code!)
	isre 14 ; Page Fault Exception                   (With Error Code!)
	isr 15  ; Reserved Exception
	isr 16  ; Floating Point Exception
	isr 17  ; Alignment Check Exception
	isr 18  ; Machine Check Exception
	isr 19  ; Reserved
	isr 20  ; Reserved
	isr 21  ; Reserved
	isr 22  ; Reserved
	isr 23  ; Reserved
	isr 24  ; Reserved
	isr 25  ; Reserved
	isr 26  ; Reserved
	isr 27  ; Reserved
	isr 28  ; Reserved
	isr 29  ; Reserved
	isr 30  ; Reserved
	isr 31  ; Reserved

; Interrupt Request handler
%macro irq 1
	[global isr_%1]
	isr_%1:
		cli
		; push byte 0
		; push byte %1
		mov al, %1-31
		jmp irq_common_stub
%endmacro

	irq 32
	irq 33
	irq 34
	irq 35
	irq 36
	irq 37
	irq 38
	irq 39
	irq 40
	irq 41
	irq 42
	irq 43
	irq 44
	irq 45
	irq 46
	irq 47
	irq 48




; Interrupt Descriptor Table
IDT:
.end:

IDT_descriptor:
	dw (IDT.end - IDT) - 1   ; length
	dd IDT                   ; base


%macro gate_descriptor 1
	mov eax, isr_%1
    mov [IDT + %1 * 8], ax
    mov word [IDT + %1 * 8 + 2], 0x08
    mov word [IDT + %1 * 8 + 4], 0x8E00
    shr eax, 16
    mov [IDT + %1 * 8 + 6], ax
%endmacro




%macro outb 2
	mov ax, %2
	out %1, ax
%endmacro

; initialize IDT
setup_idt:
	cli

	lidt [IDT_descriptor]

	%assign i 0
	%rep 48
		gate_descriptor i
		%assign i i+1
	%endrep

	sti
	ret
