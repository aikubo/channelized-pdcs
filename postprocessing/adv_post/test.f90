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
logical:: foundtop, inchannel 
integer:: n
double precision::diff, sumf, topy
double precision:: areac, truetop, xloc, yloc, zloc
simlabel='BVY7'
printstatus=0


allocate(isosurface(1200,4,15))
RMAX=404
YMAX=154
ZMAX=302
length1=RMAX*YMAX*ZMAX
width=201
lambda=600
amprat=0.15
deltat=5.0
timesteps=8
tstart=3
tstop=timesteps
depth = 27
slope=0.18 
dxi=3.0

call ALLOCATE_ARRAYS

!print*, 'testing openbin'
call openbin(100, 'EP_G', EP_G1)
call openbin(200, 'U_G', U_G1)
call openbin(300, 'T_G', T_G1)
call openbin(400, 'V_G', V_G1)
call openbin(500, 'W_G', W_G1)
call openbin(600, 'U_S1', U_S1)
call openbin(700, 'W_S1', W_S1)
call openbin(800, 'V_S1', V_S1)

call handletopo('l600_A15_W201',dxi, XXX, YYY, ZZZ)

! call several spots and test if they are right 
call logvolfrc(EP_G1, EPP)
!call dynamicpressure(EP_G1, U_S1, V_S1, W_S1, DPU)
!call gradrich(EPP, T_G1, U_G, Ri, SHUY, printstatus)




!call e1vse2 

!do I=1,length1 
!        if (Ri(I,8) .ne. 0) then
!                write(*,*) Ri(I,8) 
!        end if 
!end do 
!print*, ZZZ(:,1)
!call openascii(1100, 'EP_P_t')
!if (printstatus .ne. 0) then
!    call makeEP(1100, EP_P, printstatus, tfind)
!    call writedxtopo
!end if 
!call makeUG(1200, U_G, printstatus) 
!
!!!all makeTG(1300, T_G, printstatus)
!print*, "finding froude"
!!call isosurf(width, lambda, scaleh)
!print*, "finding richardson gradient"
!!call gradrich(EP_P, T_G1, U_G, Ri, SHUY, printstatus)
!print*, "calculating entrainment"
!!call bulkent(EP_G1) 
!print*, "calculating mass in channel"
!!call massinchannel(width, depth, lambda, scaleh)
!print*, "calculating dominant velocities"
!!call crossstream
!print*, "finding veritical column"
!!call slices2
!print*, "averaging"
!!call average_all
!print*, "velocity at the edges"
!!call edgevelocity
!!
!print*, "mass by xxx"
!!call massbyxxx
!print*, "peak dpu"
!!call dpupeak
!print*, "int mass in channel"
!!call integratemass
!print*, "energy potential"
!!call energypotential
!
!!call transectsfromchannel
!
!print*, "calling buoyantplume"
!!call buoyantplumes
!
print*, "end test"

end program

