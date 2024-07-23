[org 0x7c00]
KERNEL equ 0x1000


; set all segments to 0
xor ax, ax
mov es, ax
mov ds, ax


; read disk
mov dh, 2                       ; number of sectors
mov dl, dl                      ; disk
call disk_load


; enter text mode (clears screen)
mov ah, 0x0
mov al, 0x3
int 0x10


; switch to protected mode
cli                             ; disable interupts
lgdt [GDT_descriptor]           ; load GDT descriptor

CODE_SEGMENT equ GDT_code - GDT_start
DATA_SEGMENT equ GDT_data - GDT_start

mov eax, cr0
or eax, 1
mov cr0, eax                    ; set PE (protection enable) in cr0 (control register 0)

jmp CODE_SEGMENT:protected_mode ; start protected mode
jmp $




%include "src/bootloader/GDT_table.asm"
%include "src/bootloader/read_disk.asm"




; protected mode
[bits 32]
protected_mode:
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
	mov esi, ERROR
	call write
	jmp $


ERROR: db "FAILED TO INITIALIZE KERNEL", 0

; set last 2 bytes to aa55
times 510-($-$$) db 0
dw 0xaa55
