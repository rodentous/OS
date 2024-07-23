; load 'dh' sectors from drive 'dl' into ES:BX
disk_load:
    pusha
    push dx

	mov bx, KERNEL      ; [es:bx] pointer to buffer where kernel is

    mov ah, 0x02        ; 0x02 = 'read'
    mov al, dh          ; sectors amount  [ 0x01  ..  0x80 ]
    mov cl, 0x02        ; sector          [ 0x01  ..  0x11 ] ( 0x01 = boot, 0x02 = first available )
    mov ch, 0x00        ; cylinder        [ 0x0   .. 0x3FF ] ( upper 2 bits in 'cl' )
    mov dh, 0x00        ; head number     [ 0x0   ..   0xF ]
	mov dl, dl          ; disk number     [ 0 = floppy, 1 = floppy2, 0x80 = hdd, 0x81 = hdd2 ]

    int 0x13            ; BIOS interrupt
    jc .disk_error      ; error is in carry bit

    pop dx
    cmp al, dh          ; check if number of sectors read is correct
    jne .sectors_error

	jmp .return

	.disk_error:
        mov bx, [DISK_ERROR]
        call write
		jmp $

	.sectors_error:
        mov bx, [SECTORS_ERROR]
        call write
		jmp $
    
	.return:
		popa
		ret


; esi: pointer to string
write:
    pusha

    mov ah, 0x0e

    .loop:
        mov al, [esi]

        cmp al, 0
        je .return

        int 0x10

        inc esi
        jmp .loop

    .return:
        popa
        ret

DISK_ERROR: db "Disk read error", 0x0d, 0x0a, 0
SECTORS_ERROR: db "Incorrect number of sectors read", 0x0d, 0x0a, 0