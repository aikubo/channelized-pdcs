program test 
use formatmod
use parampost 
use constants
use openbinary 
use maketopo 
use makeascii
use var_3d
use column
use findhead 
use find_richardson 
use entrainment 
use massdist
use sinplane 

implicit none
integer:: tsinplane 


tsinplane=4
RMAX=404
YMAX=154
ZMAX=302
length1=RMAX*YMAX*ZMAX
width=0
lambda=0
timesteps=8
tstart=3
tstop=timesteps
depth = 27
amprat=0

call ALLOCATE_ARRAYS

!print*, 'testing openbin'
call openbin(100, 'EP_G', EP_G1)
!call openbin(400, 'V_G', V_G1)
!call openbin(500, 'W_G', W_G1)
call  logvolfrc(EP_G1, EPP)
call handletopo('l0_A0_W0', XXX, YYY, ZZZ)

!call writedxtopo

call sinuousplane(tsinplane)



!call openascii(1100, 'EP_P_t')
!call makeEP(1100, EP_P, printstatus)
!call makeUG(1200, U_G, printstatus) 

!call makeTG(1300, T_G, printstatus)
!call isosurf(width, lambda)
!call gradrich(EP_P, T_G1, U_G, Richardson, SHUY)

!call bulkent(EP_G1) 

!call massinchannel(width, depth, lambda, scaleh)


print*, "end program"

end program

