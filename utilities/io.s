    .text
    .globl cstrlen
// Get the length of a zero-terminated string
// %rdi - string
// returns - %rax - length of string
cstrlen:
    movq $-1,%rax
cstrlen0:
    incq %rax
    cmpb $0,(%rdi,%rax)
    jne cstrlen0
    ret

    .text
    .globl printcstr
// print a string to the standard output
// %rdi - string
printcstr:
    // First, determine length of the string
    call cstrlen

    movq %rax,%rdx
    movq $1, %rax
    movq %rdi,%rsi
    movq $1, %rdi
    syscall
    ret
//    .text
//    .globl open
// open a file and get a file descriptor
// %rdi - string - filepath
// %rsi - string - file mode
//open:
//    movq $0x05, %rax
//    movq %rdi, %rbx

