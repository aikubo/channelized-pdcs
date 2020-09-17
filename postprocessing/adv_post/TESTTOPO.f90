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
double precision:: diff, sumf, topy
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

call handletopo('l600_A15_W201', XXX, YYY, ZZZ)

! call several spots and test if they are right 

XLOC=3
YLOC=3
ZLOC=3

call edgesdose(width, lambda, depth, Xloc, Yloc, Zloc,slope,topy,inchannel)
call FUNIJK_dble(xloc,  yloc, zloc, I) 
write(*,*) "test1"
write(*,*) xloc, yloc, zloc-DX(1), XXX(I,1), YYY(I,1), ZZZ(I,1) 
write(*,*) EP_G1(I,1), "expected:", dble(0.0)
write(*,*) "channel logical", inchannel, "expected: F"
print*, "******** passed *********"

XLOC=9
YLOC=399
ZLOC=150

call edgesdose(width, lambda, depth, Xloc, Yloc, Zloc,slope,topy,inchannel)
call FUNIJK_dble(xloc,  yloc, zloc, I)
write(*,*) "tes3"
write(*,*) xloc, yloc, zloc-DX(1), XXX(I,1), YYY(I,1), ZZZ(I,1) 
write(*,*) EP_G1(I,1), "expected:", dble(1.0)
write(*,*) "channel logical", inchannel, "expected: F"
print*, "******* passed **************"


XLOC=12
YLOC=267
ZLOC=399
call edgesdose(width, lambda, depth, Xloc, Yloc, Zloc,slope,topy,inchannel)
call FUNIJK_dble(xloc,  yloc, zloc, I)
write(*,*) "test5"
write(*,*) xloc, yloc, zloc, XXX(I,1), YYY(I,1), ZZZ(I,1) 
write(*,*) EP_G1(I,1), "expected:", dble(0.6)
!write(*,*) "channel logical", inchannel, "expected: T"
write(*,*) topy
if (inchannel .and. EP_G1(I,1) .eq. dble(0.01)) write(*,*) "FAILED"

XLOC=12
YLOC=270
ZLOC=300
call edgesdose(width, lambda, depth, Xloc, Yloc, Zloc,slope,topy,inchannel)
call FUNIJK_dble(xloc,  yloc, zloc, I)
write(*,*) "test6"
write(*,*) xloc, yloc, zloc, XXX(I,1), YYY(I,1), ZZZ(I,1)
write(*,*) EP_G1(I,7), "expected:", dble(0.6)
!write(*,*) "channel logical", inchannel, "expected: T"
write(*,*) topy
if (inchannel .and. EP_G1(I,1) .le. dble(0.01)) write(*,*) "FAILED"

XLOC=12
YLOC=273
ZLOC=300
call edgesdose(width, lambda, depth, Xloc, Yloc, Zloc,slope,topy,inchannel)
call FUNIJK_dble(xloc,  yloc, zloc, I)
write(*,*) "test7"
write(*,*) xloc, yloc, zloc, XXX(I,1), YYY(I,1), ZZZ(I,1)
write(*,*) EP_G1(I,7), "expected:", dble(0.6)
!write(*,*) "channel logical", inchannel, "expected: T"
write(*,*) topy
if (inchannel .and. EP_G1(I,1) .le. dble(0.01)) write(*,*) "FAILED"

XLOC=600
do yc=52,56
YLOC=dX(1)*yc
ZLOC=300
call edgesdose(width, lambda, depth, Xloc, Yloc, Zloc,slope,topy,inchannel)
call FUNIJK_dble(xloc,  yloc, zloc, I)
!write(*,*) "test9"
write(*,*) xloc, yloc, zloc !, XXX(I,1), YYY(I,1), ZZZ(I,1)
write(*,*) EP_G1(I,1), "expected: >0"
!write(*,*) "channel logical", inchannel, "expected: T"
write(*,*) topy
if ( YLOC .ge. topy .and. EP_G1(I,1) .le. dble(0.01)) write(*,*) "FAILED"
end do 

XLOC=624
YLOC=165
ZLOC=300
call edgesdose(width, lambda, depth, Xloc, Yloc, Zloc,slope,topy,inchannel)
call FUNIJK_dble(xloc,  yloc, zloc, I)
write(*,*) "test10"
write(*,*) xloc, yloc, zloc!, XXX(I,1), YYY(I,1), ZZZ(I,1)
write(*,*) EP_G1(I,1), "expected:", dble(0.6)
!write(*,*) "channel logical", inchannel, "expected: T"
write(*,*) topy
if (YLOC .ge. topy .and. EP_G1(I,1) .le. dble(0.01)) write(*,*) "FAILED"


