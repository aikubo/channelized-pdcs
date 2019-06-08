PROGRAM HELPME

IMPLICIT NONE

DOUBLE PRECISION, ALLOCATABLE:: EP_G1(:,:), text(:,:)
INTEGER, DIMENSION(7) :: ugh 
INTEGER :: RMAX,YMAX,ZMAX,I,J,K,t,timesteps


timesteps = 8 

OPEN(1000, FILE='P_G', form='unformatted')
OPEN(1001, file='dpu_t08.txt', form='formatted')


RMAX = 404
YMAX = 152
ZMAX = 204
ALLOCATE(EP_G1(RMAX*YMAX*ZMAX, timesteps))
ALLOCATE(text(RMAX*YMAX*ZMAX, 4))

REWIND(1000)

DO I=1,timesteps
    READ(1000) EP_G1(:,i)
END DO

!DO I=1, RMAX*YMAX*ZMAX
!   READ(1001,*) text(I,:)
!END DO


DO t=1,timesteps
DO I=1,RMAX*ZMAX*YMAX
 !if (text(I,1) .GT. 0) THEN 
 !      print*, text(I,1)
 !END IF 
 iF (EP_G1(I,t) .GT. 600) THEN 
        WRITE(*,*) EP_G1(I,t)
  END IF
END DO
END DO 


END PROGRAM
