VGA_WIDTH equ 80
VGA_HEIGHT equ 25

; colors
BLACK equ 0

BLUE equ 1
GREEN equ 2
CYAN equ 3
RED equ 4
MAGENTA equ 5
BROWN equ 6

LIGHT_GREY equ 7
DARK_GREY equ 8

LIGHT_BLUE equ 9
LIGHT_GREEN equ 10
LIGHT_CYAN equ 11
LIGHT_RED equ 12
LIGHT_MAGENTA equ 13
LIGHT_BROWN equ 14

WHITE equ 15




; ==convert position to id of VGA buffer entry==
; cx: position
; return cx: VGA buffer id
get_vga_buffer_id:
	push dx

	mov dh, ch               ; save line number in dh
	xor ch, ch               ; reset ch

	.multiply:               ; multiply lines by VGA width
		cmp dh, 0
		jle .return
		
		add cx, VGA_WIDTH

		dec dh
		jmp .multiply
		
	.return:
		shl cx, 1            ; multiply by two since each entry is two bytes long

		pop dx
		ret



; ==set cursor position==
set_vga_cursor:              ;  idk how this works
	pusha
	
	mov cx, [cursor]
	call get_vga_buffer_id
	shr cx, 1
	mov bx, cx

	mov dx, 0x03D4
	mov al, 0x0F
	out dx, al

	inc dl
	mov al, bl
	out dx, al

	dec dl
	mov al, 0x0E
	out dx, al

	inc dl
	mov al, bh
	out dx, al

	popa
	ret


; ==set character at given position==
; al: ASCII character
; cx: position
set_character:
	push ax
	push cx

	; VGA entry is represented as 16-bit word:
	; character byte: [ code point x8 ]
	; attribute byte: [ foreground x4, background x3, blink ]

    ; move both colors in ah:
	mov ah, [color.background]
	shl ah, 4
	or  ah, [color.foreground]

	call get_vga_buffer_id       ; ecx: VGA buffer id

	; al: character byte
	; ah: attribute byte
	; ecx: VGA buffer id
	mov word [0xB8000 + ecx], ax ; set character

	pop cx
	pop ax
	ret


; ==clear whole screen==
clear:
	push cx
	push edx
	xor cx, cx                ; reset cx
	xor edx, edx              ; reset edx
	
	.loop:
		cmp cx, VGA_WIDTH * VGA_HEIGHT
		jge .return           ; break if reached last character

		mov dx, cx
		shl dx, 1             ; every entry is 2 bytes

		; reset character
		mov word [0xB8000 + edx], 0
		
		inc cx
		jmp .loop

	.return:
		pop edx
		pop cx


; ==move every character on screen up==
scroll:
	pusha
	xor cx, cx               ; reset cx
	
	.loop:
		cmp cx, VGA_HEIGHT * VGA_WIDTH
		jge .return

		mov dx, cx           ; character position
		shl dx, 1            ; every entry is 2 bytes
		
		mov bx, cx
		add bx, VGA_WIDTH    ; position of character below
		shl bx, 1            ; every entry is 2 bytes

		; swap character with character below
		mov ax, word [0xB8000 + ebx]
		mov word [0xB8000 + edx], ax

		inc cx
		jmp .loop
	
	.return:
		popa
		ret


; ==new line==
new_line:
	push cx
	mov cx, [cursor]

	cmp ch, VGA_HEIGHT-1     ; scroll screen up if last line
	jge .scroll

	mov cl, 0                ; reset column
	inc ch                   ; next line
	jmp .return

	.scroll:
		mov cl, 0
		call scroll
		jmp .return

	.return:
		mov [cursor], cx     ; set cursor position
		call set_vga_cursor
		pop cx
		ret


; ==write character at cursor position==
; al: ASCII character
write_character:
	push cx
	mov cx, [cursor]

	cmp cl, VGA_WIDTH        ; new line if last column
	jge .new_line
	cmp al, 0x10             ; new line if special line feed "line feed" character
	je  .new_line

	call set_character       ; set character

	inc cl                   ; next column
	jmp .return
	
	.new_line:
		cmp ch, VGA_HEIGHT-1 ; scroll screen up if last line
		jge .scroll

		mov cl, 0            ; reset column
		inc ch               ; next line
		jmp .return
	
	.scroll:
		mov cl, 0
		call scroll
		jmp .return

	.return:
		mov [cursor], cx     ; set cursor position
		call set_vga_cursor
		pop cx
		ret


; ==write string==
; esi: string pointer
write:
	pusha

	.loop:
		mov al, [esi]        ; load character
		cmp al, 0            ; terminate if null character
		je  .return

		call write_character

		inc esi              ; next character
		jmp .loop

	.return:
		popa
		ret


; ==write decimal nubmer==
; al: number
write_number:
	pusha
	
	.loop:
		cmp al, 10
		jl  .return

		xor ah, ah
		mov bl, 10
		div bl

		mov dl, al

		add ah, '0'
		mov al, ah
		call write_character
		
		mov al, dl

		jmp .loop

	.return:
		add al, '0'
		call write_character
		popa
		ret




; current color
color:
	.foreground: db 0
	.background: db 0

; cursor position
cursor: 
	.column: db 0
	.line: db 0
