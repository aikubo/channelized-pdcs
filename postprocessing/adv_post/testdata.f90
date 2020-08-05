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
use test

implicit none
integer:: tfind=8


integer::printstatus
double precision, dimension(:):: current(4)
double precision:: scaleh=50.0
double precision:: tarea, cellarea
simlabel='test'
printstatus=2


RMAX=4
YMAX=6
ZMAX=4
length1=RMAX*YMAX*ZMAX

write(*,*) RMAX, YMAX, ZMAX, length1
width=2
lambda=0
amprat=0
deltat=5.0
timesteps=8
tstart=3
tstop=timesteps
depth = 0
slope=0.5 

call ALLOCATE_ARRAYS

!!print*, 'testing openbin'
!call openbin(100, 'EP_G', EP_G1)
!call openbin(200, 'U_G', U_G1)
!call openbin(300, 'T_G', T_G1)
!call openbin(400, 'V_G', V_G1)
!call openbin(500, 'W_G', W_G1)
!call openbin(600, 'U_S1', U_S1)
!call openbin(700, 'W_S1', W_S1)
!call openbin(800, 'V_S1', V_S1)

call createtestdata(RMAX,YMAX,ZMAX, slope, EP_G1)
call testtopo(XXX,YYY,ZZZ)
!call handletopo('l900_A20_W201', XXX, YYY, ZZZ)

call logvolfrc(EP_G1, EPP)
!call dynamicpressure(EP_G1, U_S1, V_S1, W_S1, DPU)
cellarea=DX(1)*DZ(1)*sqrt(1+slope**2)
tarea=0
do I=1,length1 
        if (EP_G1(I,1)  .ne. 1) then 
        write(*,*) XXX(I,1), YYY(I,1), ZZZ(I,1), EP_G1(i,1)
        tarea=tarea+cellarea
        end if 
end do
!print*, ZZZ(:,1)
!call openascii(1100, 'EP_P_t')
!call makeEP(1100, EP_P, printstatus, tfind)
!call writedxtopo
 
!call makeUG(1200, U_G, printstatus) 
print*, "calculating mass in channel"
call massinchannel(width, depth, lambda, scaleh)
write(*,*) "True area", tarea
print*, "end program"

end program

