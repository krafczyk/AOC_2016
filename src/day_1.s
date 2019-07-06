    .section .rodata
    .text
map_failed:
    .string "Map failed!\n"
map_succeeded:
    .string "Map succeeded!\n"

    .global _start
    .text
_start:
    movq $10, %rdi
    call mem_alloc

    cmpq $0,%rax
    jne mem_success
    leaq map_failed(%rip), %rdi
    call printcstr

mem_success:

    leaq map_succeeded(%rip), %rdi
    call printcstr

    // exit sequence
    movq $60,%rax; // Syscall 60 is exit
    xorq %rdi,%rdi; // Set exit value
    syscall; // Make the syscall
