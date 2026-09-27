.global product
# a in %rdi, b in %rsi, c in %rdx, size in %ecx
product:
    xorl %eax, %eax              # i = 0

.loop:
    cmpl %ecx, %eax              # i-size
    jge .done                    # if i-size>=0 or i>=size, jump to .done
    movslq %eax, %r8             # sign extend
    movss (%rdi, %r8, 4), %xmm0  # xmm0 = a[i]
    mulss (%rsi, %r8, 4), %xmm0  # xmm0 = a[i] * b[i]
    movss %xmm0, (%rdx, %r8, 4)  # c[i] = a[i] * b[i]
    incl %eax                    # i++
    jmp .loop                    # repeat

.done:
    ret                          # return

# Product of two vectors in C
# void product(float *a, float *b, float *c, unsigned size){
#    for(int i=0; i<size; i++){
#        c[i] = a[i] * b[i];
#    }
# }
