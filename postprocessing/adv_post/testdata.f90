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
double precision:: topo, topy, areac, areac2
logical::inchannel 
integer:: cellsum, cvol
simlabel='test'
printstatus=2


RMAX=8
YMAX=6
ZMAX=8
length1=RMAX*YMAX*ZMAX

write(*,*) RMAX, YMAX, ZMAX, length1
width=6
lambda=0
amprat=.25
deltat=5.0
timesteps=8
tstart=3
tstop=timesteps
depth = 3
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
cellarea=DX(1)*DX(1)*sqrt(1+slope**2)
tarea=0
cvol=0
areac=0
cellsum=0
do I=1,length1 
         call edgesdose(width, lambda, depth, XXX(I,1), YYY(I,1), ZZZ(I,1) ,slope,topy,inchannel)
        if (EP_G1(I,1)  .lt. 1) then 
                !write(*,*) XXX(I,1), YYY(I,1), ZZZ(I,1), EP_G1(i,1)
                cellsum=cellsum+1
                if ( YYY(I,1) .eq. topy ) then 
                    write(*,*) "top"
                    areac=areac+cellarea
                end if                
        end if 

        !edge1= ceiling(4+2*sind(XXX(I,1)/8*360)-width/2)
        !edge2= ceiling(edge1+width)
        !write(*,*) edge1, edge2
        topo=ceiling((slope*DX(1)*(RMAX-(XXX(I,1)/DX(1))+2*DX(1))/DX(1))*DX(1))
        !if ( ZZZ(I,1) .ge. edge1 .and. ZZZ(I,1) .le. edge2) then 
                if ( YYY(I,1) .gt. topo  .and. inchannel) then
                        write(*,*) "FAILED 1 should be outside" 
                        write(*,*) XXX(I,1), YYY(I,1), ZZZ(I,1), topy, inchannel
                end if
        !end if 

           if ( YYY(I,1) .lt. topo .and. YYY(I,1) .gt. topy) then
                        if ( .not. inchannel) then
                        write(*,*) "FAILED 1 should be inside"
                        write(*,*) XXX(I,1), YYY(I,1), ZZZ(I,1), topy,inchannel
                        end if
                       ! inchannel
        end if
 
        if (inchannel) cvol=cvol+1
end do
!print*, ZZZ(:,1)
!call openascii(1100, 'EP_P_t')
!call makeEP(1100, EP_P, printstatus, tfind)
!call writedxtopo
areac2=DX(1)*(width+DX(1))*RMAX*sqrt(slope**2+1)
!call makeUG(1200, U_G, printstatus) 
print*, "calculating mass in channel"
call massinchannel(width, depth, lambda, scaleh, tarea)
if ( cvol .ne. cellsum) write(*,*) "FAILED 2, volume is", cvol, " sum is:", cellsum, cvol
if ( int(areac) .ne. int(areac2)) write(*,*) "FAILED 3 areac is ", areac, "areac2 is", areac2
if (tarea .ne. areac ) write(*,*) "FAILED 3, areac is", areac," area is:", tarea
print*, "end program"

end program

