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

simlabel='ANX4'
printstatus=0


allocate(isosurface(1200,4,15))
RMAX=404
YMAX=154
ZMAX=302
length1=RMAX*YMAX*ZMAX
width=102
lambda=300
amprat=0.15
deltat=5.0
timesteps=8
tstart=3
tstop=timesteps
depth = 27

call ALLOCATE_ARRAYS

!print*, 'testing openbin'
all openbin(200, 'U_G', U_G1)
call openbin(300, 'T_G', T_G1)
call openbin(400, 'V_G', V_G1)
call openbin(500, 'W_G', W_G1)
call handletopo('l300_A9_W102', XXX, YYY, ZZZ)

call makeUG(1200, U_G, printstatus) 
print*, "end program"

end program

