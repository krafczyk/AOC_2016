    .section .rodata
    .text
argerr0:
    .string "ERROR: Arg number beyond end of argument array.\n"
argerr1:
    .string "ERROR: Couldn't find the argument identifier\n"
argerr2:
    .string "ERROR: found the argument identifier, but at the end of argument array.\n"

// Get the nth argument starting from 0.
// %rdi - pointer on stack to start of argument section, should point to argc.
// %rsi - argument number starting from 0.
// returns - %rax - pointer to cstring argument or 0
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
    movq $argerr0, %rdi
    call cstrlen
    movq %rax,%rsi
    call printcstr
    movq $0,%rax
    ret

// Get the argument following an argument identifier
// %rdi - pointer on stack to start of argument section, should point to argc.
// %rsi - argument identifier
// returns - %rax - pointer to cstring argument or 0
// clobbers - no others
    .text
    .globl getargid
getargid:
    movq %rdi, %r8; // Save argument list
    movq (%r8),%r9; // Get number of arguments passed.

    movq $0,%rdx; // Start counting
gail:
    incq %rdx;
    cmpq %rdx,%r9; // Check that we aren't beyond 
    jb gaif1
    movq (%r8,%rdx,8),%rdi
    call cstrcmp
    cmpq $0,%rax
    jne gail

    // We found the identifier, now we need to check if we're at the end.
    cmpq %rdx,%rcx
    je gaif2

    incq %rdx; // Increment by one and return
    movq (%r8,%rdx,8),%rax
    ret

gaif1:
    movq $argerr1,%rdi
    call cstrlen
    movq %rax,%rsi
    call printcstr
    jmp gaiff

gaif2:
    movq $argerr2,%rdi
    call cstrlen
    movq %rax,%rsi
    call printcstr

gaiff:
    movq $0,%rax
    ret