XLOC=627
YLOC=165
ZLOC=300
call edgesdose(width, lambda, depth, Xloc, Yloc, Zloc,slope,topy,inchannel)
call FUNIJK_dble(xloc,  yloc, zloc, I)
write(*,*) "test11"
write(*,*) xloc, yloc, zloc !, XXX(I,1), YYY(I,1), ZZZ(I,1)
write(*,*) EP_G1(I,1), "expected: >0"
!write(*,*) "channel logical", inchannel, "expected: T"
write(*,*) topy
if (YLOC .ge. topy .and. EP_G1(I,1) .le. dble(0.01)) write(*,*) "FAILED"

XLOC=924
YLOC=111
ZLOC=300
call edgesdose(width, lambda, depth, Xloc, Yloc, Zloc,slope,topy,inchannel)
call FUNIJK_dble(xloc,  yloc, zloc, I)
write(*,*) "test12"
write(*,*) xloc, yloc, zloc !, XXX(I,1), YYY(I,1), ZZZ(I,1)
write(*,*) EP_G1(I,1), "expected: >0"
!write(*,*) "channel logical", inchannel, "expected: T"
write(*,*) topy
if (YLOC .ge. topy .and. EP_G1(I,1) .le. dble(0.01)) write(*,*) "FAILED"


XLOC=930
YLOC=108
ZLOC=300
call edgesdose(width, lambda, depth, Xloc, Yloc, Zloc,slope,topy,inchannel)
call FUNIJK_dble(xloc,  yloc, zloc, I)
write(*,*) "test12"
write(*,*) xloc, yloc, zloc !, XXX(I,1), YYY(I,1), ZZZ(I,1)
write(*,*) EP_G1(I,1), "expected: >0"
!write(*,*) "channel logical", inchannel, "expected: T"
write(*,*) topy
if (YLOC .ge. topy .and. EP_G1(I,1) .le. dble(0.01)) write(*,*) "FAILED"        
                                                                   
XLOC=750
YLOC=141
ZLOC=300
call edgesdose(width, lambda, depth, Xloc, Yloc, Zloc,slope,topy,inchannel)
call FUNIJK_dble(xloc,  yloc, zloc, I)
write(*,*) "test13"
write(*,*) xloc, yloc, zloc !, XXX(I,1), YYY(I,1), ZZZ(I,1)
write(*,*) EP_G1(I,1), "expected: >0"
!write(*,*) "channel logical", inchannel, "expected: T"
write(*,*) topy
if (YLOC .ge. topy .and. EP_G1(I,1) .le. dble(0.01)) write(*,*) "FAILED"

XLOC=753
YLOC=141
ZLOC=300
call edgesdose(width, lambda, depth, Xloc, Yloc, Zloc,slope,topy,inchannel)
call FUNIJK_dble(xloc,  yloc, zloc, I)
write(*,*) "test14"
write(*,*) xloc, yloc, zloc !, XXX(I,1), YYY(I,1), ZZZ(I,1)
write(*,*) EP_G1(I,1), "expected: >0"
!write(*,*) "channel logical", inchannel, "expected: T"
write(*,*) topy
if (YLOC .ge. topy .and. EP_G1(I,1) .le. dble(0.01)) write(*,*) "FAILED"

XLOC=900
YLOC=114
ZLOC=300
call edgesdose(width, lambda, depth, Xloc, Yloc, Zloc,slope,topy,inchannel)
call FUNIJK_dble(xloc,  yloc, zloc, I)
write(*,*) "test15"
write(*,*) xloc, yloc, zloc !, XXX(I,1), YYY(I,1), ZZZ(I,1)
write(*,*) EP_G1(I,1), "expected: >0"
!write(*,*) "channel logical", inchannel, "expected: T"
write(*,*) topy
if (YLOC .ge. topy .and. EP_G1(I,1) .le. dble(0.01)) write(*,*) "FAILED"
diff=0
sumf=0
I=1
n=0
do zc=3,ZMAX-2 
     do rc=3,RMAX-2
        do yc=3,YMAX-2

                call FUNIJK(rc, yc, zc, t) 
                XLOC=XXX(t,1)
                Yloc=YYY(t,1)
                ZLOC=ZZZ(t,1)
                call edgesdose(width, lambda, depth, Xloc, Yloc, Zloc,slope,topy,inchannel)
                if (topy .lt. 0) write(*,*) topy
                !call checktop(XLOC,truetop,ZLOC, foundtop)
                !call FUNIJK(rc, int(truetop/DX(1)), zc, t)
                foundtop=.FALSE. 
                if ( YLOC .lt. topy .and. EP_G1(t,1) .le. dble(0.0001)) then 
                        foundtop=.TRUE.
                end if 
                if (YLOC .ge. topy .and. EP_G1(t,1) .ge. dble(0.0001)) then 
                        foundtop=.TRUE.
                end if 
                !if ( .NOT. foundtop) write(*,*) t, XLOC, YLOC, ZLOC, topy, EP_G1(t,1) 
               ! if (topy .le. 3) write(*,*) XLOC, YLOC, ZLOC, topy, EP_G1(I,1)
                if (foundtop) sumf=sumf+1
                n=n+1
          end do 
    end do
