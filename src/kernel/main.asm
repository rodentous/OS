kernel_main:
	mov byte [color.foreground], WHITE
	mov byte [color.background], LIGHT_BLUE

	call clear_screen
	mov esi, welcome_text
	call write
	call read_character
	call clear_screen

	.loop:
		call input_character
		jmp .loop

	cli
	hlt


welcome_text:
db 0x0A,\
"            *      ,MMM8&&&.            *      Welcome to CATOS", 0x0A,\
"                  MMMM88&&&&&    .             Press any key to continue", 0x0A,\
"                 MMMM88&&&&&&&                ", 0x0A,\
"     *           MMM88&&&&&&&&                ", 0x0A,\
"                 MMM88&&&&&&&&                ", 0x0A,\
"                 'MMM88&&&&&&'                ", 0x0A,\
"                   'MMM8&&&'      *           ", 0x0A,\
"          |\___/|     /\___/\                 ", 0x0A,\
"          )     (     )    ~( .               ", 0x0A,\
"         =\     /=   =\~    /=                ", 0x0A,\
"           )===(       ) ~ (                  ", 0x0A,\
"          /     \     /     \                 ", 0x0A,\
"          |     |     ) ~   (                 ", 0x0A,\
"         /       \   /     ~ \                ", 0x0A,\
"         \       /   \~     ~/                ", 0x0A,\
"  _/\_/\_/\__  _/_/\_/\__~__/_/\_/\_/\_/\_/\_ ", 0x0A,\
"  |  |  |  |( (  |  |  | ))  |  |  |  |  |  | ", 0x0A,\
"  |  |  |  | ) ) |  |  |//|  |  |  |  |  |  | ", 0x0A,\
"  |  |  |  |(_(  |  |  (( |  |  |  |  |  |  | ", 0x0A,\
"  |  |  |  |  |  |  |  |\)|  |  |  |  |  |  | ", 0x0A,\
"  |  |  |  |  |  |  |  |  |  |  |  |  |  |  | ", 0x0A,\
0x0A, 0x0
