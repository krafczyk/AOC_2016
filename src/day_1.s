    .section .rodata
    .text
hello:
    .string "Hello World!\n"

    .global _start
    .text
_start:
    leaq hello(%rip), %rdi
    call printcstr

    // exit sequence
    movq $60,%rax; // Syscall 60 is exit
    xorq %rdi,%rdi; // Set exit value
    syscall; // Make the syscall

