.global isPrime
# n in %edi; result in %eax (1 = prime, 0 = not prime)
isPrime:
  cmpl $2, %edi       # n-2
  jl .notPrime        # if n-2<0 or n<2, jump to .notprime
  testl $1, %edi      # n&1 --> n's least bit
  jne .loopInit       # if n&1 != 0, jump to .loopInit
  cmpl $2, %edi       # n-2
  je .isPrime         # if n-2 == 0 or n==2, jump to .isPrime
  jmp .notPrime       # jump to .notPrime

.loopInit:
  movl $3, %ecx       # i = 3

.loop:
  movl %ecx, %eax   # %eax = i
  imull %ecx, %eax  # %eax = i * i = i^2
  cmpl %edi, %eax   # i^2-n
  jg .isPrime       # if i^2-n > 0 or i^2 > n, jump to .isPrime
  movl %edi, %eax   # %eax = n

.modLoop:
  cmpl %ecx, %eax   # %eax's value - i
  jl .modDone       # if %eax's value - i < 0, jump to .modDone
  subl %ecx, %eax   # %eax -= i
  jmp .modLoop      # jump to .modLoop

.modDone:
  testl %eax, %eax  # %eax & %eax = %eax
  je .notPrime      # if %eax's value == 0, jump to .notPrime
  addl $2, %ecx     # i += 2
  jmp .loop         # jump to .loop

.isPrime:
  movl $1, %eax     # result = 1
  ret               # return 1

.notPrime:
  xorl %eax, %eax   # result = 0
  ret               # return 0

# int isPrime(int n){
#     if(n < 2)
#         return 0;
#     if(n % 2 == 0)
#         return n == 2;
#     /* only test odd divisors i while i*i <= n */
#     for(int i = 3; i * i <= n; i += 2){
#         if(n % i == 0)
#             return 0;
#     }
#     return 1;
# }
