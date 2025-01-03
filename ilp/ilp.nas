;;; fucntion: load other content of the floppy after bios load first sector for us

;; the bios load this ipl to 0x7c00
;; and a secotr is 0x200 size, so the target is 0x7e00

;;; C(cylinder)柱面 H磁头 S(sector)
;;; s has 18
;;; cylinder has 18
;;; and it's in this the order if we use a file to monitor this floppy
;; floppy is C0-H0-S0 ~ C0-H0-S18 ~ C0-H1-S0 ~ C0-H1-S18 ~ C1-H0-S1
;; 80 cylinder 扇区index从1开始
;; for now I can noly read 40 cylinder

%define TARGET 0X7e00

ORG 0x7c00

JMP load
nop
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

load:
	mov bx, TARGET
	shr bx, 4
	mov es, bx
	mov ch, 0
	mov cl, 2
	mov dh, 0
	jmp load_loop

load_loop:				
	mov dl, 0					; A驱动器
	mov bx, 0 					; read floop to [es:bx]
	mov al, 1					; num of sector to read
	mov ah, 2					; read
	int 0x13
	jc error					; carry if something error

next:
	push bx
	mov bx, es
	add bx, 0x20
	mov es, bx
	pop bx

	;; secotr循环
	add cl, 1
	cmp cl, 19
	jb load_loop
	mov cl, 1

	;; 磁头循环
	add dh, 1
	cmp dh, 2
	jb load_loop				; dh < 2, load again

	;; 柱面循环
	mov dh, 0
	add ch, 1
	; call show_info
	cmp ch, 39				; check 柱面
	; cmp ch, 40				; check 柱面
	jb load_loop				 
	; jmp _hlt
	jmp TARGET

error:
	mov si, err_msg
	jmp put_loop

err_msg:
	DB 0x0a,"load sector wrong", 0x0a
	DB 0

msg:
	DB 0xa,0xa
	DB "Hello, world"
	DB 0xa
	DB 0

show_info:
 ;; show ch and ah
	push ax

	mov al, ch
	add al, 'A'
	mov ah, 0x0e
	int 0x10

	mov al, dh
	add al, '0'
	mov ah, 0x0e
	int 0x10

	mov al, cl
	add al, 'a'
	mov ah, 0x0e
	int 0x10

	mov al, ' '
	int 0x10
	pop ax
	ret
;; end show ch and ah

put_loop:
	mov al, [si]				; al = the char to show
	add si, 1
	cmp al, 0
	JE _hlt
	mov ah, 0xe					; ah = 0xe show char
	INT 0x10
	jmp put_loop

_hlt:
	hlt
	jmp _hlt

TIMES 512-2-($-$$) DB 0
DB 0x55, 0xaa		; magic word that is a ilp