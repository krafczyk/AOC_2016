    .section .rodata
    .text
map_failed0:
    .string "Map failed!\n"
map_succeeded:
    .string "Map succeeded!\n"

    .global _start
    .text
_start:
    movq $10, %rdi
    call mem_alloc

    cmpq $0,%rax
    je map_failed

    movq 0, %rsi
    movq $65, %rcx
    movq %rdi, %r8
    subq $1, %r8
loop0:
    movq %rsi, %rdx
    addq %rcx, %rdx
    movb %dl, (%rax,%rsi)
    incq %rsi
    cmpq %r8,%rsi
    jne loop0
    movb $0, (%rax,%rsi)
    jp mem_success

map_failed:
    cmpq $0,%rax
    jne mem_success
    leaq map_failed0(%rip), %rdi
    call printcstr

    ret

mem_success:

    movq %rax, %rdi
    call printcstr

    // exit sequence
    movq $60,%rax; // Syscall 60 is exit
    xorq %rdi,%rdi; // Set exit value
    syscall; // Make the syscall
