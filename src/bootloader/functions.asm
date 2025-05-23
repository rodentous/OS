disk_read_error:  db "Disk read error", 0x0D, 0x0A, 0
enable_A20_error: db "Failed to enable A20", 0x0D, 0x0A, 0


; ==clear screen==
enter_text_mode:
    push ax

    mov ah, 0x0
	mov al, 0x3
	int 0x10

    pop ax
    ret


; ==write string on screen==
; esi: string pointer
write:
    push ax
    push esi

    mov ah, 0x0E

    .loop:
        mov al, [esi]

        cmp al, 0
        je  .return

        int 0x10

        inc esi
        jmp .loop

    .return:
        pop esi
        pop ax
        ret


; ==load sectors into [es:bx] from disk==
; dl: drive number
; dh: number of sectors to load
disk_load:
    pusha
    push dx

	mov bx, KERNEL           ; [es:bx] - pointer to buffer where kernel is

    mov ah, 0x02             ; 0x02 = 'read'
    mov al, dh               ; sectors amount  [ 0x01  ..  0x80 ]
    mov cl, 0x02             ; sector          [ 0x01  ..  0x11 ] ( 0x01 = boot, 0x02 = first available )
    mov ch, 0x00             ; cylinder        [ 0x0   .. 0x3FF ] ( upper 2 bits in 'cl' )
    mov dh, 0x00             ; head number     [ 0x0   ..   0xF ]
	mov dl, dl               ; disk number     [ 0 = floppy, 1 = floppy2, 0x80 = hdd, 0x81 = hdd2 ]

    int 0x13                 ; BIOS interrupt
    jc  .disk_error          ; error is in carry bit

    pop dx
    cmp al, dh               ; check if number of sectors read is correct
    jne .disk_error

	jmp .return

	.disk_error:
        mov  esi, disk_read_error
        call write
		hlt

	.return:
		popa
		ret




; ==disable wraparound after A19 address line==
enable_A20:
    ; returns if A20 is enabled
    .check_A20:
        call check_A20
        cmp  ax, 1
        je   .return

        mov esi, enable_A20_error
        call write

    ; try:
    in  al, 0xEE
    jmp .check_A20 ; check

    ; try:
    call enable_A20_fast
    jmp  .check_A20 ; check

    ; try:
    call enable_A20_keyboard_controller
    jmp  .check_A20 ; check

    .return:
        ret


; ==chack whether A20 is enbled==
; return ax: is A20 enabled?
check_A20:
	pushf
	push si
	push di
	push ds
	push es
	cli

	mov ax, 0x0000           ; [0x0000:0x0500] - [ds:si]
	mov ds, ax
	mov si, 0x0500

	mov ax, 0xFFFF           ; [0xFFFF:0x0510] - [es:di]
	mov es, ax
	mov di, 0x0510

    ; save old values:
	mov al,  [ds:si]
	mov byte [.below_MB], al
	mov al,  [es:di]
	mov byte [.above_MB], al

	mov ah, 1
	mov byte [ds:si], 0
	mov byte [es:di], 1
	mov al,  [ds:si]
	cmp al,  [es:di]         ; return if byte at address 0x0500 != byte at address 0x100500
	jne .return
	dec ah

    .return:
        ; restore old values:
        mov al, [.below_MB]
        mov [ds:si], al
        mov al, [.above_MB]
        mov [es:di], al

        shr ax, 8

        sti
        pop es
        pop ds
        pop di
        pop si
        popf
        ret

    .below_MB:	db 0
    .above_MB:	db 0




; two ways to enable A20:
[bits 32]
enable_A20_keyboard_controller:
    push ax
    cli

    call .A20_wait
    mov  al, 0xAD
    out  0x64, al

    call .A20_wait
    mov  al, 0xD0
    out  0x64, al

    call .A20_wait_2
    in   al, 0x60
    push eax

    call .A20_wait
    mov  al, 0xD1
    out  0x64, al

    call .A20_wait
    pop  eax
    or   al, 2
    out  0x60, al

    call .A20_wait
    mov  al, 0xAE
    out  0x64, al

    call .A20_wait

    sti
    pop ax
    ret

    .A20_wait:
        in   al, 0x64
        test al, 2
        jnz  .A20_wait
        ret

    .A20_wait_2:
        in   al, 0x64
        test al, 1
        jz   .A20_wait_2
        ret


[bits 16]
enable_A20_fast:
    in   al, 0x92
    test al, 2
    jnz  .return

    or   al, 2
    and  al, 0xFE
    out  0x92, al

    .return:
        ret