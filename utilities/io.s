    .text
    .section .rodata
    .globl ioendl
ioendl:
    .string "\n"

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

// open a file and get a file descriptor
// %rdi - string - filepath
// %rsi - int - file flags
// %rdx - string - mode - we need to translate to file 
    .text
    .globl openfile
openfile:
    movq $2, %rax
    movq %rdi, %rbx

