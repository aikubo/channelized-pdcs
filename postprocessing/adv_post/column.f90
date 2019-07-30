module column

contains 
        subroutine setup_col()
        end subroutine setup_col 

        subroutine slice( XLOC, ZLOC)
          use parampost 
          use constants
          use alloc_arays
          implicit none 
          call allocate_arrays
          INTEGER, INTENT(IN):: XLOC, YLOC
           DO I= 1, length1
              dpu(I,t)= (1-EP_G1(I,t))*1950*(U_S1(I,t)*U_S1(I,t))
               EP_P = -LOG10(1-EP_G1(I,t)+1e-14)
                  IF ( EP_P .GT. 0 .AND. EP_P .LT. 6.5) THEN
                   IF( ZZZ(I,1) .EQ. ZLOC) THEN
                    IF( XXX(I,1) .EQ. XLOC) THEN
                      WRITE(middle,405) YYY(I,1), EP_P, U_G(I,t), Ri(I,5), T_G(I,t)
                    END IF
                   END IF
                  END IF 
           END DO 
        405 FORMAT(5F22.12)
        400 FORMAT(4F22.12)
        return
       end subroutine slice

IMPLICIT NONE 


OPEN(100, file='EP_G', form='unformatted')
OPEN(101, file='T_G', form='unformatted')
OPEN(102, file='U_G', form='unformatted')
OPEN(103, file='U_S1', form='unformatted')

call allocate_arrays 

t=5
str_c = '(I2.2)'
write(x1,str_c) t
OPEN(1500,FILE='Richardson_t'//trim(x1)//'.txt')


REWIND(100)
DO I=1,timesteps
     READ(100) EP_G1(:,I)END DO

slabx1 = 200 
slabz1 = 100 
slabx2 = 600
slabz2 = 100

do t=1,9 

        str_c = '(I2.2)'
        write(x1,str_c) t

        num_open=2300 +t 
        OPEN(num_open, FILE='slice_middle'//trim(x1)//'.txt')
        num_open=2400 +t
        OPEN(num_open, FILE='slice_right'//trim(x1)//'.txt')
        num_open=2500 +t
        open(num_open, file='slice_left'//trim(x1)//'.txt')
        num_open=2600 +t
        open(num_open, file='slice_out'//trim(x1)//'.txt')

end do

DO t= 1,9
        middle = 2300+t
        right= 2400+t
        left= 2500+t
        outter= 2600+t

        str_c = '(I2.2)'
        write(x1,str_c) t
        OPEN(1500,FILE='Richardson_t'//trim(x1)//'.txt')


        DO I=1,length1
                READ(1500,*) Ri(I,1:5)
        END DO

DO I= 1, length1
 dpu(I,t)= (1-EP_G1(I,t))*1950*(U_S1(I,t)*U_S1(I,t))
 EP_P = -LOG10(1-EP_G1(I,t)+1e-14)
 IF ( EP_P .GT. 0 .AND. EP_P .LT. 6.5) THEN 
 !J = XXX(I,1)/2
 !bottom = tand(M)*2*(400-J)+20-18
  ! print*, EP_P
    IF( ZZZ(I,1) .EQ. 150) THEN
      !print*, EP_P, XXX(I,1) 
        IF( XXX(I,1) .EQ. 200) THEN 
        !dpu(I,t)= (1-EP_G1(I,t))*1950*(U_S1(I,t)*U_S1(I,t))
        WRITE(middle,405) YYY(I,1), EP_P, U_G(I,t), Ri(I,5), T_G(I,t) 
               ! print*, YYY(I,1)                 
!       !        END IF
       END IF
       END IF

    IF( ZZZ(I,1) .EQ. 100) THEN
      !print*, EP_P, XXX(I,1) 
        IF( XXX(I,1) .EQ. 200) THEN
        WRITE(right,405) YYY(I,1), EP_P, U_G(I,t), Ri(I,1), T_G(I,t)
               ! print*, YYY(I,1)                 
!       !        END IF
       END IF
       END IF

    IF( ZZZ(I,1) .EQ. 200) THEN
      !print*, EP_P, XXX(I,1) 
        IF( XXX(I,1) .EQ. 200) THEN
        WRITE(left,405) YYY(I,1), EP_P, U_G(I,t), Ri(I,1), T_G(I,t)
               ! print*, YYY(I,1)                 
!       !        END IF
       END IF
       END IF    

    IF( ZZZ(I,1) .EQ. 300) THEN
      !print*, EP_P, XXX(I,1) 
        IF( XXX(I,1) .EQ. 200) THEN
        WRITE(outter,405) YYY(I,1), EP_P, U_G(I,t), Ri(I,1), T_G(I,t)
               ! print*, YYY(I,1)                 
!       !        END IF
       END IF
       END IF


   END IF
END DO
END DO 

405 FORMAT(5F22.12)
400 FORMAT(4F22.12)
RETURN 
END SUBROUTINE column
