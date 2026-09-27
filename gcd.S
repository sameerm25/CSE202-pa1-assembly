.global gcd
# a in %edi, b in %esi; result in %eax
gcd:
    testl %esi, %esi        # b&b = b
    jne .recurse            # if b != 0, jump to .recurse
    movl %edi, %eax         # %eax = a
    ret                     # return a

.recurse:
    movl %edi, %eax         # %eax = a

.modLoop:
    cmpl %esi, %eax         # a-b
    jl .modDone             # if a-b<0 or a<b, jump to .modDone
    subl %esi, %eax         # %eax = a-b
    jmp .modLoop            # jump to .modLoop

.modDone:
    movl %esi, %edi         # %edi = b
    movl %eax, %esi         # %esi = a-b
    call gcd                # call gcd
    ret                     # return a-b

# greatest common divisor via Euclid's algorithm (recursive)
# int gcd(int a, int b){
#     if(b == 0)
#         return a;
#     /* recursive call */
#     return gcd(b, a % b);
# }
