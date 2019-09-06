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
use averageit

implicit none
integer:: tfind=8
double precision:: ZLOC=150
double precision:: XLOC=200
logical::printstatus 
double precision:: width, lambda
double precision, allocatable:: isosurface(:,:,:)
double precision, dimension(:):: current(4)
double precision:: scaleh=50.0

simlabel='SV4'

allocate(isosurface(1200,4,15))
RMAX=404
YMAX=154
ZMAX=302
length1=RMAX*YMAX*ZMAX
width=201
lambda=0
printstatus=.false.
timesteps=8
tstart=3
tstop=timesteps
depth = 27

call ALLOCATE_ARRAYS

!print*, 'testing openbin'
call openbin(100, 'EP_G', EP_G1)
call openbin(200, 'U_G', U_G1)
call openbin(300, 'T_G', T_G1)
call openbin(400, 'V_G', V_G1)
call openbin(500, 'W_G', W_G1)
call openbin(600, 'U_S1', U_S1)

call handletopo('l300_W201', XXX, YYY, ZZZ)
call  logvolfrc(EP_G1, EPP)
call dynamicpressure(EP_G1, U_S1, DPU)
!print*, ZZZ(:,1)
!call openascii(1100, 'EP_P_t')
!call makeEP(1100, EP_P, printstatus)
!call makeUG(1200, U_G, printstatus) 

!call makeTG(1300, T_G, printstatus)
!call isosurf(width, lambda)
!call gradrich(EP_P, T_G1, U_G, Ri, SHUY, printstatus)
!print*, Ri_all
!call bulkent(EP_G1) 

!call massinchannel(width, depth, lambda, scaleh)
!open(1300, file='slice.txt')
!call slice(width, depth, lambda, 1300, XLOC, ZLOC)

call average_all

print*, "end program"

end program

