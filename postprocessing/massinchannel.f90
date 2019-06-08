PROGRAM GRAPHS 

IMPLICIT NONE

INTEGER :: t1,t2, clock_rate, clock_max
CHARACTER(LEN=1) :: junk
CHARACTER(LEN=10) :: str_c
character(LEN=10) :: x1
INTEGER:: MAX_REC = 1e9
INTEGER:: length1,count1,num_open,sum1,sum2
INTEGER:: ios, int_temp,int_check,int_pos1,int_min1,int_pos2,int_min2
DOUBLE PRECISION:: infinity = 1e30
INTEGER::yc,YMAX,I,J,K,IMAX,JMAX,KMAX,timesteps,RMAX,THMAX,ZMAX,rc,zc,tc,t,I_yp1,I_ym1,I_zp1,I_zm1,I_xp1,I_xm1,temp_rc
INTEGER::write_size,write_end,loop_open,fid_temp,fid_EP_P,fid_EP_G,fid_U, fid_ISO6,fid_GRAD4pt, fid_GRADsize,fid_GradV,fid_GradE  
INTEGER::fid_EP_G_t,fid_U_t,fid_ISO3,fid_Ri,fid_ROP1,fid_Dot, fid_dpu,fid_dpv
INTEGER:: fide, fidy, fidw
INTEGER::Z_minus,Z_plus,X_minus,Y_plus,Z_total,I_local

DOUBLE PRECISION,ALLOCATABLE::EP_P(:,:,:),Iso_6(:,:,:)
DOUBLE PRECISION,ALLOCATABLE::Iso_3(:,:,:),four_point_Iso3(:,:,:),four_point(:,:,:)
DOUBLE PRECISION, ALLOCATABLE :: T_G(:,:,:),U_G(:,:,:), VEL_6(:,:,:),VEL_3(:,:,:),VEL_ALL(:,:,:), VEL_temp(:,:), VEL_temp2(:,:), Richardson(:,:,:)
DOUBLE PRECISION, ALLOCATABLE :: Ri_Dilute(:,:,:), Ri_Dense(:,:,:),char_dense(:), char_dilute(:),VEL_DENSE(:,:), VEL_DILUTE(:,:)


DOUBLE PRECISION, ALLOCATABLE ::topo2(:),topography(:),EP_G1(:,:),XXX(:,:),YYY(:,:),ZZZ(:,:)
DOUBLE PRECISION, ALLOCATABLE :: T_G1(:,:), V_G1(:,:),U_G1(:,:),W_G1(:,:),T_S1(:,:),C_PG(:,:),C_PS1(:,:),C_PS2(:,:)
DOUBLE PRECISION, ALLOCATABLE :: ROP_S1(:,:), U_S1(:,:), SHUY(:,:), SHWY(:,:), V_S1(:,:)

INTEGER, ALLOCATABLE::Location_I(:,:)

DOUBLE PRECISION, ALLOCATABLE :: XX(:,:,:),YY(:,:,:),ZZ(:,:,:),channel_topo(:,:), dpu(:,:), dpv(:,:)
DOUBLE PRECISION, ALLOCATABLE :: DY(:),y(:),x(:),theta(:),z(:),DX(:),DTH(:),DZ(:),GZ(:)
DOUBLE PRECISION:: y_boundary,sum_p1, sum_p2, sum_p3, sum_p4,sum_mass,sum_E1,sum_E2,sum_EG
DOUBLE PRECISION:: P_const, R_vapor, R_dryair,char_length, Reynolds_N,rho_g,mu_g,rho_dry, rho_p,T_amb
DOUBLE PRECISION:: max_mag, current_density,top,bottom, max_dilute, min_dilute, max_dense, min_dense
DOUBLE PRECISION:: initial_ep_g,ROP1,ROP2,initial_vel,initial_temp,Area_flux,Gas_flux,Solid_flux,gravity,temp_val,local_vel
DOUBLE PRECISION::c_pos1, c_pos2, c_min1, c_min2, delta_V1, delta_V3, shear_v,delta_rho, Ri
DOUBLE PRECISION::Gas_Volume(1,5),Volume_Unit,Energy_In_G, CP_Go, Energy_In_S1,CP_S1o, Energy_In_S2, CP_S2o
DOUBLE PRECISION::mag_grad,norm_grad(1,3),temp_dot

