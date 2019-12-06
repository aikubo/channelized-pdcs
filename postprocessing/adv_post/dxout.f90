program post 
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
use averageit

implicit none
integer:: tfind=8


integer::printstatus


double precision, allocatable:: isosurface(:,:,:)
double precision, dimension(:):: current(4)
double precision:: scaleh=50.0

simlabel='CVX7'

printstatus=1

allocate(isosurface(1200,4,15))
RMAX=404
YMAX=154
ZMAX=302
length1=RMAX*YMAX*ZMAX
width=201
lambda=900
amprat=0.15
deltat=5.0
timesteps=8
tstart=3
tstop=timesteps
depth = 27

call ALLOCATE_ARRAYS

!print*, 'testing openbin'
call openbin(100, 'EP_G', EP_G1)
!call openbin(200, 'U_G', U_G1)
!call openbin(300, 'T_G', T_G1)
!call openbin(400, 'V_G', V_G1)
!call openbin(500, 'W_G', W_G1)
!call openbin(600, 'U_S1', U_S1)
!call openbin(700, 'W_S1', W_S1)
!call openbin(800, 'V_S1', V_S1)

call handletopo('l900_A9_W201', XXX, YYY, ZZZ)

call logvolfrc(EP_G1, EPP)
call dynamicpressure(EP_G1, U_S1, V_S1, W_S1, DPU)

do t=1,timesteps
        call makedxtxt( 'EP_P_t', 1100, EPP, t)
end do 
call writedxtopo
 
call makedxtxt('DPU_t', 1200, DPU, 8)
end program

