BITS 32

VGA_WIDTH equ 80
VGA_HEIGHT equ 25


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
	
	mov esi, title_text
	call write
	
	; mov esi, prompt_text
	; .loop:
	; 	call write
	; 	times 10 call sleep
	; 	jmp .loop

	jmp $


sleep:
	push eax
	mov eax, 0xFFFFFFF

	.loop:
		dec eax
		cmp eax, 0
		jg  .loop

	pop eax
	ret


; return cx: VGA buffer id
get_vga_buffer_id:
	push dx
	xor ecx, ecx             ; reset ecx
	
	mov dx, [cursor]
	add cl, dl

	.multiply:               ; multiply lines by VGA width
		cmp dh, 0
		jle .return
		
		add cx, VGA_WIDTH

		dec dh
		jmp .multiply
		
	.return:
		shl cx, 1            ; multiply by two since each entry takes two bytes

		pop dx
		ret


set_vga_cursor:              ; i dont know how this code works yet
	pusha
	
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


; al: ASCII character
set_character:
	push ax
	push cx
	; VGA entry is represented as 16-bit word:
	; character byte: [ code point x8 ]
	; attribute byte: [ foreground x4, background x3, blink ]

	mov ah, [color.background]
	shl ah, 4                ; background color takes left 4 bits
	or  ah, [color.foreground]

	; al: character byte
	; ah: attribute byte
	call get_vga_buffer_id   ; ecx: buffer id
	mov word [0xB8000 + ecx], ax

	pop cx
	pop ax
	ret


clear:
	push cx
	push edx
	xor cx, cx                ; reset cx
	xor edx, edx              ; reset edx
	
	.loop:
		cmp cx, VGA_WIDTH * VGA_HEIGHT
		jge .return          ; break if reached last character

		mov dx, cx
		shl dx, 1            ; every entry takes 2 bytes

		mov word [0xB8000 + edx], 0
		
		inc cx
		jmp .loop

	.return:
		pop edx
		pop cx


scroll:
	pusha
	xor cx, cx               ; reset cx
	
	.loop:
		cmp cx, VGA_HEIGHT * VGA_WIDTH
		jge .return

		mov dx, cx           ; character position
		shl dx, 1            ; every entry takes 2 bytes
		
		mov bx, cx
		add bx, VGA_WIDTH    ; position of character below
		shl bx, 1            ; every entry takes 2 bytes

		; swap character with character below
		mov ax, word [0xB8000 + ebx]
		mov word [0xB8000 + edx], ax

		inc cx
		jmp .loop
	
	.return:
		popa
		ret


; al: ASCII character
write_character:
	push cx
	mov cx, [cursor]

	cmp cl, VGA_WIDTH        ; new line if last column
	jge .new_line
	cmp al, 0x10             ; new line if line feed character
	je  .new_line

	call set_character       ; write character

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
		pop cx
		ret


; esi: string pointer
write:
	pusha

	.loop:
		mov al, [esi]        ; load character
		cmp al, 0            ; terminate if null character
		je  .return

		call write_character
		call set_vga_cursor
		call sleep

		inc esi              ; next character
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


title_text: db "Welcome to fake_OS", 0x10, 0
prompt_text: db 0x10, "user ~ > ", 0