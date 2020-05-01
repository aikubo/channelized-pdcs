module tracemod

contains 
subroutine tracerpost
use formatmod
use parampost
use constants

implicit none 
integer:: ttrace,rows, maxtracers, ii,kk,jj
integer:: sum_on, sum_in
double precision, allocatable:: TRACERS(:,:,:)
        write(*,*) "entering tracers" 

 
        ttrace=50
        maxtracers =558
        rows=ttrace*maxtracers
        allocate(TRACERS(ttrace,maxtracers,8))
        
        open(66666, file="TRACERS.txt", form="formatted")

        open(66667, file="TRACER_POST.txt", form="formatted")

        do kk=1,ttrace
                do ii=1,maxtracers
                        read(66666,*) TRACERS(kk,ii,:)
                end do 
        end do

        write(*,*) "counting"

        do kk=1,ttrace
                sum_on=0
                sum_in=0

                do ii=1,maxtracers
                        sum_on=sum_on+TRACERS(kk,ii,3)
                        
                        if ( TRACERS(kk,ii,3) .eq. dble(1.0) ) then 

                                sum_in=sum_in+TRACERS(kk,ii,7)
        
                        end if 
                end do 


                write(66667,100) kk, sum_on, sum_in, dble(sum_in)/dble(sum_on)

        end do 




        write(*,*) "tracemod complete"
        

        100 format(3I4, F10.5)
end subroutine 

end module 

