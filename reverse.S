.global reverse
# list in %rdi (array of char*), n in %esi
reverse:
  xorl %edx, %edx             # i = 0

.loop:
  movl %esi, %ecx             # %ecx = n
  shrl $1, %ecx               # %ecx = n/2
  cmpl %ecx, %edx             # i-n/2
  jge .break                  # if i-n/2>=0, jump to .break
  movq (%rdi, %rdx, 8), %rcx  # %rcx = temp = list[i]
  movl %esi, %eax             # %eax = n
  subl %edx, %eax             # %eax = n - i
  decl %eax                   # eax = n - i - 1
  movslq %eax, %rax           # sign extend
  movq (%rdi, %rax, 8), %r8   # %r8 = list[n-i-1]
  movq %r8, (%rdi, %rdx, 8)   # list[i] = list[n-i-1]
  movq %rcx, (%rdi, %rax, 8)  # list[n-i-1] = temp
  incq %rdx                   # i++
  jmp .loop                   # jump to .loop

.break:
  ret                         # return


# void reverse(char **list, unsigned n){
#     unsigned i = 0;
#     while (i < n/2){
#      char *temp = list[i];
#      list[i] = list[n-i-1];
#      list[n-i-1] = temp;
#      i++;
#     }
# }
