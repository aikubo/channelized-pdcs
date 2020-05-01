module trace

contains 
subroutine tracerpost
use formatmod
use parampost
use constants

implicit none 
integer:: maxtracers, ii,kk,jj
double precision, allocatable:: TRACERS(:,:)
        maxtracers =599
        allocate(TRACERS(maxtracers,6))
        
        open(66666, file="TRACERS.txt", format="formatted")

        do ii=1,maxtracers 
                read(66666,*) TRACERS(ii,:)
        end do 




end subroutine 

end module 

