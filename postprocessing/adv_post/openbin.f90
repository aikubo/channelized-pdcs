module openbinary 
  contains  
    subroutine openbin(numunit, filename, varname)
        use parampost 
        use constants
        implicit none 
        
        integer:: II
     
        integer, intent(IN) :: numunit
        character(LEN=*), intent(in) :: filename
        DOUBLE PRECISION, DIMENSION(:,:), INTENT(OUT) :: varname
       
        OPEN(UNIT=numunit, file=filename, form='unformatted')
        REWIND(numunit)

                DO II=1,timesteps
                        READ(numunit) varname(:,II)

                        print*, II
                END DO
        !write(*,*) varname 
    
   end subroutine openbin
end module openbinary

