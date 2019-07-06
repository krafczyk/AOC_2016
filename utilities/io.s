    .section .rodata
    .text
out:
    .string "len: %llu\n"
    .text
    .globl printcstr
// print a string to the standard output
// %rdi - string
printcstr:
    // First, determine length of the string
    movq $-1, %rdx
sloop0:
    incq %rdx
    cmpq $0,(%rdi,%rdx)
    jne sloop0

    decq %rdx

    //leaq out(%rip), %rdi
    //movq %rdx, %rsi
    //movq $0, %rax
    //call printf@PLT

    //ret

    movq $0x01, %rax
    movq %rdi, %rsi
    movq $0x01, %rdi
    int $0x80
    ret
//    .text
//    .globl open
// open a file and get a file descriptor
// %rdi - string - filepath
// %rsi - string - file mode
//open:
//    movq $0x05, %rax
//    movq %rdi, %rbx

