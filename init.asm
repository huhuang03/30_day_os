; save boot info


; 设置A20线，使CPU可以访问1MB以上的内存
CALL waitkbdout
MOV AL, 0xd1
OUT 0x64,AL
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
JMP pipelineflush       ; 跳转，刷新流水线

pipelineflush:
    MOV AX, 1*8         ; 设置32位可读写段
    MOV DS, AX
    MOV ES, AX
    MOV FS, AX
    MOV GS, AX
    MOV SS, AX          ; why set ss?

mem_set:
    MOV EAX, [ESI]
    ADD ESI, 4
    MOV [EDI], EAX
    ADD EDI, 4
    SUB ECX, 1
    JNZ memcpy
    RET


waitkbdout:
    IN AL,  0x64
    AND AL, 0x02
    JNZ waitkbdout
    RET

ALIGNB 16
GDT0:
    RESB 8
