[org 0x7c00]

KERNEL equ 0x1000

switch_to_protected_mode:
	; reset all segments:
	xor ax, ax
	mov es, ax
	mov ds, ax

	call enter_text_mode          ; clear screen
	mov esi, boot_text
	call write

	; read disk:
	mov dh, 2                     ; number of sectors
	mov dl, dl                    ; disk
	call disk_load
	
	call enable_A20               ; disable wraparound after A19 address line
	lgdt [GDT_descriptor]         ; load GDT descriptor
	cli                           ; disable interupts

	; set PE (protection enable) bit in cr0 (control register 0):
	mov eax, cr0
	or  eax, 1
	mov cr0, eax

	; start protected mode
    jmp CODE_SEGMENT:start_protected_mode
	
	hlt

%include "src/bootloader/GDT.asm"
%include "src/bootloader/functions.asm"


; 32 bit protected mode:
[bits 32]
start_protected_mode:
	mov ax, DATA_SEGMENT
	mov ds, ax
	mov ss, ax
	mov es, ax
	mov fs, ax
	mov gs, ax

	; setup stack
	mov ebp, 0x90000
	mov esp, ebp

	jmp KERNEL
	hlt


boot_text: db "Booting... ", 0

; set last 2 bytes to aa55
times 510-($-$$) db 0
dw 0xaa55
