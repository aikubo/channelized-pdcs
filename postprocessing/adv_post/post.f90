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
double precision:: ZLOC=150
double precision:: XLOC=200
integer::printstatus=2
double precision:: width, lambda
double precision, allocatable:: isosurface(:,:,:)
double precision, dimension(:):: current(4)
double precision:: scaleh=50.0

simlabel='BV4'

allocate(isosurface(1200,4,15))
RMAX=404
YMAX=154
ZMAX=302
length1=RMAX*YMAX*ZMAX
width=201
lambda=600
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

call handletopo('l600_w201', XXX, YYY, ZZZ)
call writedxtopo
call  logvolfrc(EP_G1, EPP)
call dynamicpressure(EP_G1, U_S1, DPU)
!print*, ZZZ(:,1)
!call openascii(1100, 'EP_P_t')
call makeEP(1100, EP_P, printstatus, tfind)
!call makeUG(1200, U_G, printstatus) 

!call makeTG(1300, T_G, printstatus)
print*, "finding froude"
call isosurf(width, lambda, scaleh)
print*, "finding richardson gradient"
call gradrich(EP_P, T_G1, U_G, Ri, SHUY, printstatus)
print*, "calculating entrainment"
call bulkent(EP_G1) 
print*, "calculating mass in channel"
call massinchannel(width, depth, lambda, scaleh)
print*, "finding veritical column"
call slice(width, depth, lambda, XLOC, ZLOC)

call average_all

print*, "end program"

end program

