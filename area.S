.global area
# a in %edi, b in %esi, c in %edx; result in %eax
area:
    movl %edi, %eax   # p = a
    addl %esi, %eax   # p = a+b
    addl %edx, %eax   # p = a+b+c
    sarl $1, %eax     # p = (a+b+c)/2
    subl %eax, %edi   # %edi = a-p
    imull $-1, %edi   # %edi = p-a
    subl %eax, %esi   # %esi = b-p
    imull $-1, %esi   # %esi = p-b
    subl %eax, %edx   # %edx = c-p
    imull $-1, %edx   # %edx = p-c
    imull %edi, %eax  # p = p(p-a)
    imull %esi, %eax  # p = p(p-a)(p-b)
    imull %edx, %eax  # p = p(p-a)(p-b)(p-c)
    movl %eax, %edi
    
.sqrt:
    testl %edi, %edi  # x&x=x
    jl .base1         # if x<0, jump to .base1
    cmpl $2, %edi     # x-2
    jl .base2         # if x-2<0, jump to .base2
    pushq %rbx        # save old %rbx value
    movl %edi, %ebx   # %ebx = x
    sarl $2, %edi     # %edi = x/4
    call .sqrt        # recursive call, %eax = .sqrt(x>>2)
    sall $1, %eax     # small_cand = .sqrt(x>>2)<<1
    movl %eax, %ecx   # %ecx = small_cand
    addl $1, %eax     # %eax = large_cand = small_cand + 1
    movl %eax, %edx   # %edx = large_cand
    imull %eax, %edx  # %edx = large_cand*large_cand = large_cand^2
    cmpl %ebx, %edx   # large_cand^2 - x
    jg .returnSmall   # if large_cand^2-x > 0, jump to .returnSmall
    popq %rbx         # restore %rbx's old value
    ret               # return large_cand

.returnSmall:
    movl %ecx, %eax   # %eax = small_cand
    popq %rbx         # restore %rbx's old value
    ret               # return small_cand

.base1:
    movl $-1, %eax    # %eax = -1
    ret               # return -1

.base2:
    movl %edi, %eax   # %eax = x
    ret               # return x

# int area(int a, int b, int c){
#     int p = (a + b + c)/2;
#     p = p * (p-a) * (p-b) * (p-c);
#     return sqrt(p);
# }
# calculate recursively the square root of an int (in C)
# int r_sqrt(int x){
#    if(x < 0)
#        return -1;
#    if (x < 2)
#        return x;
#   /* recursive call */
#    int small_cand = r_sqrt(x >> 2) << 1;
#    int large_cand = small_cand + 1;
#    if (large_cand * large_cand > x)
#        return small_cand;
#    else
#        return large_cand;
# }
