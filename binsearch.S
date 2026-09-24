.global binsearch
# arr in %rdi, n in %esi, target in %edx
binsearch:
  movslq %esi, %rsi            # %rsi = n
  movslq %edx, %rdx            # %rdx = target
  xorq %rcx, %rcx              # %rcx = lo = 0
  decq %rsi                    # %rsi = hi = n - 1

.loop:
  cmpq %rsi, %rcx              # lo - hi
  jg .break                    # if lo - hi > 0 or lo > hi, jump to .break
  movq %rsi, %r8               # %r8 = mid = hi
  subq %rcx, %r8               # %r8 = mid = hi - lo
  sarq $1, %r8                 # %r8 = mid = (hi - lo) / 2
  addq %rcx, %r8               # %r8 = mid = lo + (hi - lo) / 2
  cmpl %edx, (%rdi, %r8, 4)    # arr[mid] - target
  je .if                       # if arr[mid] - target == 0 or arr[mid] == target, jump to .if
  cmpl %edx, (%rdi, %r8, 4)    # arr[mid] - target
  jl .elseIf                   # if arr[mid] - target < 0 or arr[mid] < target, jump to .elseIf
  movq %r8, %rsi               # %rsi = hi = mid
  decq %rsi                    # %rsi = hi = mid - 1
  jmp .loop                    # jump to .loop

.if:
  movq %r8, %rax               # %rax = mid
  ret                          # return mid

.elseIf:
  movq %r8, %rcx               # %rcx = lo = mid
  incq %rcx                    # %rcx = lo = mid + 1
  jmp .loop                    # jump to .loop

.break:
  movq $-1, %rax               # %rax = -1
  ret                          # return -1



# binary search over a sorted int array; returns the index of target, or -1
# int binsearch(int *arr, unsigned n, int target){
#     int lo = 0;
#     int hi = (int)n - 1;
#     while(lo <= hi){
#         int mid = lo + (hi - lo) / 2;
#         if(arr[mid] == target)
#             return mid;
#         else if(arr[mid] < target)
#             lo = mid + 1;
#         else
#             hi = mid - 1;
#     }
#     return -1;
# }
