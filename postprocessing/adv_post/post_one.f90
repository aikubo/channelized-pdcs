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
character(8)  :: date
character(10) :: time
character(5)  :: zone
integer,dimension(8) :: values

logical:: ecoef,EPPdx8, slices, topo, fd, rigrad, ent, massalloc, e1e2
logical:: countspill, massxxx,  super,UGdx8, spill, TGdx8, xstream, ave, energy, tau
double precision, allocatable:: isosurface(:,:,:)
double precision, dimension(:):: current(4)
double precision:: scaleh=50.0
double precision:: area, ttop, height, hsum

call date_and_time(date, time, zone, values)
print*, "Runing post_one.f90"
print*, date, time


simlabel='impact'
printstatus=2
e1e2=.FALSE.
massxxx=.FALSE.
super=.FALSE.
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
countspill=.FALSE.

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
if (width .eq. dble(300)) then
        depth = 39
elseif (width .eq. dble(201)) then
       depth=27
else
       depth=0
end if
slope=.18
dxi=3.0
Volume_Unit= dxi*dxi*dxi
call ALLOCATE_ARRAYS
write(*,*) "volume", Volume_Unit
write(*,*) "rho p", 1950
!print*, 'testing openbin'
call openbin(100, 'EP_G', EP_G1)
call openbin(200, 'U_G', U_G1)
call openbin(300, 'T_G', T_G1)
call openbin(400, 'V_G', V_G1)
call openbin(500, 'W_G', W_G1)
call openbin(600, 'U_S1', U_S1)
call openbin(700, 'W_S1', W_S1)
call openbin(800, 'V_S1', V_S1)
!call opennotbin(900, 'P_G', P_G)

call handletopo('l1200_A20_W201', dxi, XXX, YYY, ZZZ)

call logvolfrc(EP_G1, EPP)
call dynamicpressure(EP_G1, U_S1, V_S1, W_S1, DPU)
!print*, YYY(:,1)
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

if (rigrad .or. slices .or. e1e2) print*, "finding richardson gradient"
if (rigrad .or. slices .or. e1e2) call gradrich(EPP, T_G1, U_G, Ri, SHUY, printstatus)
print*, "calculating entrainment"
if (ent) call bulkent(EP_G1)
print*, "calculating mass in channel"

if (ecoef) print*, "ENT COEFFICIENT"
if (ecoef) call entcoef
if (super) call superelevation

if (massalloc) call massinchannel(width, depth, lambda, scaleh, area)
print*, "calculating dominant velocities"
if (xstream) call crossstream
!print*, "granular to gas stress"
!if (tau .or. slices) call calc_tau
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
if (massxxx) call massbyxxx
if (spill) call overspill
if (countspill) call countspills

if (e1e2) call e1vse2

write(*,*) "volume", Volume_Unit
write(*,*) "rho p", 1950


print*, "end program"



end program
