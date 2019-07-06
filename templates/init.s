    .global _start
    .text
_start:
    // exit sequence
    movq $60,%rax; // Syscall 60 is exit
    xorq %rdi,%rdi; // Saving the exit code here
    syscall; // Make the syscall
