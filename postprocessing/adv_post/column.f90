module column
use formatmod
use parampost
use constants
use openbinary
use maketopo
use makeascii
use var_3d
use filehead 

contains 
!        subroutine setup_col()
!        end subroutine setup_col 

        subroutine slice(width, depth, lambda, XC, ZC, locstring, numunit)
        use formatmod 
       
        implicit none 
          !call allocate_arrays
          CHARACTER(len=*), intent(IN):: locstring
          integer, intent(IN):: numunit
          DOUBLE PRECISION, INTENT(IN):: width, lambda, depth, XC, ZC
          DOUBLE PRECISION:: VOLFR, DYNAM
          DOUBLE PRECISION:: clearance, slope, dx
          DOUBLE PRECISION :: hill
          double precision:: XLOC, ZLOC
          character(3)::Xstring, zstring      
          CHARACTER(LEN=10) :: str_b
                
          str_b= '(I3.1)'
          write(xstring,str_b) InT(XC)
          write(zstring,str_b) int(ZC)

         
          routine="column.mod/slice"
          description='Veritcal column at x'//trim(xstring)//'_z'//trim(zstring)
          datatype=" t  YYY  EPP   U_G   DPU   T_G   Ri"
          print*, xstring, zstring
          filename='slice_'//locstring//'.txt'
          print*, "open slice file", xstring, zstring 
          call headerf(numunit, filename, simlabel, routine, DESCRIPTION, datatype)

          print*, "start checking column"
           DO t=1,timesteps
            print*,t
            DO I= 1, length1
              !DYNAM= (1-EP_G1(I,t))*1950*(U_S1(I,t)*U_S1(I,t))
              ! VOLFR = -LOG10(1-EP_G1(I,t)+1e-14)
                !PRINT*, VOLFR
                ! IF ( YYY(I,1) .GT. hill .AND. YYY(I,1) .LT. hill+102 ) THEN
                   IF( ZZZ(I,1) .EQ. ZC) THEN
                !        print*, ZZZ(I,1) 
                    IF( XXX(I,1) .EQ. XC) THEN
                       ! print*, XXX(I,1)
                      IF(EPP(I,t) .GT. 0.00) THEN
                      !print*, YYY(I,1)-hill, Ri_all(I,1,t) 
                      WRITE(numunit,format7col) t, YYY(I,1), EPP(I,t), U_G1(I,t), DPU(I,t), T_G1(I,t), Ri(I,t)
                      end if 
                 !     END IF
                   END IF
                  END IF 
                end do
           END DO 
         end subroutine slice

        SUBROUTINE SLICES2
        use maketopo
        implicit none 
        double precision:: ZLOC, XLOC 
        print*, "slices"
        XLOC=300
        call edges(width, lambda, depth, XLOC, edge1, edge2, bottom, top)
        ZLOC=floor((edge2-width/2)/3)*3  ! mid line 
        print*, XLOC, ZLOC
        CALL SLICE(width, depth, lambda, XLOC, ZLOC, 'middle',  10001)
        print*, XLOC, ZLOC 
        XLOC=floor((lambda)*(0.5)/3)*3
        call edges(width, lambda, depth, XLOC, edge1, edge2, bottom, top)
        ZLOC=floor((edge2+6)/3)*3
        print*, XLOC, ZLOC

        call slice(width, depth, lambda, XLOC, ZLOC, 'halfl', 10002)        

        XLOC=floor((lambda)/3)*3
        call edges(width, lambda, depth, XLOC, edge1, edge2, bottom, top)
        ZLOC=floor((edge2+6)/3)*3
        print*, XLOC, ZLOC
        call slice(width, depth, lambda, XLOC, ZLOC, 'onel', 10003)


        XLOC=floor((lambda)*(0.75)/3)*3
        call edges(width, lambda, depth, XLOC, edge1, edge2, bottom, top)
        ZLOC=floor((edge2+100)/3)*3
        print*, XLOC, ZLOC

        call slice(width, depth, lambda, XLOC, ZLOC, '3quarter_100m', 10003)        





        end subroutine 

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
