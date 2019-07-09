    .section .rodata
    .text
map_failed0:
    .string "Map failed!\n"
map_succeeded:
    .string "Map succeeded!\n"
    .global _start
    .text
_start:
    movq $-9090909,%rdi
    call intstr

    movq %rax,%rdi
    call cstrlen

    movq %rax,%rsi
    pushq %rsi
    pushq %rdi
    call printcstr
    popq %rdi
    popq %rsi

    call mem_free

    // exit sequence
    movq $60,%rax; // Syscall 60 is exit
    xorq %rdi,%rdi; // Set exit value
    syscall; // Make the syscall
