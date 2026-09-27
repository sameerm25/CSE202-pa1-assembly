.global secondMax
# v1 in %di, v2 in %si, v3 in %dx, v4 in %cx  (signed 16-bit); result in %ax
# first in %r8w, second in %ax
secondMax:
  cmpw %si, %di
  jge .if1statements
  movw %si, %r8w
  movw %di, %ax
  jmp .if2

.if1statements:
  movw %di, %r8w
  movw %si, %ax

.if2:
  cmpw %r8w, %dx
  jg .if2statements
  jmp .if3

.if2statements:
  movw %r8w, %ax
  movw %dx, %r8w
  jmp .if4

.if3:
  cmpw %ax, %dx
  cmovg %dx, %ax 

.if4:
  cmpw %r8w, %cx
  jg .if4statements
  cmpw %ax, %cx
  jg .if5
  jmp .return

.if4statements:
  movw %r8w, %ax
  movw %cx, %r8w
  jmp .return

.if5:
  movw %cx, %ax
  jmp .return

.return:
  ret

# short secondMax(short v1, short v2, short v3, short v4){
#   short first, second;
#   if(v1 >= v2){
#     first = v1;
#     second = v2;
#   }
#   else{
#     first = v2;
#     second = v1;
#   }
#   if(v3 > first){
#     second = first;
#     first = v3;
#   }
#   else if(v3 > second){
#     second = v3;
#   }
#   if(v4 > first){
#     second = first;
#     first = v4;
#   }
#   else if(v4 > second){
#     second = v4;
#   }
#   return second;
# }
