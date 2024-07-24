[bits 16]
[org 0x7c00]
KERNEL equ 0x1000

switch_to_protected_mode:
	; reset all segments to 0
	xor ax, ax
	mov es, ax
	mov ds, ax

	; read disk
	mov dh, 2                             ; number of sectors
	mov dl, dl                            ; disk
	call disk_load

	call enter_text_mode                  ; to clear screen

	; enable A20:
	call enable_A20

	; switch to protected mode:
	cli                                   ; disable interupts
	lgdt [GDT_descriptor]                 ; load GDT descriptor

	mov eax, cr0
	or  eax, 1
	mov cr0, eax                          ; set PE (protection enable) in cr0 (control register 0)

	jmp CODE_SEGMENT:start_protected_mode ; start protected mode
	
	; in case of an error:
	mov esi, boot_error
	call write
	jmp $


%include "src/bootloader/GDT_table.asm"
%include "src/bootloader/functions.asm"


; protected mode
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
	mov esi, boot_error
	jmp $



boot_error: db "Failed to enable protected mode", 0x0d, 0x0a, 0

; set last 2 bytes to aa55
times 510-($-$$) db 0
dw 0xaa55
