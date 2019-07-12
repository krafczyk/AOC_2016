    .section .rodata
    .text
strerr0:
    .string "Unexpected character!\n"
strerr1:
    .string "Overflow while converting!\n"

// Helper function to free a c string
// %rdi - string
    .text
    .globl freecstr
freecstr:
    call cstrlen
    movq %rax,%rsi
    call mem_free
    ret

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

// Concatenate two c strings, allocates the new string dynamically
// %rdi - string - String a
// %rsi - string - String b
// returns - %rax - new string concatenated
// clobbers - %rdi, %rsi, %rbx, %rcx, %rax, %r8, %r9, %r10
    .text
    .globl strcat
strcat:
    // Compute the length of the strings
    call cstrlen
    movq %rax,%rcx
    movq %rdi,%r8
    movq %rsi,%rdi
    call cstrlen
    // Add up the two lengths, decrease by one.
    addq %rax,%rcx
    decq %rcx
    
    // Allocate memory for the new string
    pushq %rdi; // String B
    pushq %r8; // String A
    movq %rcx,%rdi
    call mem_alloc

    popq %rbx; // Load rbx with String A
    movq $0,%rsi
    movq $0,%rdi
    movq $0,%r8
    jmp scl1
scl0:
    movq $1,%r8
    popq %rbx // Load rbx with String B
    movq $0,%rdi
scl1:
    cmpb $0,(%rbx,%rdi)
    je scl2
    movb (%rbx,%rdi),%dl
    movb %dl,(%rax,%rsi)
    incq %rdi
    incq %rsi
    jmp scl1

scl2:
    cmpq $0,%r8
    je scl0
    // Load last element of string with 0
    movb $0,(%rax,%rsi)
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

// get a string as int64
// %rdi - int64 - the value
// returns - pointer to the new cstring
    .text
    .globl intstr
intstr:
    movq $0,%r14; // Save whether or not this number is negative
    cmpq $0,%rdi
    jb is0
    negq %rdi
    movq $1,%r14
is0:
    // %rdi now contains the 'positive' version of the argument
    movq %rdi,%r15; // Save the positive argument
    movq %rdi,%rax
    movq $0,%rsi
    movq $10,%rcx
is1:
    incq %rsi
    xorq %rdx,%rdx
    div %rcx
    cmpq $0,%rax
    jne is1
    incq %rsi
    
    cmpq $0,%r14
    je is2
    incq %rsi
is2:
    pushq %rsi; // Save length of string
    // Allocate memory
    movq %rsi,%rdi
    call mem_alloc
    movq %rax,%r8

    // Set first element of string to '-' if its negative.
    cmpq $0,%r14
    je is3
    movb $45,(%r8)
is3:
    popq %rsi; // Recover string length
    decq %rsi
    // Set the last element of the string to 0.
    movb $0,(%r8,%rsi)
    // Initialize division loop
    movq %r15,%rax
    movq $10,%rcx
is4:
    decq %rsi
    xorq %rdx,%rdx
    div %rcx
    addq $48, %rdx
    movb %dl, (%r8,%rsi)
    cmpq $0,%rax
    jne is4
is5:
    // Set return value properly
    movq %r8,%rax
    ret

// get a uint from a string
// %rdi - uint64 - the value
// returns - pointer to the new cstring
    .text
    .globl struint
struint:
    // Compute string length
    call cstrlen
    movq %rax,%rcx
    movq $0,%r8; // initialize answer
    cmpq $1,%rcx
    jg sui0
    movq %r8,%rax
    ret; // Quit early! String is too short!

sui0:
    subq $2, %rcx; // the last element of the string
    
    // Prep for the loop
    movq $1,%rbx; // Set first power
    movq $10,%r9; // Save multiplication factor
    movq $0,%rsi; // Set index of 

    // start of loop
sui1:
    xorq %rax,%rax; // Zero arithmetic registers
    xorq %rdx,%rdx;
    movb (%r8,%rcx),%al; // Load character
    // Test that the byte is expected
    cmpq $48,%rax;
    jl sui2
    cmpq $57,%rax;
    jg sui2

    subq $48,%rax; // subtract from '0'
    mul %rbx
    cmpq $0,%rdx; // Check if the multiplication overflowed
    jne sui3

    addq %rax,%r8; // Add to answer.

    // Decrement
    cmpq $0,%rcx
    je sui4
    decq %rcx
    movq %rbx,%rax
    xorq %rdx,%rdx
    mul %r9; // advance
    cmpq $0,%rdx
    jne sui3
    jmp sui1
    
    
sui2:
    movq $strerr0, %rdi
    call cstrlen
    movq %rax,%rsi
    call printcstr
    movq $0,%rax
    ret

sui3:
    movq $strerr1, %rdi
    call cstrlen
    movq %rax,%rsi
    call printcstr
    movq $0,%rax
    ret

sui4:
    movq %r8,%rax; // Finished!
    ret
