// Get the nth argument starting from 0.
// %rdi - pointer on stack to start of argument section, should point to argc.
// %rsi - argument number starting from 0.
// returns - %rax - length of string
// clobbers - no others
    .text
    .globl getargn
getargn:
    cmpq (%rdi),%rsi
    ja ganf

    incq %rsi
    movq (%rdi,%rsi,8),%rax
    ret

ganf:
    movq $0,%rax
    ret
