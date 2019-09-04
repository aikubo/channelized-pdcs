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
                print*, "opening bin"
                DO II=1,timesteps
                        READ(numunit) varname(:,II)
                END DO
    
   end subroutine openbin
end module openbinary