end do 

! 08/10 strangely only 95% of cells pass 
! points such as 645.000000000000        93.0000000000000
! 588.000000000000 
! fail 
write(*,*) "***************************"
print*, sumf, "passed of", n, sumf/(n), "%"
write(*,*) "***************************"


XLOC=774
YLOC=135
ZLOC=648
call edgesdose(width, lambda, depth, Xloc, Yloc, Zloc,slope,topy,inchannel)
call FUNIJK_dble(xloc,  yloc, zloc, I)

write(*,*) "test16"
write(*,*) xloc, yloc, zloc !, XXX(I,1), YYY(I,1), ZZZ(I,1)
write(*,*) EP_G1(I,1), "expected: >0"
write(*,*) "channel logical", inchannel, "expected: T"
write(*,*) topy
if (YLOC .ge. topy .and. EP_G1(I,1) .le. dble(0.01)) write(*,*) "FAILED"



XLOC=489
YLOC=363
ZLOC=432
call edgesdose(width, lambda, depth, Xloc, Yloc, Zloc,slope,topy,inchannel)
call FUNIJK_dble(xloc,  yloc, zloc, I)
write(*,*) "test17"
write(*,*) xloc, yloc, zloc !, XXX(I,1), YYY(I,1), ZZZ(I,1)
write(*,*) EP_G1(I,1), "expected: >0"
write(*,*) "channel logical", inchannel, "expected: F"
write(*,*) topy
if (YLOC .ge. topy .and. EP_G1(I,1) .le. dble(0.01)) write(*,*) "FAILED"


XLOC=837
YLOC=123
ZLOC=621
call edgesdose(width, lambda, depth, Xloc, Yloc, Zloc,slope,topy,inchannel)
call FUNIJK_dble(xloc,  yloc, zloc, I)
write(*,*) "test18"
write(*,*) xloc, yloc, zloc !, XXX(I,1), YYY(I,1), ZZZ(I,1)
write(*,*) EP_G1(I,1), "expected: 0"
write(*,*) "channel logical", inchannel, "expected: F"
write(*,*) topy
if (YLOC .ge. topy .and. EP_G1(I,1) .le. dble(0.01)) write(*,*) "FAILED"
if (YLOC .le. topy .and. EP_G1(I,1) .ge. dble(0.01)) write(*,*) "FAILED"



XLOC=1104
YLOC=75
ZLOC=477
call edgesdose_debug(width, lambda, depth, Xloc, Yloc,Zloc,slope,topy,inchannel)
call FUNIJK_dble(xloc,  yloc, zloc, I)
write(*,*) "test19"
write(*,*) I, xloc, yloc, zloc !, XXX(I,1), YYY(I,1), ZZZ(I,1)
write(*,*) EP_G1(I,1), "expected: 1 "
write(*,*) "channel logical", inchannel, "expected: T"
write(*,*) topy
if (YLOC .ge. topy .and. EP_G1(I,1) .le. dble(0.01)) write(*,*) "FAILED"
if (YLOC .le. topy .and. EP_G1(I,1) .ge. dble(0.01)) write(*,*) "FAILED"

write(*,*) " **************** edge tests ********************" 

XLOC=753
YLOC=141
ZLOC=300
write(*,*) XLOC, YLOC, ZLOC
call edges(width, lambda, depth, XLOC, slope, edge1, edge2, bottom, topy)
call edgesdose(width, lambda, depth, Xloc, Yloc, Zloc,slope,topy,inchannel)
write(*,*) "expecting:", 539.92
write(*,*) edge1, edge2
write(*,*) "expecting:", 539.9-width/2, 539.9+width/2
write(*,*) "expecting: F", inchannel

