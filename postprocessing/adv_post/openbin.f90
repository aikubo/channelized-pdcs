module openbinary 
  contains  
    subroutine openbin(numunit, filen, varname)
        use parampost 
        use constants
        implicit none 
        
        integer:: II
     
        integer, intent(IN) :: numunit
        character(LEN=*), intent(in) :: filen
        DOUBLE PRECISION, DIMENSION(:,:), INTENT(OUT) :: varname
       
        OPEN(UNIT=numunit, file=filen, form='unformatted')
        REWIND(numunit)
                print*, "opening bin"
                DO II=1,timesteps
                        READ(numunit) varname(:,II)
                END DO
    
   end subroutine openbin
end module openbinary

