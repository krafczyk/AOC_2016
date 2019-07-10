    .section .rodata
    .text
str0:
    .string " arguments\n"
    .global _start
    .text
_start:
    movq (%rsp),%r15; // Save the number of arguments: argc
    movq %r15,%rdi
    call uintstr
    movq %rax,%rdi
    call cstrlen
    movq %rax,%rsi
    pushq %rdi
    pushq %rsi
    call printcstr
    popq %rsi
    popq %rdi
    call mem_free
    movq $str0,%rdi
    call cstrlen
    movq %rax,%rsi
    call printcstr

    movq $0,%r14; // Start loop counter
l0:
    incq %r14
    movq (%rsp,%r14,8),%rdi
    call cstrlen
    movq %rax,%rsi
    call printcstr
    movq $ioendl,%rdi
    call cstrlen
    movq %rax,%rsi
    call printcstr
    cmp %r15,%r14
    jne l0

    // exit sequence
    movq $60,%rax; // Syscall 60 is exit
    xorq %rdi,%rdi; // Set exit value
    syscall; // Make the syscall
