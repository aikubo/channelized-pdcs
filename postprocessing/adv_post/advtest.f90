program test 

use parampost 
use constants
use openbinary 
use maketopo 
use makeascii
use var_3d
!use formatmod
implicit none

call ALLOCATE_ARRAYS

print*, 'testing parampost'
yc = 10 
print*, yc

print*, 'testing constants'
print*, timesteps

!print*, 'testing openbin'
call openbin(100, 'EP_G', EP_G1) 
!call openbin(200, 'T_G', T_G1)
!call openbin(300, 'U_G', U_G1)

!print*, EP_G1(1,1) 

print*, 'testing handle topo'
call handletopo('topo_sin_20_18_l800_w50', XXX, YYY, ZZZ)
call writedxtopo
!print*, XXX(160, 1) 
!print*, YYY(190, 1)
!print*, ZZZ(898, 1)

!call openascii(1100, 'EP_P_t') 

!call make3dvar

!call makedxfiles
end program

