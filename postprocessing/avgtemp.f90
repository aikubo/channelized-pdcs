! Calculates average temp
!for Channelized PDC on various slopes 
! 
! Written by Allison Kubo, November 2017
! loads ASCII data: temperature (TG) and volume fraction data (EPG)

IMPLICIT NONE
 
INTEGER::I,J,K,IMAX,JMAX,ZMAX,timesteps,t, Z, io2, io1 
REAL :: M, D, DX, DY
DOUBLE PRECISION, ALLOCATABLE :: EPG(:,:), TG(:,:)
DOUBLE PRECISION :: PART  
DOUBLE PRECISION :: AVGTDILUTE, AVGTMED, AVGTDENSE, TDENSE, TMED, TDILUTE, TTOPO
DOUBLE PRECISION :: max_dilute, min_dense, max_dense, min_dilute
INTEGER :: SUM1, SUM2, SUM3, SUM4 
INTEGER :: t1,t2, clock_rate, clock_max


CALL SYSTEM_CLOCK(t1, clock_rate, clock_max) 
!print*, clock_rate, clock_max 

 
OPEN(100,FILE='EPG',form='formatted')
OPEN(300, file='TG', form= 'formatted')
OPEN(301, file= 'avgT1', form= 'formatted')
OPEN(302, FILE= 'avgT2', FORM = 'FORMATTED')
OPEN(303, file = 'avgT3', form = 'formatted')

timesteps = 10
IMAX=404 !352!179
ZMAX=152 !42 !102
JMAX=204 !304 !169
M = 20   !5 !10 !20     ! slope of channel (degrees)
D = 18    !6 !12 !18     ! depth of channel (meters)   
DX = 2   !X resolution
DY = 2   !Y resolution

!LOG value for dilute currents 
max_dilute = 6.5 
min_dilute = 5.5
max_dense = 2.5
min_dense = 1.5


ALLOCATE( EPG(IMAX*JMAX*ZMAX,timesteps))
ALLOCATE( TG(IMAX*JMAX*ZMAX,timesteps))
!ALLOCATE( PART(IMAX*JMAX*ZMAX,timesteps))


REWIND(100) 
REWIND(300)

DO I= 1, timesteps
    READ(100,*, IOSTAT=io1) EPG(:,I)  
 IF (io1 > 0) THEN
      WRITE(*,*) 'Check input.  Something was wrong'
      EXIT
    ELSE IF (io1 < 0) THEN
      WRITE(*,*)  'reach end of EPG file @', I
      EXIT             
   END IF
END DO


DO I= 1, timesteps
    READ(300,*, IOSTAT=io2) TG(:,I)
   IF (io2 > 0) THEN
      WRITE(*,*) 'Check input.  Something was wrong'
      EXIT
   ELSE IF (io2 < 0) THEN
      WRITE(*,*)  'reach end of TG file @', I
      EXIT   
   END IF
END DO


PRINT*, 'CALCULATE AVERAGE TEMPERATURE FOR DENSE AND DILUTE CURRENT'
        SUM1 = 0
        SUM2 = 0
        TDILUTE = 0
        TMED = 0
        TDENSE = 0



DO t =1,timesteps
 DO I = 1, IMAX*JMAX*ZMAX

    PART = EPG(I,t)

         IF (PART <0.99999) THEN 
             SUM1 = SUM1 + 1 
             TDILUTE = TG(I,t) + TDILUTE
         END IF 

         IF (PART< 0.999) THEN 
             SUM2 = SUM2 + 1
             TMED = TG(I,t) + TMED
         END IF 

         IF (PART<0.99) THEN 
            SUM3 = SUM3 +1 
            TDENSE = TG(I,t) + TDENSE 
         END IF

         IF (PART .EQ. 0 ) THEN 
         SUM4 = SUM4 + 1 
         TTOPO = TTOPO + TG(I,t) 
         END IF  
  END DO  
AVGTDILUTE = (TDILUTE-TTOPO)/(SUM1-SUM4) 
AVGTMED = (TMED-TTOPO)/(SUM2-SUM4)
AVGTDENSE = (TDENSE-TTOPO)/(SUM3-SUM4) 

WRITE(301, 802) t, AVGTDILUTE 
WRITE(302, 802) t, AVGTMED 
WRITE(303, 802) t, AVGTDENSE

END DO 



 !         PART = -LOG10(1-EPG(I,t)+1e-14)
 !                    IF (PART(I,t)<min_dilute .AND. PART(I,t)>max_dense) THEN
 !                       TEMP_DILUTE = TEMP_DILUTE + TG(I,t)
 !                       SUM1 = SUM1 + 1
 !                       print*, SUM1
 !                    END IF 
                     
 !                    IF (PART(I,t)<min_dense .AND. PART(I,t)>0) THEN
 !                       TEMP_DENSE = TEMP_DENSE + TG(I,t) 
 !                       SUM2 = SUM2 + 1     
 !                       print*, SUM2         
 !                    END IF 
! END DO 
  
!  AVGT_DILUTE = TEMP_DILUTE/SUM1
!  AVGT_DENSE = TEMP_DENSE/SUM2 

!PRINT*, 'AVGT_DILUTE', AVGT_DILUTE 
!PRINT*, 'AVGT_DILUTE', AVGT_DENSE

!WRITE(301,*) t, AVGT_DILUTE 
!WRITE(302,*) t, AVGT_DENSE

!END DO 

print *, "Program Complete"
CALL SYSTEM_CLOCK(t2, clock_rate, clock_max )
 print *, t2, clock_rate, clock_max
 print *, 'Elapsed Time = ', real(t2-t1)/real(clock_rate)/60.0,'minutes'

802 FORMAT(i7,F22.5)
                       

END PROGRAM
