%macro map 2
    cmp al, %1
    jne .%1
    mov al, %2
    ret
    .%1:
%endmacro


; ==convert input to character==
; return al: ASCII character
read_character:
    in  al, 0x60

    map 0x10, 'Q'
    map 0x11, 'W'
    map 0x12, 'E'
    map 0x13, 'R'
    map 0x14, 'T'
    map 0x15, 'Y'
    map 0x16, 'U'
    map 0x17, 'I'
    map 0x18, 'O'
    map 0x19, 'P'
    map 0x1E, 'A'
    map 0x1F, 'S'
    map 0x20, 'D'
    map 0x21, 'F'
    map 0x22, 'G'
    map 0x23, 'H'
    map 0x24, 'J'
    map 0x25, 'K'
    map 0x26, 'L'
    map 0x2C, 'Z'
    map 0x2D, 'X'
    map 0x2E, 'C'
    map 0x2F, 'V'
    map 0x30, 'B'
    map 0x31, 'N'
    map 0x32, 'M'

    map 0x1C, 0x10

    mov al, 0x0

    ret
