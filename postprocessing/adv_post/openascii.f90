module makeascii 
  contains

    

  
    subroutine openascii(numunit, filen)
        use parampost 
        use constants
        implicit none 
        
        CHARACTER(LEN=10) :: str_c
        character(LEN=10) :: x1
        integer, intent(IN) :: numunit
        character(LEN=*), intent(in) :: filen
         
        str_c = '(I2.2)'      

        DO t=1,timesteps 
                write(x1,str_c) t 
       
                num_open= numunit + t
                print*, filen, ' written as unit number ', num_open
                open(num_open, file=filen//trim(x1)//'.txt')
        
        END DO
        !write(*,*) varname 
        print*, filen, ' written as unit number ', numunit
 
   end subroutine openascii
end module makeascii

