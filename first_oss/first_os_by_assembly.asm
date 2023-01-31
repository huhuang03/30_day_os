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

entry:
	mov ax, hello_msg
	add ax, 0x7c00
	mov si, ax	; any better idea to write a relocateable code?

putloop:	
	;; [si] is the char*
	mov al, [si]
	cmp al, 0
	je fi
	mov ah, 0xe		; ah is the color
	int 0x10		; 0x10 is put a char to screen, bx, is the color, al is the charactor
	add si, 1
	jmp putloop

fi:
	hlt			; pause cpu
	jmp fi

hello_msg:	
	db 0xa, 0xa		; I can't figure out why 0xa is new line for now
	db "hello simple os"
	db 0xa
	db 0

; the book is $
; but pelase see https://stackoverflow.com/questions/14928741/whats-the-real-meaning-of-in-nasm
; in nasm is ($-$$)
RESB 0x1fe-($-$$)

; 启动软盘。软盘每512个字节为一个扇区
; 当第一扇区的最后两个字节为0x55, 0xaa的时候，计算会认为此软盘是一个启动软盘
; 否则就不认为是。
DB 0x55, 0xaa


DB 0xf0, 0xff, 0xff, 0x00, 0x00, 0x00, 0x00, 0x00
RESB 4600
DB 0xf0, 0xf0, 0xf0, 0x00, 0x00, 0x00, 0x00, 0x00
RESB 1469432
