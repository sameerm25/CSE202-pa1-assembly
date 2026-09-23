.global mult7div8
# a in %dil (signed char), overflow pointer in %rsi; result in %eax
mult7div8:
  movb %dil, %dl         # %dl = a
  salb $3, %dl           # %dl = 8a
  subb %dil, %dl         # %dl = 8a - a = 7a
  testb %dil, %dil       # a & a = a
  jg .case1              # if a > 0, jump to .case1
  testb %dil, %dil       # a & a = a
  jl .case2              # if a < 0, jump to .case2

.case1:
  testb %dl, %dl         # 7a & 7a = 7a
  jl .true               # if 7a < 0, jump to .true
  movb $0, (%rsi)        # (%rsi) = 0
  jmp .divide            # jump to .divide
  
.case2:
  testb %dl, %dl         # 7a & 7a = 7a 
  jg .true               # if 7a > 0, jump to .true
  movb $0, (%rsi)        # (%rsi) = 0
  jmp .divide            # jump to .divide
  
.true:
  movb $1, (%rsi)        # (%rsi) = 1

.divide:
  testb %dl, %dl         # 7a & 7a = 7a
  jns .noAdjust          # if 7a >= 0, jump to .noAdjust
  addb $7, %dl           # %dl = 7a + 7

.noAdjust:
  sarb $3, %dl           # %dl's value /= 8
  movsbl %dl, %eax       # %eax = %dl's value
  ret                    # return %eax's value

# char mult7div8(char a, char *overflow){
#     char mult = (7 * a);
#     if(a > 0 && mult < 0 || a < 0 && mult > 0)
#       *overflow = 1;
#     else
#       *overflow = 0;
#     return mult/8;
# }
