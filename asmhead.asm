;; this is the head of asm, which inital 32 bit and other stuff
;; 这个程序将会被加载到sector2，由sector1的ipl加载

; need put palce here, because it's unique
LEDS    EQU 0xff1
VMODE   EQU 0xff2
SCRNX   EQU 0xff4
SCRNY   EQU 0xff6
VRAM    EQU 0xff8
BOTPAK  EQU 0x00280000
DSKCAC  EQU 0x00100000

; set vga and save info to somewhere
MOV AL, 0x13
MOV AH, 0x0
INT 0x10
MOV BYTE [VMODE], 8
MOV WORD [SCRNX], 320
MOV WORD [SCRNY], 200
MOV DWORD [VRAM], 0x000a0000

; check has key pressed in key buffer and save to somewhere
MOV AH, 0x2
INT 0x16
MOV [LEDS], AL  ; al = 0, no key pressed, al != 0 has key pressed

; 屏幕中断处理器（即停止响应终端）
MOV AL, 0xff
OUT 0x21, AL    ; 端口 0x21 是主 8259A PIC 的中断屏蔽寄存器（IMR，Interrupt Mask Register）。 主 PIC 的 IRQ0-IRQ7 被屏蔽。
NOP
OUT 0xa1, AL    ; 端口 0xA1 是从 8259A PIC 的中断屏蔽寄存器。从 PIC 的 IRQ8-IRQ15 被屏蔽。
CLI ; 清除中断标志位（IF，Interrupt Flag），禁止处理器响应外部硬件中断。即使 PIC中断未屏蔽，处理器也不会响应中断。禁止处理器响应中断

; 设置A20线，使CPU可以访问1MB以上的内存
; 历史原因，键盘控制器8042输出端口 A20开启
CALL waitkbdout
MOV AL, 0xd1
OUT 0x64,AL ; make keyboard begein listen in 0x60
CALL waitkbdout
mov AL, 0xdf    ; 启用A20线
OUT 0x60, AL
call waitkbdout


; 进入保护模式
[INSTRSET "i486p"]
LGDT [GDTR0]
MOV EAX, CR0
AND EAX, 0x7fffffff     ; 将CR0寄存器的bit31清0（禁用分页）
OR EAX, 0x1             ; 将bit0设置为1（启用保护模式）
MOV CR0, EAX

JMP _main

; JMP pipelineflush       ; 跳转，刷新流水线
; 不知道在做什么
; pipelineflush:
;     MOV AX, 1*8
;     MOV DS, AX
;     MOV ES, AX
;     MOV FS, AX
;     MOV GS, AX
;     MOV SS, AX

; ;; copy bootpack
; ; where did you go??
; MOV ESI, bootpack
; MOV EDI, BOTPAK ; why copy to 0x00280000, how did you load
; MOV ECX, 512*1024/4     ; why * 1024 / 4
; CALL memcpy

; 等待真正编译的时候再来看下这个代码
; ;; copy floppy
; MOV ESI, 0x7c00
; MOV EDI, DESKCAC
; MOV ECX, 512 / 4    ; why copy 512/4 byte??
; CALL memcpy

;; 启动bootpack
MOV EBX, BOTPAK
MOV ECX, [EBX + 16]
ADD ECX, 3
SHR ECX, 4
JZ skip

mem_set:
    MOV EAX, [ESI]
    ADD ESI, 4
    MOV [EDI], EAX
    ADD EDI, 4
    SUB ECX, 1
    JNZ memcpy
    RET

waitkbdout:
;; 等待键盘输入缓存区为空，即等待键盘输入缓存区可写。
;; 例如：在发送键盘初始化命令、设置 LED 灯状态、或者调整键盘模式时，确保键盘控制器的输入缓冲区是空的。
    IN AL,  0x64
    AND AL, 0x02
    JNZ waitkbdout  ; jnz measn bit2(al) != 0, means 输入缓存区有数据。
    RET

ALIGNB 16
GDT0:
    RESB 8
    DW 0xffff, 0x0000, 0x9200, 0x00cf
    DW 0xffff, 0x0000, 0x9a28, 0x0047
    DW 0

GDTR0:
    DW 8*3 - 1  ; GDT 的大小在 LGDT 指令中需要写为 “总字节数 - 1”。这是 x86 架构的要求，因为 LGDT 的操作数格式规定了此行为
    DD GDT0

bootpack: