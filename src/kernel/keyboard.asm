; ==read input from keyboard==
; return al: scancode
read_input:
    ; wait for PS/2
    in al, 0x64
    and al, 0b00000001
    cmp al, 0x1
    jne read_input

    ; read
    in al, 0x60

    ret


%macro map 2
    cmp al, %1
    jne .%1
    mov al, %2
    jmp .return
    .%1:
%endmacro


; ==convert input to character==
; al: scancode
; return al: ASCII character
get_ascii_character:
    map 0x10, 'q'
    map 0x11, 'w'
    map 0x12, 'e'
    map 0x13, 'r'
    map 0x14, 't'
    map 0x15, 'y'
    map 0x16, 'u'
    map 0x17, 'i'
    map 0x18, 'o'
    map 0x19, 'p'
    map 0x1E, 'a'
    map 0x1F, 's'
    map 0x20, 'd'
    map 0x21, 'f'
    map 0x22, 'g'
    map 0x23, 'h'
    map 0x24, 'j'
    map 0x25, 'k'
    map 0x26, 'l'
    map 0x2C, 'z'
    map 0x2D, 'x'
    map 0x2E, 'c'
    map 0x2F, 'v'
    map 0x30, 'b'
    map 0x31, 'n'
    map 0x32, 'm'

    map 0x39, ' '      ; space
    map 0x1C, 0x0A     ; new line
    map 0x0E, 0x08     ; backspace

    mov al, 0x0

    .return:
        ret
