program epg

use parampost 
use constants
use openbinary 
use maketopo 
use makeascii
use var_3d
!use formatmod
implicit none
timesteps = 3

call ALLOCATE_ARRAYS

call openbin(100, 'EP_G', EP_G1) 
print*, 'testing handle topo'
call handletopo('topo_sin_20_l400_w50', XXX, YYY, ZZZ)
call writedxtopo

call make3dvar

call makedxfiles

end program