DOUBLE PRECISION:: tmass, chmass, chmassd, inchannelw, inchanneld
REAL:: M
INTEGER:: ind1, width, depth, bins, fid_shear
DOUBLE PRECISION:: D, U0, ROP_0, gstar, Hstar, stokest, stokesv
DOUBLE PRECISION:: avgt, avgt2, avgt3, avgu, avgu2, avgu3, avgv, avgv2, avgv3, avgw, avgw2, avgw3, avgus, avgus2, avgus3, sum_1, sum_2, sum_3
DOUBLE PRECISION:: avgdpu, avgdpu3, avgdpu2

REAL :: W, center, amp, edge1, edge2, ds , lambda

!------------OPEN the binary files-----------!
OPEN(106, FILE='EP_P_t05.txt', form='formatted')
OPEN(100,FILE='EP_G',form='unformatted')

OPEN(602,FILE='topo_sin_20_l400_w50')
! Values are LOG Volume Fraction of Particles EP_P
!-------- Boundaries for Gradient Calculations -----------!
max_dense   = 2.5
min_dense   = 1.5
max_dilute  = 6.5
min_dilute  = 5.5
!-------- Boundaries for Gradient Calculations -----------!
!-------- Boundaries for Gradient Calculations -----------!

!--------------------------- Constants
!------------------------------------------!
Volume_Unit = 2.*2.*2.  !From your 3D grid dx, dy, dz
gravity = 9.81 !m^2/s
P_const = 1.0e5 !Pa
R_vapor = 461.5 !J/kg K
R_dryair = 287.058 !J kg/K
T_amb    = 273.0 !K
rho_dry  = P_const/(R_dryair*T_amb)  !kg/m**3
char_length = 20.0
mu_g        = 2.0e-5 !Pa s

rho_p = 1950 !kg/m^3
D = 5.0e-5 
stokesv = (2)*(rho_p-rho_dry)*gravity*(D*D)/(9*mu_g)


!-------- Set Size, Timesteps, and write size ------------!
timesteps=4
RMAX=404
ZMAX=152
YMAX=204
length1 = RMAX*ZMAX*YMAX

ALLOCATE( channel_topo(RMAX-4,ZMAX-2))
ALLOCATE( EP_G1(length1, 4))

ALLOCATE( ZZZ(length1,1))
ALLOCATE( YYY(length1,1))
ALLOCATE( XXX(length1,1))
ALLOCATE( topography(length1))
ALLOCATE( topo2(length1))

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


REWIND(106)
DO I = 1, length1
   READ(106,*) EP_G1(I,:)
END DO
 ! Format is RMAX*YMAX*ZMAX by timesteps, so loop
! through timesteps


!REWIND(101)
!DO I=1,timesteps
!     READ(101) T_G1(:,I)
!END DO


!NEW!!! 
DO I = 1, length1
   EP_G1(I,4) = abs(EP_G1(I,4))
END DO


rho_p = 1950
D = 5e-5
!stokesv = (2/9)*(rho_p-rho_dry)*gravity*(D**2)/mu_g

width = 50
edge1 = (300/2)-(width/2)
edge2 = ((300/2)+(width/2)) 
depth = 18
u0 = 10.0
ROP_0 = 0.10 
gstar = gravity !ROP_0*gravity*(rho_p/rho_dry)
Hstar = (u0*u0)/gstar 

stokest = Hstar/stokesv

print*, stokesv
print*, Hstar
print*, stokest

tmass = 0 
chmass= 0
chmassd = 0 
theta = 20.0

!-------------------------------READ TOPOGRAPHY----------------------------------!

