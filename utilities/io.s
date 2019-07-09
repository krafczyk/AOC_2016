    .text
    .section .rodata
    .globl ioendl
ioendl:
    .string "\n"
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
// %rsi - string - the string
// %rdx - uint64 - length of string
// returns - nothing
// clobbers - %rax, %rdx, %rsi, %rdi
    .text
    .globl fprintcstr
fprintcstr:
    movq $1, %rax
    syscall
    ret

// print a string to stdout
// %rdi - string - the string
// %rsi - uint64 - length of string
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
    movq $0, %rsi
    movq %rdi, %rax
    movq $10, %rcx
uintstrbegloop:
    incq %rsi
    movq $0, %rdx
    div %rcx
    cmpq $0,%rax
    jne uintstrbegloop
    incq %rsi; // %rsi now contains the length

    // Allocate memory
    pushq %rdi
    movq %rsi, %rdi
    pushq %rsi
    call mem_alloc
    popq %rsi
    popq %rdi

    cmpq $0,%rax
    jne uintstr0
    ret

uintstr0:
    // Now we need to set the string.
    // Save initial variable
    movq %rax,%r9; // The address of the new string
    movq %rdi,%rax; // Save the input argument as numerator
    decq %rsi; // decrease since we can't access beyond the array
    movb $0,(%r9,%rsi); // Set the 0 byte at the end of string.
    movq $10,%rcx; // Dividend
uintstr1:
    decq %rsi; // Decrease by one.
    movq $0,%rdx; // Zero out rdx
    div %rcx; // Divide numerator
    addq $48,%rdx; // Add ascii value for 0 to remainder.
    movb %dl,(%r9,%rsi); // Save string value at byte
    cmpq $0,%rsi
    jne uintstr1
    movq %r9,%rax; // Save string to return
    ret
//    .text
//    .globl open
// open a file and get a file descriptor
// %rdi - string - filepath
// %rsi - string - file mode
//open:
//    movq $0x05, %rax
//    movq %rdi, %rbx

