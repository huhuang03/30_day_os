section .data
    msg db 'Hello, World!',0

section .text
    global _start

_start:
    ; 系统调用：write
    mov eax, 4          ; 系统调用号（write）
    mov ebx, 1          ; 文件描述符（1：stdout）
    mov ecx, msg        ; 消息地址
    mov edx, 13         ; 消息长度
    int 0x80            ; 中断，执行系统调用

    ; 系统调用：exit
    mov eax, 1          ; 系统调用号（exit）
    xor ebx, ebx        ; 返回值0
    int 0x80            ; 中断，执行系统调用
