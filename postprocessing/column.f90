program column 


DOUBLE PRECISION, ALLOCATABLE:: EP_G1(:,:), dpu(:,:)
DOUBLE PRECISION, ALLOCATABLE:: U_G(:,:)
DOUBLE PRECISION, ALLOCATABLE:: T_G(:,:), U_S1(:,:)
INTEGER:: RMAX, YMAX, ZMAX, I, length1, J, K
INTEGER:: timesteps, t, rc,zc,tc
DOUBLE PRECISION:: y_boundary, plane
DOUBLE PRECISION, ALLOCATABLE :: XX(:,:,:),YY(:,:,:),ZZ(:,:,:),channel_topo(:,:)
DOUBLE PRECISION, ALLOCATABLE :: DY(:),y(:),x(:),theta(:),z(:),DX(:),DTH(:),DZ(:),GZ(:)
DOUBLE PRECISION:: EP_P
DOUBLE PRECISION, ALLOCATABLE::topo2(:),topo3(:,:),topo4(:),topography(:),XXX(:,:),YYY(:,:),ZZZ(:,:)
REAL :: M, bottom
INTEGER:: slabx1, slabx2, slabz2, slabz1
!! constants 

RMAX = 404
YMAX = 204
ZMAX = 152
length1 = RMAX*YMAX*ZMAX
M = 20
timesteps = 9 

!------------OPEN the topography files-------!
OPEN(600,FILE='topography',form='formatted')
OPEN(601,FILE='topo2',form='formatted')
OPEN(602,FILE='topo_sin_20_l400_w50')
!OPEN(603, file='horizontalplane')

!OPEN(604, file='dxplane', form= 'formatted')

OPEN(100, file='EP_G', form='unformatted')
OPEN(101, file='T_G', form='unformatted')
OPEN(102, file='U_G', form='unformatted')
OPEN(103, file='U_S1', form='unformatted')

allocate(EP_G1(length1, timesteps))
allocate(T_G(length1, timesteps))
allocate(U_G(length1, timesteps))
allocate(U_S1(length1, timesteps))
allocate(dpu(length1, timesteps))

allocate(channel_topo(RMAX-4,ZMAX-2))
allocate(topo3(RMAX-4, YMAX-4))
ALLOCATE( XXX(length1,1))
ALLOCATE( topography(length1))
ALLOCATE( topo2(length1))
allocate(topo4(length1))
ALLOCATE( ZZZ(length1,1))
ALLOCATE( YYY(length1,1))
ALLOCATE( XX(RMAX,YMAX,ZMAX))
ALLOCATE( YY(RMAX,YMAX,ZMAX))
ALLOCATE( ZZ(RMAX,YMAX,ZMAX))
ALLOCATE( x(RMAX))
ALLOCATE( y(YMAX))
ALLOCATE( z(ZMAX))
ALLOCATE( DX(RMAX))
ALLOCATE( DY(YMAX))
ALLOCATE( DZ(ZMAX))

REWIND(602)
READ(602,*) channel_topo

!REWIND(603)
!READ(603,*) topo3


REWIND(100)
DO I=1,timesteps
     READ(100) EP_G1(:,I)
END DO

REWIND(101)
DO I=1,timesteps
     READ(101) T_G(:,I)
END DO

REWIND(102)
DO I=1,timesteps
     READ(102) U_G(:,I)
END DO

DO I=1,timesteps
     READ(103) U_S1(:,I)
END DO


!! create spatial deltas
DX(1)=2.0
x(1)=DX(1)
DO rc=2,RMAX
  DX(rc)=DX(rc-1)
  x(rc)=DX(rc)+x(rc-1)
END DO

DY(1)=2.0!0.375
y(1)=DY(1)
DO zc=2,YMAX
  DY(zc)=DY(zc-1)
  y(zc)=DY(zc)+y(zc-1)
END DO

DZ(1)=2.0
!z(1)=2240. !Z is in reverse compared to X & Y
DO zc=2,ZMAX
 DZ(zc)=DZ(zc-1)
 z(zc)=DY(zc)+x(zc-1)
END DO

I = 1
DO zc=1,ZMAX
     DO rc=1,RMAX
          DO yc=1,YMAX
                XX(rc,yc,zc)=x(rc)
                XXX(I,1)=XX(rc,yc,zc)
                YY(rc,yc,zc)=y(yc)
                YYY(I,1)=YY(rc,yc,zc)
                ZZ(rc,yc,zc)=z(zc)
                ZZZ(I,1)=ZZ(rc,yc,zc)
                y_boundary=-0.0022*(x(rc)**3)+0.1082*(x(rc)**2)-1.8888*x(rc)+12.817
                y_boundary=0.0
                plane = 0     
                IF (rc>2 .and. rc<RMAX-2) THEN
                         IF (yc >2 .and. yc<200) then
                         plane = topo3(rc-2, yc-2)-2*DZ(1)
                         END IF 

                         IF (zc>1 .and. zc<ZMAX-1) THEN
                                y_boundary=channel_topo(rc-2,zc-1)-2.*DY(1)
                         END IF
                     END IF
                topography(I)=y_boundary-y(yc)
                topo2(I)=y(yc)
                !topo4(I)=plane-z(zc)
                I=I+1
          END DO
     END DO
END DO

!Do I = 1,RMAX*ZMAX*YMAX
       ! WRITE(604,400) topo4(I),XXX(I,1),YYY(I,1),ZZZ(I,1)
   
!END DO

slabx1 = 200 
slabz1 = 100 
slabx2 = 600
slabz2 = 100


OPEN(231, FILE='slice_minima.txt')
OPEN(232, FILE='slice_maxima.txt')


DO t= 1,9
!t = 8 
DO I= 1, length1
 dpu(I,t)= (1-EP_G1(I,t))*1950*(U_S1(I,t)*U_S1(I,t))
 EP_P = -LOG10(1-EP_G1(I,t)+1e-14)
 IF ( EP_P .GT. 1.5 .AND. EP_P .LT. 6.5) THEN 
 !J = XXX(I,1)/2
 !bottom = tand(M)*2*(400-J)+20-18
  ! print*, EP_P
    IF( ZZZ(I,1) .EQ. 200) THEN
      !print*, EP_P, XXX(I,1) 
        IF( XXX(I,1) .EQ. 200) THEN 
        !dpu(I,t)= (1-EP_G1(I,t))*1950*(U_S1(I,t)*U_S1(I,t))
        WRITE(231,405) t, YYY(I,1), EP_P, U_G(I,t), T_G(I,t), dpu(I,t) 
               ! print*, YYY(I,1)                 
!       !        END IF
       END IF
       END IF

    IF( ZZZ(I,1) .EQ. 100) THEN
      !print*, EP_P, XXX(I,1) 
        IF( XXX(I,1) .EQ. 600) THEN
        WRITE(232,405) t, YYY(I,1), EP_P, U_G(I,t), T_G(I,t), dpu(I,t)
               ! print*, YYY(I,1)                 
!       !        END IF
       END IF
       END IF
   END IF
END DO
END DO 

405 FORMAT(I2, 5F22.12)
400 FORMAT(4F22.12)

END PROGRAM
