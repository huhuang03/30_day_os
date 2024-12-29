extern _foo

.text:
    global bar

bar:
    mov eax, 4          ; 系统调用号（write）
    mov ebx, 1          ; 文件描述符（1：stdout）
    mov ecx, msg        ; 消息地址
    mov edx, 11         ; 消息长度
    int 0x80            ; 中断，执行系统调用
    ret
    call _foo


msg:
    db "hello bar", 0x0a, 0
