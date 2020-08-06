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
double precision:: topy 
logical::inchannel 
integer:: cellsum, cvol
simlabel='test'
printstatus=2


RMAX=8
YMAX=6
ZMAX=8
length1=RMAX*YMAX*ZMAX

write(*,*) RMAX, YMAX, ZMAX, length1
width=2
lambda=0
amprat=.25
deltat=5.0
timesteps=8
tstart=3
tstop=timesteps
depth = 1
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
call testtopo(XXX,YYY,ZZZ)
call createtestdata(RMAX,YMAX,ZMAX, slope, EP_G1)

call logvolfrc(EP_G1, EPP)
!call dynamicpressure(EP_G1, U_S1, V_S1, W_S1, DPU)
cellarea=DX(1)*DZ(1)*sqrt(1+slope**2)
tarea=0
cvol=0
cellsum=0
do I=1,length1 
        if (EP_G1(I,1)  .lt. 1) then 
        !write(*,*) XXX(I,1), YYY(I,1), ZZZ(I,1), EP_G1(i,1
                cellsum=cellsum+1
        end if 
        call edgesdose(width, lambda, depth, XXX(I,1), YYY(I,1), ZZZ(I,1) , slope,topy,inchannel)
        if ( ZZZ(I,1) .ge. 2 .and. ZZZ(I,1) .le. 4) then 
                if ( topy .gt. ceiling(.5*(8-XXX(I,1)+2)) ) then 
                        if ( inchannel) then
                        write(*,*) "FAILED 1" 
                        end if 
                       ! write(*,*) XXX(I,1), YYY(I,1), ZZZ(I,1), topy, inchannel
                end if
        end if  
        if (inchannel) cvol=cvol+1
end do
!print*, ZZZ(:,1)
!call openascii(1100, 'EP_P_t')
!call makeEP(1100, EP_P, printstatus, tfind)
!call writedxtopo
 
!call makeUG(1200, U_G, printstatus) 
print*, "calculating mass in channel"
call massinchannel(width, depth, lambda, scaleh, tarea)
if ( cellsum .ne. 48 .or. cvol .ne. 48 .or. cvol .ne. cellsum) write(*,*) "FAILED 2, sum is:", cellsum, cvol
if (tarea .ne. 3*8*sqrt(slope**2+1) ) write(*,*) "FAILED 3, area is:", tarea
print*, "end program"

end program

