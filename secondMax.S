.global secondMax
# v1 in %di, v2 in %si, v3 in %dx, v4 in %cx  (signed 16-bit); result in %ax
# first in %r8w, second in %ax
secondMax:
  cmpw %si, %di       # v1 - v2
  jge .if1statements  # if v1-v2>=0, jump to .if1statements
  movw %si, %r8w      # first = v2
  movw %di, %ax       # second = v1
  jmp .if2            # jump to .if2

.if1statements:
  movw %di, %r8w      # first = v1
  movw %si, %ax       # second = v2

.if2:
  cmpw %r8w, %dx      # v3 - first
  jg .if2statements   # if v3-first>0, jump to .if2statements
  jmp .if3            # jump to .if3

.if2statements:
  movw %r8w, %ax      # second = first
  movw %dx, %r8w      # first = v3
  jmp .if4            # jump to .if4

.if3:
  cmpw %ax, %dx       # v3 - second
  cmovg %dx, %ax      # if v3-second>0, second = v3

.if4:
  cmpw %r8w, %cx      # v4 - first
  jg .if4statements   # if v4-first>0, jump to .if4statements
  cmpw %ax, %cx       # v4 - second
  jg .if5             # if v4-second>0, jump to .if5
  jmp .return         # jump to .return

.if4statements:
  movw %r8w, %ax      # second = first
  movw %cx, %r8w      # first = v4
  jmp .return         # jump to .return

.if5:
  movw %cx, %ax       # first = v4
  jmp .return         # jump to .return

.return:
  ret                 # return second

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
