    .text
    .section .rodata
    .globl ioendl
ioendl:
    .string "\n"
iohexmap:
    .string "0123456789ABCDEF"
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
uis0:
    incq %rsi
    movq $0, %rdx
    div %rcx
    cmpq $0,%rax
    jne uis0
    incq %rsi; // %rsi now contains the length

    // Allocate memory
    pushq %rdi
    movq %rsi, %rdi
    pushq %rsi
    call mem_alloc
    popq %rsi
    popq %rdi

    cmpq $0,%rax
    jne uis1
    ret

uis1:
    // Now we need to set the string.
    // Save initial variable
    movq %rax,%r9; // The address of the new string
    movq %rdi,%rax; // Save the input argument as numerator
    decq %rsi; // decrease since we can't access beyond the array
    movb $0,(%r9,%rsi); // Set the 0 byte at the end of string.
    movq $10,%rcx; // Dividend
uis2:
    decq %rsi; // Decrease by one.
    movq $0,%rdx; // Zero out rdx
    div %rcx; // Divide numerator
    addq $48,%rdx; // Add ascii value for 0 to remainder.
    movb %dl,(%r9,%rsi); // Save string value at byte
    cmpq $0,%rsi
    jne uis2
    movq %r9,%rax; // Save string to return
    ret

// get a string for uint64 in hex
// %rdi - uint64 - the value
// returns - pointer to the new cstring
    .text
    .globl uinthexstr
uinthexstr:
    // Determine length of string
    movq $0,%rsi
    movq $0x10,%rcx
    movq %rdi,%rax
uihs0:
    xorq %rdx,%rdx
    div %rcx
    incq %rsi
    cmpq $0,%rax
    jne uihs0
    addq $3,%rsi; // Add 0 byte, and room for 0x in front.

    // Allocate
    movq %rdi,%r15
    movq %rsi,%r14
    movq %rsi,%rdi
    call mem_alloc

    movq %rax,%r8
    leaq iohexmap(%rip),%r9
    // Add start of string
    movb $48,(%r8)
    movb $120,1(%r8)
    movq $0x10,%rcx
    decq %r14
    movq %r15,%rax
    // Add end of string
    movb $0,(%r8,%r14)
uihs1:
    decq %r14
    xorq %rdx,%rdx
    div %rcx
    movb (%r9,%rdx), %bl
    movb %bl, (%r8,%r14)
    cmpq $2,%r14
    jne uihs1

    movq %r8,%rax
    ret


//    .text
//    .globl open
// open a file and get a file descriptor
// %rdi - string - filepath
// %rsi - string - file mode
//open:
//    movq $0x05, %rax
//    movq %rdi, %rbx

