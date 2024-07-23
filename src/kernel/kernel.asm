BITS 32

VGA_WIDTH equ 80
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
	mov byte [color.foreground], VGA_WHITE
	mov byte [color.background], VGA_BLACK
	mov esi, string
	
	.loop:
		call write
		jmp .loop
	jmp $


; return cx: VGA buffer id
get_vga_buffer_id:
	push dx
	xor cx, cx              ; reset cx ??????
	
	mov cl, [cursor.column] ; load column in cl ??????
	mov dl, [ cursor.line ]
	
	.multiply:              ; multiply lines by VGA width
		cmp dl, 0
		jle .return
		
		add cx, VGA_WIDTH   ; add line to cx ??????

		dec dl
		jmp .multiply
		
	.return:
		shl cx, 1           ; multiply by two since each entry takes two bytes

		pop dx
		ret


; al: ASCII character
set_character_at:
	pusha

	; VGA entry is represented as 16-bit word:
	; character byte: [ code point x8 ]
	; attribute byte: [ foreground x4, background x3, blink ]

	mov bl, [color.background]
	mov bh, [color.foreground]
	; or  bl, 0b10000000 ; this was supposed to set blink charcter (doesn't work)
	shl bl, 4
	or  bl, bh

	mov ah, bl

	call get_vga_buffer_id

	; set entry in VGA buffer:
	; al: character byte
	; ah: attribute byte
	; ecx: buffer id
	mov word [0xB8000 + ecx], ax

	popa
	ret


sleep:
	push eax

	mov eax, 0xFFFFFFF

	.loop:
		dec eax
		cmp eax, 0
		jg  .loop

	pop eax
	ret


scroll:
	pusha
	mov ax, 0

	.loop:

		mov cx, ax
		shl cx, 1

		; cmp ax, VGA_WIDTH
		; jle .loop

		cmp ax, VGA_HEIGHT * VGA_WIDTH
		jge .return

		mov bx, word [0xB8000 + ecx + VGA_WIDTH + VGA_WIDTH] ; WHY?????????????????????
		mov word [0xB8000 + ecx], bx

		inc ax
		jmp .loop
	
	.return:
		popa
		ret


; al: ASCII character
write_character:
	push cx
	mov cx, [cursor]	
	
	cmp al, 0x10      ; new line if line feed character
	je .new_line

	cmp cl, VGA_WIDTH ; new line if last column
	jge .new_line

	call set_character_at

	inc cl            ; next column
	jmp .return
	
	.new_line:
		call sleep

		cmp ch, VGA_HEIGHT
		jge .scroll   ; scroll if last line

		mov cl, 0     ; reset column
		inc ch        ; next line
		jmp .return
	
	.scroll:
		call scroll
		mov cl, 0
		jmp .return

	.return:
		mov [cursor], cx
		pop cx
		ret


; esi: string pointer
write:
	pusha

	.loop:
		mov al, [esi] ; load character
		cmp al, 0     ; terminate if null character
		je  .return

		call write_character

		inc esi       ; next character
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

string:
	db "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.", 0x10
	db 0