XLOC=753
YLOC=120
ZLOC=500
write(*,*) XLOC, YLOC, ZLOC
call edges(width, lambda, depth, XLOC, slope, edge1, edge2, bottom, topy)
call edgesdose(width, lambda, depth, Xloc, Yloc, Zloc,slope,topy,inchannel)
write(*,*) "expecting:", 539.92, "top", topy
write(*,*) edge1, edge2
write(*,*) "expecting:", 539.9-width/2, 539.9+width/2
write(*,*) "expecting: T", inchannel
call  FUNIJK_dble(XLOC, YLOC, ZLOC, I)
write(*,*) "expecting >0", EP_G1(I,1)
XLOC=753
YLOC=150
ZLOC=500
write(*,*) XLOC, YLOC, ZLOC
call edges(width, lambda, depth, XLOC, slope, edge1, edge2, bottom, topy)
call edgesdose(width, lambda, depth, Xloc, Yloc, Zloc,slope,topy,inchannel)
write(*,*) "expecting:", 539.92, "top", topy
write(*,*) edge1, edge2
write(*,*) "expecting:", 539.9-width/2, 539.9+width/2
write(*,*) "expecting: F", inchannel


XLOC=753
YLOC=120
ZLOC=540
write(*,*) XLOC, YLOC, ZLOC
call edges(width, lambda, depth, XLOC, slope, edge1, edge2, bottom, topy)
call edgesdose(width, lambda, depth, Xloc, Yloc, Zloc,slope,topy,inchannel)
write(*,*) "expecting:", 539.92, "top", topy
write(*,*) edge1, edge2
write(*,*) "expecting:", 539.9-width/2, 539.9+width/2
write(*,*) "expecting: T", inchannel
call  FUNIJK_dble(XLOC, YLOC, ZLOC, I)
write(*,*) "expecting >0", EP_G1(I,1)

XLOC=753
YLOC=120
ZLOC=645
write(*,*) XLOC, YLOC, ZLOC
call edges(width, lambda, depth, XLOC, slope, edge1, edge2, bottom, topy)
call edgesdose(width, lambda, depth, Xloc, Yloc, Zloc,slope,topy,inchannel)
write(*,*) "expecting:", 539.92, "top", topy
write(*,*) edge1, edge2
write(*,*) "expecting:", 539.9-width/2, 539.9+width/2
write(*,*) "expecting: F", inchannel
call  FUNIJK_dble(XLOC, YLOC, ZLOC, I)
write(*,*) "expecting 0", EP_G1(I,1)

XLOC=753
YLOC=120
ZLOC=648
write(*,*) XLOC, YLOC, ZLOC
call edges(width, lambda, depth, XLOC, slope, edge1, edge2, bottom, topy)
call edgesdose(width, lambda, depth, Xloc, Yloc, Zloc,slope,topy,inchannel)
write(*,*) "expecting:", 539.92, "top", topy
write(*,*) edge1, edge2
write(*,*) "expecting:", 539.9-width/2, 539.9+width/2
write(*,*) "expecting: F", inchannel
call  FUNIJK_dble(XLOC, YLOC, ZLOC, I)
write(*,*) "expecting 0", EP_G1(I,1)

XLOC=753
YLOC=150
ZLOC=540
write(*,*) XLOC, YLOC, ZLOC
call edges(width, lambda, depth, XLOC, slope, edge1, edge2, bottom, topy)
call edgesdose(width, lambda, depth, Xloc, Yloc, Zloc,slope,topy,inchannel)
write(*,*) "expecting:", 539.92, "top", topy
write(*,*) edge1, edge2
write(*,*) "expecting:", 539.9-width/2, 539.9+width/2
write(*,*) "expecting: F", inchannel
call  FUNIJK_dble(XLOC, YLOC, ZLOC, I)
write(*,*) "expecting >0", EP_G1(I,1)


XLOC=753
YLOC=120
ZLOC=441
write(*,*) XLOC, YLOC, ZLOC
call edges(width, lambda, depth, XLOC, slope, edge1, edge2, bottom, topy)
call edgesdose(width, lambda, depth, Xloc, Yloc, Zloc,slope,topy,inchannel)
write(*,*) "expecting:", 539.92, "top", topy
write(*,*) edge1, edge2
write(*,*) "expecting:", 539.9-width/2, 539.9+width/2
write(*,*) "expecting: F", inchannel
call  FUNIJK_dble(XLOC, YLOC, ZLOC, I)
write(*,*) "expecting 0", EP_G1(I,1)

