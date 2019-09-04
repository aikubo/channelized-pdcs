program verticalprofile 
use formatmod
use parampost 
use constants
use openbinary 
use maketopo 
use makeascii
use var_3d
use column

implicit none
logical:: printstatus
integer:: middle
double precision:: ZLOC, XLOC

ZLOC=450.0
XLOC=300.0
printstatus=.false.

middle = 450
RMAX=404
ZMAX=302
YMAX=154
length1 = RMAX*ZMAX*YMAX

timesteps=10
tstart=1
tstop=timesteps
depth=25.125

call ALLOCATE_ARRAYS

!print*, 'testing openbin'
call openbin(100, 'EP_G', EP_G1) 
call openbin(200, 'T_G', T_G1)
call openbin(300, 'U_G', U_G1)
!call openbin(400, 'V_G', V_G1)
!call openbin(500, 'W_G', W_G1)

call handletopo('l300_W201', XXX, YYY, ZZZ)
!call openascii(1100, 'EP_P_t') 
!call openascii(1200, 'U_G_t')
!call openascii(1300, 'T_G_t')
open(middle, file='middlecolumn.txt')
!call openascii(middle, 'column_t')
!call makeEP(1100, EP_P, printstatus)
 
!call makeUG(1200, U_G)
!call makeTG(1300, T_G)
!call makedxfiles(1100, 1200, 1300) 

print*, "entering slice subroutine"
call slice(middle, XLOC, ZLOC)

!call writedxtopo

write(*,*) "program complete"
end program

