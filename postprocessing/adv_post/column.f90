module column
use formatmod
use parampost
use constants
use openbinary
use maketopo
use makeascii
use var_3d

contains 
!        subroutine setup_col()
!        end subroutine setup_col 

        subroutine slice(numunit, XLOC, ZLOC)
        use formatmod 
        implicit none 
          !call allocate_arrays
          DOUBLE PRECISION, INTENT(IN):: XLOC, ZLOC
          INTEGER, INTENT(IN):: numunit
          DOUBLE PRECISION:: VOLFR, DYNAM
          DOUBLE PRECISION:: clearance, slope, dx
          DOUBLE PRECISION, ALLOCATABLE :: hill(:)
          ALLOCATE(hill(length1))

          clearance = 50.
          slope=0.18
          dx=3.0
         
          
          !I=1
          !do zc=1,ZMAX
          !do rc=1,RMAX
          !do yc=1,YMAX
          !      hill(I)=  slope*dx*(rc)+clearance-depth
          !      I=I+1
          !end do               
          !end do 
          !end do      
          !print*, hill(1:RMAX)   

          print*, "start checking column"
           DO t=1,timesteps
            print*,t
            DO I= 1, length1
              DYNAM= (1-EP_G1(I,t))*1950*(U_S1(I,t)*U_S1(I,t))
               VOLFR = -LOG10(1-EP_G1(I,t)+1e-14)
                !PRINT*, VOLFR
                ! IF ( YYY(I,1) .GT. hill(I) .AND. YYY(I,1) .LT. hill(I)+100 ) THEN
                   IF( ZZZ(I,1) .EQ. ZLOC) THEN
                    IF( XXX(I,1) .EQ. XLOC) THEN
                      IF(VOLFR .GT. 0.00) THEN 
                      WRITE(numunit,format6col) t, YYY(I,1), VOLFR, U_G1(I,t), DYNAM, T_G1(I,t) !, Ri
                    END IF
                   END IF
                  END IF 
                end do
           END DO 
         end subroutine slice

end module 

!program sliceit
!use parampost
!use constants
!use alloc_arrays
!use openbin
!use openascii
!use column
!IMPLICIT NONE 


!call allocate_arrays 

!call openbin(100, 'EP_G', EP_G1)
!call openbin(200, 'U_G', U_G1)
!call openbin(300, 'T_G', T_G1)

!t=4
!str_c = '(I2.2)'
!write(x1,str_c) t
!OPEN(1500,FILE='Richardson_t'//trim(x1)//'.txt')

!DO I=1,length1 
!        READ(1500) Ri(I,:)
!end do

!call handletopo(topo, XXX, YYY, ZZZ) 

!middle = 2500
!OPEN(middle, file='slice_middle04.txt')

!call slice(middle, 200, 150) 
 

!405 FORMAT(5F22.12)
!400 FORMAT(4F22.12)
!end program
