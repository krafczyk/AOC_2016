// Allocate a block of memory
// %rdi - uint64 - number of bytes to allocate
// returns - %rax - address of start of memory block, or error
// clobbers - %rsi
    .text
    .globl mem_alloc
mem_alloc:
    // 
    movq $0x9, %rax; // (set the system call)
    movq %rdi, %rsi; // (arg1) (len) Save length
    xorq %rdi, %rdi; // (arg0) (addr) Set addr to NULL

    movq $0x1, %rdx; // (arg2) (prot) Set PROT_READ
    xorq $0x2, %rdx; // Or with PROT_WRITE
    //xorq $0x4, %rdx; // Or with PROT_EXEC

    movq $0x02, %r10; // (arg3) (flags) Set MAP_PRIVATE
    xorq $0x20, %r10; // Or with MAP_ANONYMOUS

    movq $-1, %r8; // (arg4) (fildes) The file descriptor we have

    xorq %r9, %r9; // (arg5) (off) Set the offset to 0.

    syscall

    ;// Check for failure
    cmpq $-4096,%rax
    ja mem_alloc_err
    ret

mem_alloc_err:
    xorq %rax,%rax
    ret

// Free a block of memory
// %rdi - void* - address of memory to free
// %rsi - size_t - length in bytes of memory to free
// clobbers - %rax
    .text
    .globl mem_free
mem_free:
    movq $11,%rax
    syscall
    ret
