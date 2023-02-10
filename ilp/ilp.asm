;; where did you load?
JMP entry	; will compile to jump 0x4e(code is :0xeb, 0x4e), 0x4e is the entry pos. jump 0x4e is a relative jump
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

; ok, read floopy 0-1 to 10-18
mov es, ax			; read dest memory location
mov ch, 0		; 柱面
mov dh, 0		; 磁头
mov cl, 2		; 扇区
mov ah, 2		; 读盘
mov al, 1		; 1个扇区
mov bx, 0		; clear bx?
mov bl, 0		; A驱动器（第一个驱动器）
int 0x13		; 磁盘读写方法
jc error		; carry is has error

error:
    ;; we know that this is load at loacation of 0x7c00. so we can just add 0x7c00
    mov ax, error_msg
    add ax, 0x7c00
    mov si, ax

putLoop:
    mov al, [si]    ; just check '\0'
    cmp al, 0
    je fi           ; this is the dnd
    ; when ah = 0xe
    ; AL = Character, BH = Page Number, BL = Color (only in graphic mode)
    mov ah, 0xe		; ah is the color
    int 0x10		; 0x10 is put a char to screen, bx, is the color, al is the charactor
    add si, 1
    jmp putLoop


fi:
    hlt
    jmp fi

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
; DB 0xf0, 0xff, 0xff, 0x00, 0x00, 0x00, 0x00, 0x00
; RESB 4600
; DB 0xf0, 0xf0, 0xf0, 0x00, 0x00, 0x00, 0x00, 0x00
; RESB 1469432
