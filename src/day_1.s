    .section .rodata
    .text
map_failed0:
    .string "Map failed!\n"
map_succeeded:
    .string "Map succeeded!\n"
    .global _start
    .text
_start:
    movq $2120,%rdi
    pushq %rdi
    call uintstr

    movq %rax,%rdi
    call cstrlen
    movq %rax,%rsi

    pushq %rdi
    pushq %rsi

    call printcstr

    leaq ioendl(%rip),%rdi
    movq $2,%rsi
    call printcstr

    popq %rsi
    popq %rdi

    call mem_free

    popq %rdi
    call uinthexstr

    movq %rax,%rdi
    call cstrlen
    movq %rax,%rsi

    pushq %rdi
    pushq %rsi

    call printcstr

    leaq ioendl(%rip),%rdi
    movq $2,%rsi
    call printcstr

    popq %rsi
    popq %rdi
    call mem_free

    // exit sequence
    movq $60,%rax; // Syscall 60 is exit
    xorq %rdi,%rdi; // Set exit value
    syscall; // Make the syscall
