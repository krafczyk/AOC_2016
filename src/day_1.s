    .section .rodata
    .text
inputid:
    .string "-i"
    .global _start
    .text
_start:
    movq %rsp,%rdi
    movq $inputid,%rsi
    call getargid
    cmpq $0,%rax
    je ex
    movq %rax,%rdi
    call cstrlen
    movq %rax,%rsi
    call printcstr

ex:
    // exit sequence
    movq $60,%rax; // Syscall 60 is exit
    xorq %rdi,%rdi; // Set exit value
    syscall; // Make the syscall
