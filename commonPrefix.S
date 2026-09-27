.global commonPrefix
# a in %rdi, b in %rsi; result (prefix length) in %eax
commonPrefix:
    xorl %eax, %eax            # n = 0

.loop:
    movslq %eax, %rcx          # sign extend
    movb (%rdi, %rcx, 1), %dl  # %dl = a[n]
    testb %dl, %dl             # a[n] & a[n] = a[n]
    je .done                   # if a[n] > 0, jump to .done
    cmpb (%rsi, %rcx, 1), %dl  # compare a[n] to b[n]
    jne .done                  # if a[n] != b[n], jump to .done
    incl %eax                  # n++
    jmp .loop                  # repeat

.done:
    ret                        # return n


# length of the longest common prefix of two null-terminated strings
# int commonPrefix(char *a, char *b){
#     int n = 0;
#     while(a[n] && a[n] == b[n])
#         n++;
#     return n;
# }
