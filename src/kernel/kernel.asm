BITS 32

VGA_WIDTH equ 79
VGA_HEIGHT equ 20

VGA_BLACK equ 0
VGA_BLUE equ 1
VGA_GREEN equ 2
VGA_CYAN equ 3
VGA_RED equ 4
VGA_MAGENTA equ 5
VGA_BROWN equ 6
VGA_LIGHT_GREY equ 7
VGA_DARK_GREY equ 8
VGA_LIGHT_BLUE equ 9
VGA_LIGHT_GREEN equ 10
VGA_LIGHT_CYAN equ 11
VGA_LIGHT_RED equ 12
VGA_LIGHT_MAGENTA equ 13
VGA_LIGHT_BROWN equ 14
VGA_WHITE equ 15


global main
main:
	mov byte [color.foreground], 1
	mov byte [color.background], 0
	mov esi, string
	
	call write

	jmp $


; al: ASCII character
set_character_at:
	pusha
	; color
	mov bl, [color.background]
	mov bh, [color.foreground]

	shl bl, 4
	or  bl, bh

	; position
	push ax

	mov cx, [cursor]
	mov ax, VGA_WIDTH
	mul ch
	add cl, ch
	
	pop ax
	shl cx, 1

	; set
	mov [0xB8000 + ecx], al
	mov [0xB8001 + ecx], bl

	popa
	ret


; al: ASCII character
write_character:
	push cx
	
	mov cx, [cursor]

	call set_character_at
	call sleep

	cmp cl, VGA_WIDTH
	jge .new_line

	inc cl
	jmp .return
	
	.new_line:
		inc byte [color.foreground]
		mov cl, 0
		inc ch
		jmp .return
	
	.return:
		mov [cursor], cx

		pop cx
		ret


; esi: string pointer
; return dx: length
get_string_length:
	push ax
	push esi
	
	mov dx, 0

	.loop:
		mov al, [esi] ; load character
		cmp al, 0 ; null character found
		je  .return

		inc esi ; next character
		inc dx ; increment length

		jmp .loop

	.return:
		pop esi
		pop ax
		ret


; esi: string pointer
write:
	pusha
	
	call get_string_length

	.loop:
		mov al, [esi] ; load character
		call write_character
		
		dec dx
		cmp dx, 0 ; out of length
		jle .return

		inc esi ; next character
		jmp .loop

	.return:
		popa
		ret



color:
	.foreground: db 0
	.background: db 0

cursor: 
	.column: db 0
	.line: db 0

string: db "01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890AAAAAAAAAA12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890AAAAAAAAAA123456789012345678901234567890123456789", 0