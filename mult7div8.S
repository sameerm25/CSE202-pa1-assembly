.global mult7div8
# a in %dil (signed char), overflow pointer in %rsi; result in %eax
mult7div8:
  movb %dil, %dl
  salb $3, %dl
  subb %dil, %dl
  testb %dil, %dil
  jg .case1
  testb %dil, %dil
  jl .case2

.case1:
  testb %dl, %dl
  jl .true
  movb $0, (%rsi)
  jmp .divide
  
.case2:
  testb %dl, %dl
  jg .true
  movb $0, (%rsi)
  jmp .divide
  
.true:
  movb $1, (%rsi)

.divide:
  testb %dl, %dl
  jns .noadjust
  addb $7, %dl

.noadjust:
  sarb $3, %dl
  movsbl %dl, %eax
  ret

# char mult7div8(char a, char *overflow){
#     char mult = (7 * a);
#     if(a > 0 && mult < 0 || a < 0 && mult > 0)
#       *overflow = 1;
#     else
#       *overflow = 0;
#     return mult/8;
# }
