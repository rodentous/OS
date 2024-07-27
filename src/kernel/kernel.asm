[bits 32]

global main
main:
	mov byte [color.foreground], WHITE
	mov byte [color.background], BLACK

	int 0x0

	mov esi, title_text
	call write
	
	jmp $


sleep:
	push eax
	mov eax, 0xfffffff

	.loop:
		dec eax
		cmp eax, 0
		jg  .loop

	pop eax
	ret

%include "src/kernel/VGA_functions.asm"

title_text: db "Welcome to not an OS,", 0x10, 0
prompt_text: db 0x10, "user ~ > ", 0