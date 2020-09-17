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
use grangass

implicit none
integer:: tfind=8


integer::printstatus

logical:: ecoef,EPPdx8, slices, topo, fd, rigrad, ent, massalloc
logical:: UGdx8, spill, TGdx8, xstream, ave, energy, tau
double precision, allocatable:: isosurface(:,:,:)
double precision, dimension(:):: current(4)
double precision:: scaleh=50.0
double precision:: area 

simlabel='DVZ4'
printstatus=2

spill=.FALSE.
ecoef=.FALSE.
EPPdx8=.FALSE.
TGdx8=.FALSE.
UGdx8=.FALSE.
topo=.FALSE.
slices=.FALSE.
fd=.FALSE. 
rigrad=.FALSE.
ent=.FALSE.
massalloc=.FALSE.
xstream=.FALSE.
ave=.FALSE.
energy=.FALSE.
tau=.FALSE.

allocate(isosurface(1200,4,15))
RMAX=404
YMAX=154
ZMAX=302
length1=RMAX*YMAX*ZMAX
width=201
lambda=1200
amprat=.20000000000000000000
deltat=5.0
timesteps=8
tstart=3
tstop=timesteps
depth = 27
slope=0.18
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

call handletopo('l1200_A20_W201', XXX, YYY, ZZZ)

call logvolfrc(EP_G1, EPP)
call dynamicpressure(EP_G1, U_S1, V_S1, W_S1, DPU)

!print*, ZZZ(:,1)
if (UGdx8) then 
       do t=1,timesteps 
                call makedxtxt('UG_t',2000, U_G1, t)
       end do  
end if

if (EPPdx8) then
       do t=1,timesteps
                call makedxtxt('EP_P_t',1000, EPP, t)
       end do
end if

if (TGdx8) then
       do t=1,timesteps
                call makedxtxt('T_G_t',3000, T_G1, t)
       end do
end if


 
if (topo) call writedxtopo
 


print*, "finding froude"

if (fd) call isosurf(scaleh)
print*, "finding richardson gradient"
if (rigrad .or. slices) call gradrich(EP_P, T_G1, U_G, Ri, SHUY, printstatus)
print*, "calculating entrainment"
if (ent) call bulkent(EP_G1) 
print*, "calculating mass in channel"

if (ecoef) print*, "ENT COEFFICIENT"
if (ecoef) call entcoef

if (massalloc) call massinchannel(width, depth, lambda, scaleh, area)
print*, "calculating dominant velocities"
if (xstream) call crossstream
print*, "granular to gas stress"
if (tau .or. slices) call calc_tau
print*, "finding veritical column"
if (slices) call slices2
print*, "averaging"
if (ave) call average_all
print*, "velocity at the edges"
if (energy) then 
        call edgevelocity
        print*, "mass by xxx"
        call massbyxxx
        print*, "int mass in channel"
        call integratemass
        print*, "energy potential"
        call energypotential
        print*, "find peak dpu"
        call dpupeak
end if 

if (spill) call overspill


print*, "end program"



end program