XLOC=753
YLOC=120
ZLOC=444
write(*,*) XLOC, YLOC, ZLOC
call edges(width, lambda, depth, XLOC, slope, edge1, edge2, bottom, topy)
call edgesdose(width, lambda, depth, Xloc, Yloc, Zloc,slope,topy,inchannel)
write(*,*) "expecting:", 539.92, "top", topy
write(*,*) edge1, edge2
write(*,*) "expecting:", 539.9-width/2, 539.9+width/2
write(*,*) "expecting: F", inchannel
call  FUNIJK_dble(XLOC, YLOC, ZLOC, I)
write(*,*) "expecting 0", EP_G1(I,1)

XLOC=753
YLOC=120
ZLOC=447
write(*,*) XLOC, YLOC, ZLOC
call edges(width, lambda, depth, XLOC, slope, edge1, edge2, bottom, topy)
call edgesdose(width, lambda, depth, Xloc, Yloc, Zloc,slope,topy,inchannel)
write(*,*) "expecting:", 539.92, "top", topy
write(*,*) edge1, edge2
write(*,*) "expecting:", 539.9-width/2, 539.9+width/2
write(*,*) "expecting: T", inchannel
call  FUNIJK_dble(XLOC, YLOC, ZLOC, I)
write(*,*) "expecting >0", EP_G1(I,1)

write(*,*) " **************** area test **************"

areac=0
I=1
        do zc=2,ZMAX-1
                do rc=3,RMAX-2
                        do yc=3,YMAX-2
                        call funijk(rc, yc, zc, I) 
                        call edgesdose(width, lambda, depth, XXX(I,1), YYY(I,1),ZZZ(I,1), slope, topy,inchannel)
                        !write(*,*) XXX(I,1), YYY(I,1),ZZZ(I,1)
                        !write(*,*)                         
                        if ( YYY(I,1) .eq. topy )then
                                areac=areac+1
                        end if

                        
                        end do
                end do
        end do

        write(*,*) "expecting:", 300*400 , areac

write(*,*) 
write(*,*) " **************** I test  **************"
write(*,*)
XLOC=753
YLOC=120
ZLOC=447

rc=int(XLOC/DX(1))
yc=int(YLOC/DX(1))
zc=int(ZLOC/DX(1))

call funijk(rc,yc,zc, I) 
call funijk_dble(XLOC,YLOC,ZLOC, t) 

write(*,*) XLOC, rc, YLOC, yc, ZLOC, zc, I, t,(1+(yc-1)+(rc-1)*YMAX+(zc-1)*YMAX*RMAX) 
sumf=0
do zc=4,ZMAX-4
     do rc=4,RMAX-4
        do yc=4,YMAX-4

                call FUNIJK(rc, yc, zc, t)
                XLOC=DX(1)*rc 
                YLOC=DX(1)*yc
                ZLOC=DX(1)*zc 

                call funijk_dble(XLOC, YLOC, ZLOC, I) 

                !if (I .ne. t)  sumf=sumf+1 !write(*,*) I, t

                XLOC=XXX(t,1) 
                YLOC=YYY(t,1)
                ZLOC=ZZZ(t,1) 
                
                call funijk_dble(XLOC, YLOC, ZLOC, I)

                if (I .ne. t) then 
                        sumf=sumf+1 !write(*,*) I, t
                        !write(*,*) DX(1)*rc, DX(1)*yc, DX(1)*zc, XLOC, YLOC,ZLOC
                end if 
        end do 
    end do 
end do 

write(*,*) sumf, "of", 400*299*150, "tests failed", sumf/(400*299*150)

XLOC=1206
YLOC=456


write(*,*) "ZZZs don't match "
do zc=3,ZMAX-2
        ZLOC=DX(1)*zc         
        call funijk_dble(XLOC, YLOC, ZLOC, I)
        call funijk_dble(XLOC,YLOC,ZZZ(I,1), t)
        if (ZLOC .ne. ZZZ(I,1)) write(*,*) ZLOC, ZZZ(I,1), I, t 
       
end do 

ZLOC=459
        call funijk_dble(XLOC, YLOC, ZLOC, I)
        call funijk_dble(XLOC,YLOC,ZZZ(I,1), t)
        WRIte(*,*) ZLOC, ZZZ(I,1), I, t
ZLOC=483
        call funijk_dble(XLOC, YLOC, ZLOC, I)
        call funijk_dble(XLOC,YLOC,ZZZ(I,1), t)
        write(*,*) ZLOC, ZZZ(I,1), I, t

!call logvolfrc(EP_G1, EPP)
!call dynamicpressure(EP_G1, U_S1, V_S1, W_S1, DPU)

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

