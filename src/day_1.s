    .section .rodata
    .text
str0:
    .string "test0"
str1:
    .string "test0"
str2:
    .string "test0"
str3:
    .string "tes"
mess1:
    .string "str0 and str1 are equal!\n"
mess2:
    .string "str0 and str1 are not equal..\n"
mess3:
    .string "str2 and str3 are equal..\n"
mess4:
    .string "str2 and str3 are not equal!\n"
    .global _start
    .text
_start:
    movq $str0,%rdi
    movq $str1,%rsi
    call cstrcmp
    movq $mess1,%rdi
    movq $mess1,%rbx
    cmpq $0,%rax
    cmovneq %rbx,%rdi
    call cstrlen
    movq %rax,%rsi
    call printcstr

    movq $str2,%rdi
    movq $str3,%rsi
    call cstrcmp
    movq $mess3,%rdi
    movq $mess4,%rbx
    cmpq $0,%rax
    cmovneq %rbx,%rdi
    call cstrlen
    movq %rax,%rsi
    call printcstr

    // exit sequence
    movq $60,%rax; // Syscall 60 is exit
    xorq %rdi,%rdi; // Set exit value
    syscall; // Make the syscall
