// Get the length of a zero-terminated string
// %rdi - string
// returns - %rax - length of string
// clobbers - %rax
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

// print a string to a file
// %rdi - uint64 - file handle
// %rsi - uint64 - length of string
// %rdx - string - the string
// returns - nothing
// clobbers - %rax, %rdx, %rsi, %rdi
    .text
    .globl fprintcstr
fprintcstr:
    xorq %rsi, %rdx
    xorq %rdx, %rsi
    xorq %rsi, %rdx
    movq $1, %rax
    syscall
    ret

// print a string to stdout
// %rdi - uint64 - length of string
// %rsi - string - the string
// returns - nothing
// clobbers - %rax, %rdx, %rsi, %rdi
    .text
    .globl printcstr
printcstr:
    movq %rsi, %rdx
    movq %rdi, %rsi
    movq $1, %rdi
    call fprintcstr
    ret

// get a string as uint64
// %rdi - uint64 - the value
// returns - pointer to the new cstring
    .text
    .globl uintstr
    // Find 'length' necessary for the string
uintstr:
    movq $1, %rsi
    movq %rdi, %rax
    movq $10, %rcx
    jp uintstrbeg
uintstrbegloop:
    incq %rsi
uintstrbeg:
    movq $0, %rdx
    div %rcx
    cmpq $0,%rax
    jne uintstrbegloop
    addq $1, %rsi
    movq %rsi, %rcx

    // Allocate memory
    movq %rcx, %rdi
    call mem_alloc

    cmp $0,%rax
    jne uintstr0
    ret

uintstr0:
    // Now we need to set the string.





//    .text
//    .globl open
// open a file and get a file descriptor
// %rdi - string - filepath
// %rsi - string - file mode
//open:
//    movq $0x05, %rax
//    movq %rdi, %rbx

