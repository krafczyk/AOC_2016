// Get the length of a zero-terminated string
// %rdi - string
// returns - %rax - length of string
// clobbers - no others
    .text
    .globl cstrlen
cstrlen:
    movq $-1,%rax
cstrlen0:
    incq %rax
    cmpb $0,(%rdi,%rax)
    jne cstrlen0
    incq %rax
    ret

// Compare two c strings
// %rdi - string - String A
// %rsi - string - String B
// returns - %rax - 1 if equal, 0 if not.
// clobbers - %rbx, %rcx
    .text
    .globl cstrcmp
cstrcmp:
    movq $-1,%rbx
.p2align 5,,10
.p2align 4
cscpl:
    incq %rbx
    movb (%rdi,%rbx),%cl
    cmpb %cl,(%rsi,%rbx)
    jne cscpf
    cmpb $0,%cl
    jne cscpl

cscps:
    movq $1,%rax
    ret

cscpf:
    movq $0,%rax
    ret
