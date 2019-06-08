program column 


DOUBLE PRECISION, ALLOCATABLE:: ROP_S1(:,:)
DOUBLE PRECISION, ALLOCATABLE:: U_S1(:,:)
DOUBLE PRECISION, ALLOCATABLE:: V_G(:,:)
INTEGER:: RMAX, YMAX, ZMAX, I, LENGTH1, J, K
INTEGER:: timesteps, t, rc,zc,tc
DOUBLE PRECISION:: y_boundary, plane
DOUBLE PRECISION, ALLOCATABLE :: XX(:,:,:),YY(:,:,:),ZZ(:,:,:),channel_topo(:,:)
DOUBLE PRECISION, ALLOCATABLE :: DY(:),y(:),x(:),theta(:),z(:),DX(:),DTH(:),DZ(:),GZ(:)
DOUBLE PRECISION:: EP_P
DOUBLE PRECISION, ALLOCATABLE::topo2(:),topo3(:,:),topo4(:),topography(:),EP_G1(:,:),XXX(:,:),YYY(:,:),ZZZ(:,:)
REAL :: M, bottom
INTEGER:: fid_dpu, fid_dpv
character(LEN=10) :: x1
CHARACTER(LEN=10) :: str_c
DOUBLE PRECISION:: dpu
!! constants 

str_c = '(I2.2)'

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

OPEN(100, file='ROP_S1', form='unformatted')
OPEN(101, file='T_G', form='unformatted')
OPEN(102, file='U_S1', form='unformatted')

allocate(ROP_S1(length1, timesteps))
!allocate(T_G(length1, timesteps))
allocate(U_S1(length1, timesteps))

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
     READ(100) ROP_S1(:,I)
END DO

!REWIND(101)
!DO I=1,timesteps
!     READ(101) T_G(:,I)
!END DO

REWIND(102)
DO I=1,timesteps
     READ(102) U_S1(:,I)
END DO

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

DO t = 1,timesteps 
write(x1,str_c) t
num_open = 1400+t
  OPEN(num_open,FILE='dpu_t'//trim(x1)//'.txt')
END DO 
! ---- dynamic pressure calculation ----! 
DO t = 1,timesteps
        fid_dpu = 1400+t
        !fid_dpv = 1500+t
        !print*, fid_dpu
        DO I =1,ZMAX*RMAX*YMAX

                dpu = 0.5*ROP_S1(I,t)*U_S1(I,t)*U_S1(I,t)
   !            dpv = 0.5*ROP_S1(I,t)*((V_S1(I,t))**2)
         !       write(*,*) dpu
         !       IF (dpu .GT. 0) THEN
                !print*, dpu
                !END IF
                WRITE(fid_dpu, 400) dpu, XXX(I,1),YYY(I,1),ZZZ(I,1)
  !              WRITE(fid_dpv, 400) dpv, XXX(I,1),YYY(I,1),ZZZ(I,1)
        end do 
end do 


!dpu = 0.5*ROP_S1(15000,9)*U_S1(15000,9)*U_S1(15000,9)
! print*, dpu
405 FORMAT(4F22.12)
400 FORMAT(4F22.12)

END PROGRAM
