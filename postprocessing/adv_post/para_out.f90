module para_out 

contains 
        subroutine paraIO(field,nunit,t)
        double precision, allocatable, intent(in):: field 
        integer, intent(in):: nunuit, t
        integer:: i, thisunit
       
        do i=1,length1
                write(thisunit, paraout) 
        end do 
