module maxout

use parampost 
use constants
use formatmod 
use maketopo

contains 
        subroutine dxmaxof(field, filename)
        double precision, allocatable, intent(in):: field(:,:) 
        character(len=*), intent(in):: filename 
        double precision, allocatable:: fieldmax(:)
        ! find max of all timesteps and writes out for opendx !
        open(9898, file=filename, form='formatted')
        do t=1,timesteps
                do i=1,length1
                        if ( field(t,i) .gt. fieldmax(i)) then 
                                fieldmax(i)=field(t,i) 
                        end if 
                end do 
        end do 

        do i=1,length1
                write(9898, format4var) fieldmax(i), XXX(i,1), YYY(i,1), ZZZ(i,1)
        end do

        end subroutine 


        subroutine dxminof(field, filename)
        double precision, allocatable, intent(in):: field(:,:)
        character(len=*), intent(in):: filename
        double precision, allocatable:: fieldmin(:)
        ! find max of all timesteps and writes out for opendx !
        open(98990, file=filename, form='formatted')
        do t=1,timesteps
                do i=1,length1
                        if ( field(t,i) .lt. fieldmin(i)) then   
                                fieldmin(i)=field(t,i)
                        end if
                end do
        end do

         do i=1,length1
                write(98990, format4var) fieldmin(i), XXX(i,1), YYY(i,1),ZZZ(i,1)
        end do
        end subroutine
                            
end module    
                    
