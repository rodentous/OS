main:
	pusha

	mov byte [color.foreground], WHITE
	mov byte [color.background], BLUE

	call clear_screen
	mov esi, welcome_text
	call write
	call read_input
	call clear_screen

	.loop:
		mov esi, prompt_text
		call write
		call input

		mov esi, input_text
		jmp .execute_command

		jmp .loop

	.execute_command:
		mov edi, exit_command
		call compare_strings
		cmp bl, 0x1
		je .return

		mov edi, meow_command
		call compare_strings
		cmp bl, 0x1
		je .meow

		mov edi, clear_command
		call compare_strings
		cmp bl, 0x1
		je .clear

		mov edi, help_command
		call compare_strings
		cmp bl, 0x1
		je .help

		cmp byte [input_text], 0x0
		je .loop

		mov byte [color.foreground], LIGHT_RED
		mov esi, unknown_command_text
		call write
		mov esi, input_text
		call write
		call new_line
		mov byte [color.foreground], WHITE

		jmp .loop

	.meow:
		mov esi, input_text
		call write
		call new_line
		jmp .loop

	.clear:
		call clear_screen
		jmp .loop

	.help:
		mov esi, help_text
		call write
		jmp .loop

	.return:
		popa
		cli
		hlt


; ==get input as string==
; input stored in input_text
input:
	pusha

	.clear:
		mov edi, input_text    ; destination pointer (address of buffer)
		mov ecx, 1000          ; number of bytes to clear (100)
		xor eax, eax           ; fill value (0x0)
		rep stosb              ; repeat: store AL (0) at [EDI++], ECX times

	mov esi, input_text

	.loop:
		call read_input
		call get_ascii_character

		cmp al, 0x0
		je .loop

		cmp al, 0x0A
		je .return

		cmp al, 0x08
		je .erase

		mov byte [esi], al

		call write_character
		inc esi
		jmp .loop

	.erase:
		cmp esi, input_text
		jle .loop
		call erase_character
		dec esi
		mov byte [esi], 0x0
		jmp .loop

	.return:
		call new_line
		popa
		ret


; ==check if two strings are identical==
; return bl: 1 if yes 0 if not
compare_strings:
	push esi
	push edi
	push ax

	xor bl, bl

	.loop:
		mov al, byte [esi]
		cmp al, byte [edi]
		jne .return

		cmp byte [esi], 0x0
		je .return_true

		inc esi
		inc edi
		jmp .loop

	.return_true:
		inc bl
		jmp .return

	.return:
		pop ax
		pop edi
		pop esi
		ret

prompt_text: db "$ ", 0x0
exit_command: db "exit", 0x0
meow_command: db "meow", 0x0
clear_command: db "clear", 0x0
help_command: db "help", 0x0
help_text: db "CASH (CAt SHell) usage:", 0x0A, "    exit - terminate cash", 0x0A, "    meow - print last entered command (its always meow lol)", 0x0A, "    clear - clear screen", 0x0A, "    help - print this text", 0x0A, 0x0
unknown_command_text: db "unknown command: ", 0x0
input_text: times 1000 db 0x0

welcome_text:
db 0x0A, \
"     .___________________________________________.", 0x0A, \
"     |                  CAT OS                   |", 0x0A, \
"     |     .-------------------------------.     |", 0x0A, \
"     |     |                     PRESS     |     |", 0x0A, \
"     |     |          |\___/|     ANY      |     |", 0x0A, \
"     |     |          )     (     KEY      |     |", 0x0A, \
"     |     |         =\     /=             |     |", 0x0A, \
"     |     |           )===(               |     |", 0x0A, \
"     |     |          /     \              |     |", 0x0A, \
"     |     |          |     |              |     |", 0x0A, \
"     |     |         /       \             |     |", 0x0A, \
"     |     |         \       /             |     |", 0x0A, \
"     |     '__________\__  _/______________'     |", 0x0A, \
"     |                  ( (                      |", 0x0A, \
"     '___________________) )_____________________'", 0x0A, \
"   _______:-------------(_(------------------:_______", 0x0A, \
"  |  []  [][][][] [][][][] [][][][] [][][]  == ===== |", 0x0A, \
"  |                                                  |", 0x0A, \
"  |   [][][][][][][][][][][][][][]_ [][][] [][][][]  |", 0x0A, \
"  |   [_][][][][][][][][][][][][]| |[][][] [][][]||  |", 0x0A, \
"  |   []  [][][][][][][][][][][][__|       [][][]||  |", 0x0A, \
"  |   [__] [][][][][][][][][][][___]  []   [][][]||  |", 0x0A, \
"  |   [_]  [_][_____________][_] [_][][][] [__][]||  |", 0x0A, \
"  '--------------------------------------------------'", 0x0