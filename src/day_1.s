    .section .rodata
    .text
data:
    .string "Hello World!\n"
    .text
    .global _start
_start:
    leaq data(%rip), %rdi
    call printcstr

    movq $5,%rax
    ret
