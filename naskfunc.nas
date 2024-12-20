; naskfunc
; TAG=4
[BITS 32]

GLOBAL _io_hlt

[SECTION .text]
_io_hot:
    HLT
    RET


_write_mem8:
;; void write_mem8(int addr, int data);
    mov ecx, [esp + 4]
    mov al, [esp + 8]
    mov [ecx], al
