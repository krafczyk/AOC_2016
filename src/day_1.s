    .section .rodata
    .text
map_failed0:
    .string "Map failed!\n"
map_succeeded:
    .string "Map succeeded!\n"
    .global _start
    .text
_start:
    movq $2000212,%rdi
    call uintstr

    movq %rax,%rdi
    call cstrlen
    movq %rax,%rsi

    pushq %rdi
    pushq %rsi

    xorq %rsi,%rdi
    xorq %rdi,%rsi
    xorq %rsi,%rdi
    call printcstr

    leaq ioendl(%rip),%rsi
    movq $2,%rdi
    call printcstr

    popq %rsi
    popq %rdi
    call mem_free

    // exit sequence
    movq $60,%rax; // Syscall 60 is exit
    xorq %rdi,%rdi; // Set exit value
    syscall; // Make the syscall
