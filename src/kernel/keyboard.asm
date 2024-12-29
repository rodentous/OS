; ==read key==
; return al: ASCII for key
read_key:
    in  ax, 0x60

    ret