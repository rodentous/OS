[extern isr_handler]
isr_common:
	call write_number
	call new_line

	popa
    sti
    iret

[extern irq_handler]
irq_common:
	call write_number
	call new_line

	popa
    sti
    iret




; Interrupt Service Routines
%macro ISR 1            ; exceptions
[global isr_%1]
isr_%1:
	cli
	pusha
	mov al, %1
	jmp isr_common
%endmacro

%macro ISRE 1           ; exceptions with error codes
[global isr_%1]
isr_%1:
	cli
	pusha
	mov al, %1
	jmp isr_common
%endmacro

%macro IRQ 1            ; for hardware IRQs
[global irq_%1]
irq_%1:
	cli
	pusha
	mov al, %1
	jmp irq_common
%endmacro

; Exceptions without error codes
ISR 0   ; Divide-by-zero
ISR 1   ; Debug
ISR 2   ; NMI
ISR 3   ; Breakpoint
ISR 4   ; Overflow
ISR 5   ; Bound Range Exceeded
ISR 6   ; Invalid Opcode
ISR 7   ; Device Not Available
ISRE 8  ; Double Fault
ISR  9  ; Coprocessor Segment Overrun
ISRE 10 ; Invalid TSS
ISRE 11 ; Segment Not Present
ISRE 12 ; Stack-Segment Fault
ISRE 13 ; General Protection Fault
ISRE 14 ; Page Fault
ISR 15  ; Reserved
ISR 16  ; Reserved
ISR 17  ; Reserved
ISR 18  ; Reserved
ISR 19  ; Reserved
ISR 20  ; Reserved
ISR 21  ; Reserved
ISR 22  ; Reserved
ISR 23  ; Reserved
ISR 24  ; Reserved
ISR 25  ; Reserved
ISR 26  ; Reserved
ISR 27  ; Reserved
ISR 28  ; Reserved
ISR 29  ; Reserved
ISR 30  ; Reserved
ISR 31  ; Reserved
; IRQ handlers
IRQ 0   ; Timer
IRQ 1   ; Keyboard
IRQ 2   ; Cascade (PIC2)
IRQ 3   ; COM2
IRQ 4   ; COM1
IRQ 5   ; LPT2
IRQ 6   ; Floppy Disk
IRQ 7   ; LPT1
IRQ 8   ; CMOS RTC
IRQ 9   ; Legacy SCSI/NIC
IRQ 10  ; SCSI/NIC
IRQ 11  ; SCSI/NIC
IRQ 12  ; PS/2 Mouse
IRQ 13  ; FPU
IRQ 14  ; Primary ATA
IRQ 15  ; Secondary ATA



; Interrupt Descriptor Table
IDT:
.end:

IDT_descriptor:
	dw (IDT.end - IDT) - 1   ; length
	dd IDT                   ; base


%macro IDT_ENTRY 2
	mov eax, %2
    mov [IDT + %1 * 8], ax
    mov word [IDT + %1 * 8 + 2], 0x08
    mov word [IDT + %1 * 8 + 4], 0x8E00
    shr eax, 16
    mov [IDT + %1 * 8 + 6], ax
%endmacro

; initialize IDT
setup_idt:
	cli

	lidt [IDT_descriptor]

	IDT_ENTRY 0, isr_0
	IDT_ENTRY 1, isr_1
	IDT_ENTRY 2, isr_2
	IDT_ENTRY 3, isr_3
	IDT_ENTRY 4, isr_4
	IDT_ENTRY 5, isr_5
	IDT_ENTRY 6, isr_6
	IDT_ENTRY 7, isr_7
	IDT_ENTRY 8, isr_8
	IDT_ENTRY 9, isr_9
	IDT_ENTRY 10, isr_10
	IDT_ENTRY 11, isr_11
	IDT_ENTRY 12, isr_12
	IDT_ENTRY 13, isr_13
	IDT_ENTRY 14, isr_14
	IDT_ENTRY 15, isr_15
	IDT_ENTRY 16, isr_16
	IDT_ENTRY 17, isr_17
	IDT_ENTRY 18, isr_18
	IDT_ENTRY 19, isr_19
	IDT_ENTRY 20, isr_20
	IDT_ENTRY 21, isr_21
	IDT_ENTRY 22, isr_22
	IDT_ENTRY 23, isr_23
	IDT_ENTRY 24, isr_24
	IDT_ENTRY 25, isr_25
	IDT_ENTRY 26, isr_26
	IDT_ENTRY 27, isr_27
	IDT_ENTRY 28, isr_28
	IDT_ENTRY 29, isr_29
	IDT_ENTRY 30, isr_30
	IDT_ENTRY 31, isr_31
	IDT_ENTRY 32, irq_0
	IDT_ENTRY 33, irq_1
	IDT_ENTRY 34, irq_2
	IDT_ENTRY 35, irq_3
	IDT_ENTRY 36, irq_4
	IDT_ENTRY 37, irq_5
	IDT_ENTRY 38, irq_6
	IDT_ENTRY 39, irq_7
	IDT_ENTRY 40, irq_8
	IDT_ENTRY 41, irq_9
	IDT_ENTRY 42, irq_10
	IDT_ENTRY 43, irq_11
	IDT_ENTRY 44, irq_12
	IDT_ENTRY 45, irq_13
	IDT_ENTRY 46, irq_14
	IDT_ENTRY 47, irq_15

	sti
	ret
