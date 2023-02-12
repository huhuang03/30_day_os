ORG 7c00h
JMP entry
DB 0x90
DB "HELLOIPL"   ; 启动去的名称可以是任意的字符串（8字节）
DW 512          ; 每个扇区的大小，fixed
DB 1            ; 簇的大小，fixed
DW 1            ; FAT的起始位置（一般从第一个扇区开始）
DB 2            ; FAT的个数，fixed
DW 224          ; 根目录的大小（一般设置为224项）
DW 2880         
DB 0xf0         
DW 9
DW 18
DW 2
DD 0
DD 2880
DB 0, 0, 0x29
DD 0xffffffff
DB "HELLO-OS   "    ; len. 11
DB "FAT12   "       ; len.  8
RESB 18

entry:
   xor ax, ax    ; make sure ds is set to 0
   mov ds, ax
   cld
   ; start putting in values:
   mov ah, 2h    ; int13h function 2
   mov al, 63    ; we want to read 63 sectors
   mov ch, 0     ; from cylinder number 0
   mov cl, 2     ; the sector number 2 - second sector (starts from 1, not 0)
   mov dh, 0     ; head number 0
   xor bx, bx    
   mov es, bx    ; es should be 0
   mov bx, 7e00h ; 512bytes from origin address 7c00h
   int 13h
   jc error
   jmp success     ; jump to the next sector

read_loop:
    jmp success
    jmp 0xc200

success:
    mov ax, success_msg
    mov si, ax
    jmp putLoop

error:
    mov ax, error_msg
    mov si, ax

putLoop:
    mov al, [si]    ; just check '\0'
    cmp al, 0
    je fi           ; this is the dnd
    ; when ah = 0xe
    ; AL = Character, BH = Page Number, BL = Color (only in graphic mode)
    mov ah, 0xe		; ah is the color
    int 0x10		; 0x10 is put a char to screen, ah, is the color, al is the charactor
    add si, 1
    jmp putLoop

fi:
    hlt
    jmp fi

success_msg:
    db 0xa, 0xa
    db "some success value"
    db 0xa, 0xa, 0x0

error_msg:
    db 0xa, 0xa
    db "write floopy error"
    db 0xa, 0xa

; the book is $
; but pelase see https://stackoverflow.com/questions/14928741/whats-the-real-meaning-of-in-nasm
; in nasm is ($-$$)
RESB 0x1fe-($-$$)
; 启动软盘。软盘每512个字节为一个扇区
; 当第一扇区的最后两个字节为0x55, 0xaa的时候，计算会认为此软盘是一个启动软盘
; 否则就不认为是。
DB 0x55, 0xaa

; you real need this?
DB 0xf0, 0xff, 0xff, 0x00, 0x00, 0x00, 0x00, 0x00
RESB 4600
DB 0xf0, 0xf0, 0xf0, 0x00, 0x00, 0x00, 0x00, 0x00
RESB 1469432