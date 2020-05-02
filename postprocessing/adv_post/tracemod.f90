module tracemod

contains 
subroutine tracerpost
use formatmod
use parampost
use constants
use maketopo
implicit none 
integer:: ttrace,rows, maxtracers, ii,kk,jj
integer:: sum_on, sum_in
double precision, allocatable:: TRACERS(:,:,:)
!double precision::edge1, edge2, bottom, top
        write(*,*) "entering tracers" 

 
        ttrace=10
        maxtracers =1188
        rows=ttrace*maxtracers
        allocate(TRACERS(ttrace,maxtracers,8))
        
        open(66666, file="TRACERS.txt", form="formatted")

        open(66667, file="TRACER_POST.txt", form="formatted")

        do kk=1,ttrace+1
                do ii=1,maxtracers
                        read(66666,*) TRACERS(kk,ii,:)
                end do 
        end do

        write(*,*) "counting"

        do kk=1,ttrace+1
                sum_on=0
                sum_in=0

                do ii=1,maxtracers
                        sum_on=sum_on+TRACERS(kk,ii,3)
                        
                        if ( TRACERS(kk,ii,3) .eq. dble(1.0) ) then 
                                call edges( width, depth, lambda, TRACERS(kk,ii,4),  edge1, edge2,top, bottom)
                                
                                if (TRACERS(kk,ii,5) .lt. top) then 
                                        if (TRACERS(kk,ii,6) .gt. edge1 .and. TRACERS(kk,ii,6) .lt. edge2) then 
                                                sum_in=sum_in+TRACERS(kk,ii,7)
                                        end if 
                                end if 
        
                        end if 
                end do 


                write(66667,100) kk-1, sum_on, sum_in, dble(sum_in)/dble(sum_on)

        end do 




        write(*,*) "tracemod complete"
        

        100 format(3I4, F10.5)
end subroutine 

end module 