!------------------------ Create spatial deltas and distances -------------------!
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
 z(zc)=DZ(zc)+z(zc-1)
END DO
!------------------------ Create spatial deltas and distances -------------------!

!------------------------------ Create grid matrices of length RMAX*ZMAX*YMAX ----------------------------!
I=1
DO zc=1,ZMAX
     DO rc=1,RMAX
          DO yc=1,YMAX
                XX(rc,yc,zc)=x(rc)
                XXX(I,1)=XX(rc,yc,zc)
                YY(rc,yc,zc)=y(yc)
                YYY(I,1)=YY(rc,yc,zc)
                ZZ(rc,yc,zc)=z(zc)
                ZZZ(I,1)=ZZ(rc,yc,zc)
                y_boundary= -0.0022*(x(rc)**3)+0.1082*(x(rc)**2)-1.8888*x(rc)+12.817
                y_boundary=0.0
                     IF (rc>2 .and. rc<RMAX-2) THEN
                         IF (zc>1 .and. zc<ZMAX-1) THEN
                                y_boundary=channel_topo(rc-2,zc-1)-2.*DY(1)
                         END IF
                     END IF
                topography(I)=y_boundary-y(yc)
                topo2(I)=y(yc)
                I=I+1
          END DO
     END DO
END DO
!------------------------------ Create grid matrices of length RMAX*ZMAX*YMAX ----------------------------!

!------------------------------ Read Binary and Set to Variable ----------------------------!
!REWIND(100)
!DO I=1,timesteps
!     READ(100) EP_G1(:,I) ! Format is RMAX*YMAX*ZMAX by timesteps, so l                     through timesteps
!END DO



DO t=1,timesteps
       ! fid_EP_P  = 1100+t
       ! fid_U     = 1200+t
       ! fid_ROP1    = 1350+t
       ! fid_ROP2    = 1400+t
       ! fid_temp    = 1250+t
       DO I=1,RMAX*ZMAX*YMAX
        
          EP_P(I,1,t) = -LOG10(1-EP_G1(I,t)+1e-14)
          EP_P(I,2,t) = XXX(I,1)
          EP_P(I,3,t) = YYY(I,1)
          EP_P(I,4,t) = ZZZ(I,1)
          !WRITE(fid_EP_P,400) EP_P(I,1:4,t)
          
       END DO
END DO 




print*, 'mass in channel'
OPEN(666, file='massinchannel.txt')
print *, "Done writing 3D variables"
DO t= 1,timesteps
chmass = 0
tmass = 0
chmassd = 0


center = (ZMAX-2)/2 + 25
amp = .2*(ZMAX-2)
lambda = RMAX-4

(400-J)+20-depth
    top = tand(M)*2*(400-J)+20

    ds = (J*360/lambda)*(0.0174533)
    edge1 = amp*sin(ds) + center + width/2
    edge2 = amp*sin(ds) + center - width/2


    IF (EP_P(I,3,t)>bottom) THEN
    IF (EP_P(I,1,t)<max_dilute) THEN
        IF (EP_P(I,1,t) >0.000) THEN
         tmass = tmass + ((EP_P(I,1,t))*Volume_Unit*rho_p)

        IF (EP_P(I,4,t) >edge1) THEN
         IF (EP_P(I,4,t) <edge2) THEN
         chmass = chmass + ((EP_P(I,1,t))*Volume_Unit*rho_p)
!         print*, "Mass in channel width", chmass

        IF (EP_P(I,3,t)>bottom) THEN
        IF (EP_P(I,3,t)<top) THEN
         chmassd = chmassd + ((EP_P(I,1,t))*Volume_Unit*rho_p)

!         print*, "Mass in channel depth", chmassd
        END IF
        END IF
       END IF
      END IF
    END IF
   END IF
  END IF
 END DO

WRITE(666, 403) chmass/tmass, 
END DO
!! done !!
print*, 'mass in channel'

400 FORMAT(4F22.12)
403 FORMAT(2F22.12)

END PROGRAM
